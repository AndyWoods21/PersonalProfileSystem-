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

@WebServlet(name = "SignUpServlet", urlPatterns = {"/SignUpServlet", "/SignUpServlet.do"})
public class SignUpServlet extends HttpServlet {

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

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        // Validate basic parameters
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("signUp.jsp").forward(request, response);
            return;
        }

        username = username.trim();

        // Check if username already exists
        User existingUser = ufl.findByUsername(username);
        if (existingUser != null) {
            RequestDispatcher disp = request.getRequestDispatcher("AlreadyHaveAnAcc.jsp");
            disp.forward(request, response);
            return;
        }

        // Create initial entity instances
        User user = createUser(username, password);
        PersonalInfoEntity pi = createPI(fullName, email);
        pi.setUser(user);

        try {
            ufl.create(user); // Persist new user account
            
            // Store created entities in session for step 2 (AddInformation.jsp)
            session.setAttribute("currentUser", user);
            session.setAttribute("PersonalInfo", pi);
            session.setAttribute("isRegistered", false); // Unconfirmed sign-up state

            RequestDispatcher disp = request.getRequestDispatcher("AddInformation.jsp");
            disp.forward(request, response);
        } catch (Exception e) {
            log("Error during registration process", e);
            request.setAttribute("errorMessage", "Database error occurred during registration.");
            request.getRequestDispatcher("signUp.jsp").forward(request, response);
        }
    }

    private User createUser(String username, String password) {
        User user = new User();
        user.setUsername(username);
        user.setPasswordHash(password);
        user.setRole("USER");
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
        return "Handles initial user sign-up validation and account creation.";
    }
}