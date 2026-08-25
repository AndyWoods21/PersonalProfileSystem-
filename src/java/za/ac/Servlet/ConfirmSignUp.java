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
import za.ac.org.PersonalInfoEntity;
import za.ac.org.User;

@WebServlet(name = "ConfirmSignUp", urlPatterns = {"/ConfirmSignUp", "/ConfirmSignUp.do"})
public class ConfirmSignUp extends HttpServlet {

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
        User currentUser = (User) session.getAttribute("currentUser");

        if (pi == null) {
            session.setAttribute("errorMessage", "No registration details found to confirm. Please sign up again.");
            response.sendRedirect(request.getContextPath() + "/signUp.jsp");
            return;
        }
         
        try {
            // Bind the User entity to PersonalInfoEntity prior to creation
            if (currentUser != null && pi.getUser() == null) {
                pi.setUser(currentUser);
            }

            pifl.create(pi); // Persist completed profile entity to database
            
            // Set PersonalInfo and initialize empty lists in session scope
            session.setAttribute("PersonalInfo", pi);
            session.setAttribute("skillsList", new ArrayList<>());
            session.setAttribute("workExperienceList", new ArrayList<>());
            session.setAttribute("educationList", new ArrayList<>());
            session.setAttribute("certificationsList", new ArrayList<>());
            session.setAttribute("referencesList", new ArrayList<>());
            
            // Clean up temporary sign-up session attribute
            session.removeAttribute("NewSignUp");
            
            // Store success message in session so it survives redirect
            session.setAttribute("successMessage", "Account created successfully! Please log in.");
            
            // Redirect to login page
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } catch (Exception e) {
            log("Failed to persist user profile", e);
            request.setAttribute("errorMessage", "An error occurred while creating your profile. Please try again.");
            request.getRequestDispatcher("ConfirmSignUpdetails.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Finalizes registration and redirects user to login.jsp.";
    }
}
