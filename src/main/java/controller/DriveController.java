package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.DriveService;

import java.io.IOException;

@WebServlet("/drives")
public class DriveController extends HttpServlet {
    private final DriveService driveService = new DriveService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("drives", driveService.getOpenDrives());
        req.getRequestDispatcher("/WEB-INF/views/drives.jsp").forward(req, resp);
    }
}