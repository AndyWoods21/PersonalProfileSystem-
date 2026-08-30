package za.ac.Servlet;

import java.io.IOException;
import java.util.ArrayList;
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

@WebServlet(name = "ConfirmSignUp", urlPatterns = {"/ConfirmSignUp", "/ConfirmSignUp.do"})
public class ConfirmSignUp extends HttpServlet {

    @EJB 
    private UserFacadeLocal ufl;

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
        PersonalInfoEntity pi = (PersonalInfoEntity) session.getAttribute("NewSignUp");
        User pendingUser = (User) session.getAttribute("pendingUser");

        if (pi == null || pendingUser == null) {
            session.setAttribute("errorMessage", "No registration details found to confirm. Please sign up again.");
            response.sendRedirect(request.getContextPath() + "/signUp.jsp");
            return;
        }
         
        try {
            // 1. Mark account verified and persist the User entity first
            pendingUser.setVerified(true);
            ufl.create(pendingUser);

            // 2. Fetch the managed/persisted User to guarantee primary key assignment
            User savedUser = ufl.findByUsername(pendingUser.getUsername());

            // 3. Link managed User to PersonalInfoEntity and persist
            pi.setUser(savedUser);
            pifl.create(pi);
            
            // 4. Set session attributes and empty collections
            session.setAttribute("currentUser", savedUser);
            session.setAttribute("PersonalInfo", pi);
            session.setAttribute("skillList", new ArrayList<>());
            session.setAttribute("workExperienceList", new ArrayList<>());
            session.setAttribute("educationList", new ArrayList<>());
            session.setAttribute("certificationList", new ArrayList<>());
            session.setAttribute("referenceList", new ArrayList<>());
            
            // 5. Clean up temporary registration attributes from session
            session.removeAttribute("NewSignUp");
            session.removeAttribute("pendingUser");
            
            // 6. Store success message and redirect to login
            session.setAttribute("successMessage", "Account created successfully! Please log in.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");

        } catch (Exception e) {
            log("Failed to persist user profile and credentials", e);
            request.setAttribute("errorMessage", "An error occurred while creating your profile. Please try again.");
            request.getRequestDispatcher("ConfirmSignUpdetails.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Finalizes registration by creating User and PersonalInfo entities, then redirects to login.jsp.";
    }
}
