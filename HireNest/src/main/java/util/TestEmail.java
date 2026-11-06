package util;

import service.EmailService;

public class TestEmail {
    public static void main(String[] args) {
        EmailService svc = new EmailService();
        svc.sendOtp("your-own-email@gmail.com", "123456", "RESET_PASSWORD");
        System.out.println("Done — check inbox");
    }
}