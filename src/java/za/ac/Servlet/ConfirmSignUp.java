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

        if (pi == null) {
            request.setAttribute("errorMessage", "No registration details found to confirm. Please sign up again.");
            request.getRequestDispatcher("signUp.jsp").forward(request, response);
            return;
        }
         
        try {
            pifl.create(pi); // Persist completed profile entity to database
            
            // Clean up temporary sign-up session attribute
            session.removeAttribute("NewSignUp");
            
            // Forward to login page with success confirmation
            request.setAttribute("successMessage", "Account created successfully! Please log in.");
            RequestDispatcher disp = request.getRequestDispatcher("login.jsp");
            disp.forward(request, response);
        } catch (Exception e) {
            log("Failed to persist user profile", e);
            request.setAttribute("errorMessage", "An error occurred while creating your profile. Please try again.");
            request.getRequestDispatcher("ConfirmSignUpdetails.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Finalizes registration and persists PersonalInfoEntity into storage.";
    }
}