package za.ac.Servlet;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Date;
import javax.ejb.EJB;
import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import za.ac.bl.UserFacadeLocal;
import za.ac.org.User;
import za.ac.utility.EmailUtility;

/**
 * Handles generating and emailing a fresh 6-digit OTP code when requested by the user.
 */
@WebServlet(name = "ResendOtpServlet", urlPatterns = {"/ResendOtpServlet", "/ResendOtpServlet.do"})
public class ResendOtpServlet extends HttpServlet {

    @EJB
    private UserFacadeLocal ufl;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User pendingUser = (session != null) ? (User) session.getAttribute("pendingUser") : null;

        // 1. Verify that user session exists
        if (pendingUser == null) {
            request.setAttribute("errorMessage", "Session expired. Please sign up or log in again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // 2. Fetch up-to-date user instance from database
        User user = ufl.find(pendingUser.getId());
        if (user == null) {
            request.setAttribute("errorMessage", "Account not found. Please register again.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // Extract recipient email (checks personalInfo relationship or falls back to username if it's an email)
        String recipientEmail = null;
        if (user.getPersonalInfo() != null && user.getPersonalInfo().getEmail() != null) {
            recipientEmail = user.getPersonalInfo().getEmail();
        } else if (user.getUsername() != null && user.getUsername().contains("@")) {
            recipientEmail = user.getUsername();
        }

        if (recipientEmail == null || recipientEmail.trim().isEmpty()) {
            request.setAttribute("errorMessage", "No email address found for this account.");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            return;
        }

        // 3. Generate a fresh 6-digit OTP code and set 10-minute expiry
        String newOtp = generateOtpCode();
        long tenMinutesInMillis = 10 * 60 * 1000;
        Date expiryDate = new Date(System.currentTimeMillis() + tenMinutesInMillis);

        user.setOtpCode(newOtp);
        user.setOtpExpiry(expiryDate);
        ufl.edit(user);

        // Update pendingUser session object state
        session.setAttribute("pendingUser", user);

        // 4. Send email containing new OTP
        try {
            EmailUtility.sendVerificationEmail(recipientEmail, newOtp, request.getContextPath());
            request.setAttribute("successMessage", "A new OTP code has been sent to your email.");
        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to send email. Please try again shortly.");
        }

        // 5. Return user to OTP input view
        request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Helper method to generate a cryptographically secure 6-digit numeric OTP string.
     */
    private String generateOtpCode() {
        SecureRandom random = new SecureRandom();
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }

    @Override
    public String getServletInfo() {
        return "Generates and sends a new 6-digit OTP code for pending email verifications.";
    }
}