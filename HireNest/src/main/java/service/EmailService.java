package service;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class EmailService {

    private final Properties config = new Properties();

    public EmailService() {
        try (InputStream in = getClass().getClassLoader().getResourceAsStream("mail.properties")) {
            if (in == null) {
                throw new RuntimeException("mail.properties not found in src/main/resources");
            }
            config.load(in);
        } catch (IOException e) {
            throw new RuntimeException("Could not load mail.properties", e);
        }
    }

    private String require(String key) {
        String val = config.getProperty(key);
        if (val == null || val.isBlank()) {
            throw new RuntimeException("Missing key in mail.properties: " + key);
        }
        return val.trim();
    }

    private Session buildSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", require("mail.host"));
        props.put("mail.smtp.port", require("mail.port"));

        String user = require("mail.username");
        String pass = require("mail.password");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });
    }

    public void send(String toEmail, String subject, String plainText, String htmlText) {
        try {
            Session session = buildSession();
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(require("mail.from")));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject);

            if (htmlText != null && !htmlText.isBlank()) {
                msg.setContent(htmlText, "text/html; charset=UTF-8");
            } else {
                msg.setText(plainText != null ? plainText : "");
            }

            Transport.send(msg);
            System.out.println("✅ [EmailService] Sent to " + toEmail);
        } catch (MessagingException e) {
            e.printStackTrace();
            System.out.println("❌ [EmailService] Failed: " + e.getMessage());
            throw new RuntimeException("Failed to send email", e);
        }
    }

    public void sendOtp(String toEmail, String otp, String purpose) {
        try {
            Session session = buildSession();
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(require("mail.from")));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("HireNest - Email Verification Code");
            msg.setText("Hello,\n\nYour HireNest verification code is: " + otp + "\n\nPurpose: " + purpose + "\nExpires in 10 minutes.");

            Transport.send(msg);
            System.out.println("✅ REAL OTP SENT to " + toEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
            System.out.println("❌ FAILED TO SEND OTP: " + e.getMessage());
            throw new RuntimeException("Failed to send OTP", e);
        }
    }
}