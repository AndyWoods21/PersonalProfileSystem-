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
            Date expiryTime = new Date(System.currentTimeMillis() + (10 * 60 * 1000));

            // 2. Create & persist User entity
            User user = createUser(username, password, otpCode, expiryTime);
            ufl.create(user);

            // 3. Retrieve managed User instance
            User savedUser = ufl.findByUsername(username);

            // 4. Create & link PersonalInfoEntity
            PersonalInfoEntity pi = createPI(fullName, email);
            pi.setUser(savedUser);
            pifl.create(pi);

            // 5. Send OTP Email with explicit exception logging
            boolean emailSent = true;
            try {
                EmailUtility.sendVerificationEmail(email, otpCode, request.getContextPath());
            } catch (Exception me) {
                emailSent = false;
                log("CRITICAL: Failed to send OTP email to " + email, me);
                me.printStackTrace();
            }

            // 6. Store full context in session
            session.setAttribute("pendingUser", savedUser);
            session.setAttribute("PersonalInfo", pi);
            session.setAttribute("userEmail", email); // Direct session backup for OTP resends
            session.setAttribute("isRegistered", Boolean.FALSE);

            if (!emailSent) {
                session.setAttribute("warningMessage", "Account created, but we could not deliver the OTP email. Please click 'Resend OTP'.");
            }

            // 7. Redirect to OTP verification page
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
}
