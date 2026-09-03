package za.ac.Servlet;

import java.io.IOException;
import java.util.Date;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import za.ac.bl.UserFacadeLocal;
import za.ac.org.User;

/**
 * Handles OTP form submissions, validates code expiration, and activates user accounts.
 */
@WebServlet(name = "VerifyEmailServlet", urlPatterns = {"/VerifyEmailServlet", "/VerifyOtpServlet", "/VerifyEmailServlet.do"})
public class VerifyEmailServlet extends HttpServlet {

    @EJB
    private UserFacadeLocal ufl;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        RequestDispatcher disp = request.getRequestDispatcher("verifyOtp.jsp");
        disp.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        // Changed "otpCode" to "otp" to match the JSP input field name
        String enteredOtp = request.getParameter("otp");

        // 1. Basic input validation
        if (enteredOtp == null || enteredOtp.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter the 6-digit OTP code sent to your email.");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            return;
        }

        enteredOtp = enteredOtp.trim();

        // 2. Identify user from session or lookup database by OTP code
        User user = null;
        if (session != null && session.getAttribute("pendingUser") != null) {
            User pending = (User) session.getAttribute("pendingUser");
            user = ufl.find(pending.getId());
        }

        if (user == null) {
            user = ufl.findByOtpCode(enteredOtp);
        }

        // 3. Validate user existence and OTP match
        if (user == null || user.getOtpCode() == null || !user.getOtpCode().equals(enteredOtp)) {
            request.setAttribute("errorMessage", "Invalid OTP code. Please check and try again.");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            return;
        }

        // 4. Validate OTP expiration timestamp
        Date now = new Date();
        if (user.getOtpExpiry() == null || now.after(user.getOtpExpiry())) {
            request.setAttribute("errorMessage", "The OTP code has expired. Please request a new one.");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            return;
        }

        // 5. Update user status, clear OTP security details, and save
        user.setVerified(true);
        user.setOtpCode(null);
        user.setOtpExpiry(null);
        ufl.edit(user);

        // 6. Clean up pending session state and promote user session
        if (session != null) {
            session.removeAttribute("pendingUser");
            session.setAttribute("currentUser", user);
            session.setAttribute("isRegistered", Boolean.TRUE);
        }

        // 7. Proceed to next onboarding step
        response.sendRedirect(request.getContextPath() + "/AddInformation.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Processes 6-digit OTP verification codes, validates expiration, and activates user accounts.";
    }
}