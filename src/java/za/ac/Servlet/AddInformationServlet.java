package za.ac.Servlet;

import java.io.IOException;
import javax.ejb.EJB;
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

/**
 * Servlet handling multi-flow updates for optional profile details:
 * Flow 1: Registered user updating their existing profile.
 * Flow 2: Onboarding multi-step registration flow forwarding to confirmation.
 */
@WebServlet(name = "AddInformationServlet", urlPatterns = {"/AddInformationServlet", "/AddInformationServlet.do"})
public class AddInformationServlet extends HttpServlet { 

    @EJB
    private PersonalInfoEntityFacadeLocal pifl;

    @EJB
    private UserFacadeLocal ufl;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher disp = request.getRequestDispatcher("AddInformation.jsp");
        disp.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);

        // 1. Security check for active session
        if (session == null) {
            request.setAttribute("errorMessage", "Session expired. Please log in again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Extract registered user and check verification status
        User currentUser = (User) session.getAttribute("currentUser");

        // Verification Guard: Block unverified users from saving profile details
        if (currentUser != null && !currentUser.isVerified()) {
            request.setAttribute("errorMessage", "Please verify your email address before continuing.");
            request.getRequestDispatcher("AddInformation.jsp").forward(request, response);
            return;
        }

        // 2. Extract request parameters
        String title = request.getParameter("title");
        String location = request.getParameter("location");
        String bio = request.getParameter("bio");
        String website = request.getParameter("website");

        Boolean isRegisteredUser = (Boolean) session.getAttribute("isRegistered");
        PersonalInfoEntity pi = (PersonalInfoEntity) session.getAttribute("PersonalInfo");

        // 3. Fallback entity resolution for onboarding state
        if (pi == null) {
            pi = (PersonalInfoEntity) session.getAttribute("NewSignUp");
        }
        if (pi == null && currentUser != null && Boolean.TRUE.equals(isRegisteredUser)) {
            pi = pifl.findByUser(currentUser);
        }
        if (pi == null) {
            pi = new PersonalInfoEntity();
        }

        // 4. Validate session state for existing accounts
        if (Boolean.TRUE.equals(isRegisteredUser) && currentUser == null) {
            request.setAttribute("errorMessage", "Session expired or invalid state. Please log in again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // 5. Populate fields on the entity
        pi.setJobTitle(title != null ? title.trim() : "");
        pi.setLocation(location != null ? location.trim() : "");
        pi.setProfessionalSummary(bio != null ? bio.trim() : "");
        pi.setWebsiteUrl(website != null ? website.trim() : "");

        // Ensure user reference is set if present in session
        if (currentUser != null && pi.getUser() == null) {
            pi.setUser(currentUser);
        }

        try {
            // 6. Database Persistence / Edit Logic
            if (pi.getId() == null) {
                // If currentUser exists but is not yet persisted in DB, persist user first
                if (currentUser != null && currentUser.getId() == null) {
                    ufl.create(currentUser);
                    pi.setUser(currentUser);
                }
                pifl.create(pi);
            } else {
                pifl.edit(pi);
            }

            // 7. Sync updated entity back to HTTP session
            session.setAttribute("PersonalInfo", pi);
            session.setAttribute("NewSignUp", pi);

            // Flow 1: Existing registered user updating their profile from dashboard
            if (Boolean.TRUE.equals(isRegisteredUser)) {
                response.sendRedirect(request.getContextPath() + "/Dashboard.jsp");
                return;
            }

            // Flow 2: Onboarding registration flow -> Forward to confirmation
            RequestDispatcher disp = request.getRequestDispatcher("ConfirmSignUpdetails.jsp");
            disp.forward(request, response);

        } catch (Exception e) {
            // Print stack trace to server logs (GlassFish/Payara/Tomcat console)
            e.printStackTrace();
            log("Error persisting user profile for: " + (currentUser != null ? currentUser.getUsername() : "new sign up"), e);

            request.setAttribute("errorMessage", "Could not save profile details: " + e.getMessage());
            request.getRequestDispatcher("AddInformation.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Processes additional personal information fields during profile setup/edits.";
    }
}