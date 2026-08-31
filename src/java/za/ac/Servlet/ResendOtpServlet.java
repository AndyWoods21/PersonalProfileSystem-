package za.ac.Servlet;

import java.io.IOException;
import java.util.Date;
import java.util.Random;
import javax.ejb.EJB;
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

@WebServlet(name = "ResendOtpServlet", urlPatterns = {"/ResendOtpServlet", "/ResendOtpServlet.do"})
public class ResendOtpServlet extends HttpServlet {

    @EJB
    private UserFacadeLocal ufl;

    @EJB
    private PersonalInfoEntityFacadeLocal pifl;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = null;
        String targetEmail = null;

        // 1. Resolve target user and email from session
        if (session != null) {
            user = (User) session.getAttribute("pendingUser");
            targetEmail = (String) session.getAttribute("userEmail");
            
            if (targetEmail == null && session.getAttribute("PersonalInfo") != null) {
                PersonalInfoEntity pi = (PersonalInfoEntity) session.getAttribute("PersonalInfo");
                targetEmail = pi.getEmail();
            }
        }

        // 2. Resolve target email from request URL parameters (if session dropped)
        if (targetEmail == null || targetEmail.trim().isEmpty()) {
            targetEmail = request.getParameter("email");
        }

        // 3. Fallback database lookup via PersonalInfoEntity if user object is null
        if (user == null && targetEmail != null && !targetEmail.trim().isEmpty()) {
            PersonalInfoEntity pi = pifl.findByEmail(targetEmail.trim());
            if (pi != null) {
                user = pi.getUser();
            } else {
                user = ufl.findByUsername(targetEmail.trim());
            }
        }

        // 4. Fail gracefully if no email/user context could be resolved
        if (user == null || targetEmail == null || targetEmail.trim().isEmpty()) {
            request.setAttribute("errorMessage", "No email address found for this account. Please log in again.");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            return;
        }

        // 5. Regenerate OTP and update expiration
        String newOtp = String.format("%06d", new Random().nextInt(900000) + 100000);
        user.setOtpCode(newOtp);
        user.setOtpExpiry(new Date(System.currentTimeMillis() + (10 * 60 * 1000)));
        ufl.edit(user);

        // 6. Resend email and update session state
        try {
            EmailUtility.sendVerificationEmail(targetEmail, newOtp, request.getContextPath());
            
            if (session != null) {
                session.setAttribute("pendingUser", user);
                session.setAttribute("userEmail", targetEmail);
            }

            request.setAttribute("successMessage", "A new OTP has been sent to " + targetEmail);
        } catch (Exception e) {
            log("Failed to resend OTP email to " + targetEmail, e);
            request.setAttribute("errorMessage", "Failed to send email: " + e.getMessage());
        }

        request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
    }
}
