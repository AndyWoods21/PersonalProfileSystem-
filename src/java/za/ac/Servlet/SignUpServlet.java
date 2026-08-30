package za.ac.Servlet;

import java.io.IOException;
import java.util.Date;
import java.util.Random;
import javax.ejb.EJB;
import javax.mail.MessagingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import za.ac.bl.PersonalInfoEntityFacadeLocal;
import za.ac.bl.UserFacadeLocal;
import za.ac.org.PersonalInfoEntity;
import za.ac.org.User;
import za.ac.utility.EmailUtility;

/**
 * Handles initial user sign-up validation, account creation, and OTP email dispatch.
 */
@WebServlet(name = "SignUpServlet", urlPatterns = {"/SignUpServlet", "/SignUpServlet.do"})
public class SignUpServlet extends HttpServlet {

    @EJB
    private UserFacadeLocal ufl;

    @EJB
    private PersonalInfoEntityFacadeLocal pifl;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher disp = request.getRequestDispatcher("signUp.jsp");
        disp.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        // Validate basic parameters
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username, password, and email are required.");
            request.getRequestDispatcher("signUp.jsp").forward(request, response);
            return;
        }

        username = username.trim();
        email = email.trim();

        // Check if username already exists
        User existingUser = ufl.findByUsername(username);
        if (existingUser != null) {
            RequestDispatcher disp = request.getRequestDispatcher("AlreadyHaveAnAcc.jsp");
            disp.forward(request, response);
            return;
        }

        try {
            // 1. Generate 6-digit numeric OTP and set 10-minute expiry
            String otpCode = String.format("%06d", new Random().nextInt(900000) + 100000);
            long tenMinutesInMillis = 10 * 60 * 1000;
            Date expiryTime = new Date(System.currentTimeMillis() + tenMinutesInMillis);

            // 2. Create and persist User entity with OTP details
            User user = createUser(username, password, otpCode, expiryTime);
            ufl.create(user);

            // 3. Fetch managed User instance to guarantee persistence state
            User savedUser = ufl.findByUsername(username);

            // 4. Create and link PersonalInfoEntity with saved User
            PersonalInfoEntity pi = createPI(fullName, email);
            pi.setUser(savedUser);

            // 5. Persist PersonalInfoEntity explicitly using its facade
            pifl.create(pi);

            // 6. Send OTP Email asynchronously / non-blocking
            try {
                EmailUtility.sendVerificationEmail(email, otpCode, request.getContextPath());
            } catch (MessagingException me) {
                log("Failed to send OTP email to " + email, me);
            }

            // 7. Store pending user details in session for OTP verification
            session.setAttribute("pendingUser", savedUser);
            session.setAttribute("PersonalInfo", pi);
            session.setAttribute("NewSignUp", pi);
            session.setAttribute("isRegistered", Boolean.FALSE);

            // 8. Redirect cleanly to OTP verification page
            response.sendRedirect(request.getContextPath() + "/verifyOtp.jsp");

        } catch (Exception e) {
            log("Error during registration process", e);
            request.setAttribute("errorMessage", "Database error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("signUp.jsp").forward(request, response);
        }
    }

    private User createUser(String username, String password, String otpCode, Date expiryTime) {
        User user = new User();
        user.setUsername(username);
        user.setPasswordHash(password);
        user.setRole("USER");
        user.setVerified(false);
        user.setOtpCode(otpCode);
        user.setOtpExpiry(expiryTime);
        return user;
    }

    private PersonalInfoEntity createPI(String fullName, String email) {
        PersonalInfoEntity pi = new PersonalInfoEntity();
        pi.setFullname(fullName != null ? fullName.trim() : "");
        pi.setEmail(email != null ? email.trim() : "");
        return pi;
    }

    @Override
    public String getServletInfo() {
        return "Handles initial user sign-up validation, account creation, and OTP email dispatch.";
    }
}