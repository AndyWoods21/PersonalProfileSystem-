package za.ac.utility;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 * Utility class to handle email notifications and OTP verification workflows.
 */
public class EmailUtility {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SENDER_EMAIL = "buthelezia776@gmail.com";
    private static final String SENDER_PASSWORD = "magcnbegrbwcjsqw";

    /**
     * Sends an account verification email containing a 6-digit OTP code.
     */
    public static void sendVerificationEmail(String recipientEmail, String otpCode, String contextPath) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(SENDER_EMAIL));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
        message.setSubject("Your Email Verification Code");

        String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;'>"
                + "<h2>Account Verification</h2>"
                + "<p>Thank you for signing up! Please use the following 6-digit verification code to complete your registration:</p>"
                + "<div style='background-color: #f4f4f4; padding: 15px; text-align: center; border-radius: 6px; margin: 20px 0;'>"
                + "<span style='font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #2c3e50;'>" + otpCode + "</span>"
                + "</div>"
                + "<p>This code is valid for <strong>10 minutes</strong>.</p>"
                + "<p style='color: #777; font-size: 12px;'>If you did not request this code, please ignore this email.</p>"
                + "</div>";

        message.setContent(htmlContent, "text/html; charset=utf-8");
        Transport.send(message);
    }
}