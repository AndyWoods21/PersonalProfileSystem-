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
import za.ac.org.PersonalInfoEntity;
import za.ac.org.User;

@WebServlet(name = "AddInformationServlet", urlPatterns = {"/AddInformationServlet", "/AddInformationServlet.do"})
public class AddInformationServlet extends HttpServlet {

    @EJB
    private PersonalInfoEntityFacadeLocal pifl;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        String title = request.getParameter("title");
        String location = request.getParameter("location");
        String bio = request.getParameter("bio");

        Boolean isRegisteredUser = (Boolean) session.getAttribute("isRegistered");
        PersonalInfoEntity pi = null;

        // Determine entity source based on registration status
        if (Boolean.TRUE.equals(isRegisteredUser)) {
            pi = (PersonalInfoEntity) session.getAttribute("PersonalInfo");
        } else {
            pi = (PersonalInfoEntity) session.getAttribute("NewSignUp");
            if (pi == null) {
                // Initialize if navigating from initial sign-up step
                pi = new PersonalInfoEntity();
            }
        }

        User currentUser = (User) session.getAttribute("currentUser");

        // Fail-safe check if registered user session is lost
        if (Boolean.TRUE.equals(isRegisteredUser) && pi == null) {
            request.setAttribute("errorMessage", "Session expired or invalid state. Please log in again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Update entity attributes
        pi.setJobTitle(title != null ? title.trim() : "");
        pi.setLocation(location != null ? location.trim() : "");
        pi.setProfessionalSummary(bio != null ? bio.trim() : "");
        
        // Link target user entity if available
        if (currentUser != null && pi.getUser() == null) {
            pi.setUser(currentUser);
        }

        // Flow 1: Registered User Editing Profile from Dashboard
        if (Boolean.TRUE.equals(isRegisteredUser)) {
            try {
                pifl.edit(pi); // Persist updates directly to DB
                session.setAttribute("PersonalInfo", pi);
                response.sendRedirect(request.getContextPath() + "/Dashboard.jsp");
                return;
            } catch (Exception e) {
                getServletContext().log("Error updating user profile", e);
                request.setAttribute("errorMessage", "Could not update profile details.");
                request.getRequestDispatcher("AddInformation.jsp").forward(request, response);
                return;
            }
        }

        // Flow 2: Unconfirmed Sign-Up Registration
        session.setAttribute("NewSignUp", pi);
        RequestDispatcher disp = request.getRequestDispatcher("ConfirmSignUpdetails.jsp");
        disp.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Processes additional personal information fields during profile setup/edits.";
    }
}