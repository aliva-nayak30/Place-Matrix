package controller;

import com.google.api.client.googleapis.auth.oauth2.*;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import dao.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.Properties;

@WebServlet("/google-callback")
public class GoogleCallbackController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect("login.jsp?error=Google+login+failed");
            return;
        }

        try {
            Properties props = new Properties();
            try (InputStream in = getClass().getClassLoader().getResourceAsStream("google.properties")) {
                props.load(in);
            }
            String clientId = props.getProperty("google.client.id");
            String clientSecret = props.getProperty("google.client.secret");
            String redirectUri = props.getProperty("google.redirect.uri");

            NetHttpTransport transport = new NetHttpTransport();
            GsonFactory jsonFactory = GsonFactory.getDefaultInstance();

            // 1. Exchange code for tokens
            GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    transport, jsonFactory, clientId, clientSecret, code, redirectUri
            ).execute();

            // 2. Verify ID Token
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(transport, jsonFactory)
                    .setAudience(Collections.singletonList(clientId))
                    .build();

            GoogleIdToken idToken = verifier.verify(tokenResponse.getIdToken());
            if (idToken == null) {
                response.sendRedirect("login.jsp?error=Invalid+Google+Token");
                return;
            }

            GoogleIdToken.Payload payload = idToken.getPayload();
            String email = payload.getEmail();
            String name = (String) payload.get("name");

            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmail(email);

            if (user == null) {
                // Create new user with Google Auth
                user = new User();
                user.setName(name);
                user.setEmail(email);
                user.setPassword("OAUTH_USER_" + System.currentTimeMillis()); // Dummy password
                user.setRole("STUDENT"); // Default to student
                user.setActive(true);
                user.setEmailVerified(true); // Google emails are pre-verified
                userDAO.saveUser(user);
                user = userDAO.findByEmail(email); // Reload to get ID
            }

            // 3. Log user in
            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userName", user.getName());
            session.setAttribute("role", user.getRole());
            session.setAttribute("collegeId", user.getCollegeId());

            if ("STUDENT".equals(user.getRole())) {
                response.sendRedirect("student/dashboard.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Google+Authentication+Error");
        }
    }
}