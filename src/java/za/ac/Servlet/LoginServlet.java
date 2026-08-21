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
 * Servlet handling user authentication and loading profile data into the
 * session.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet", "/LoginServlet.do"})
public class LoginServlet extends HttpServlet {

    @EJB
    private UserFacadeLocal ufl;

    @EJB
    private PersonalInfoEntityFacadeLocal profileFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests directly to login page instead of processing login logic
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Fetch login input parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validation for empty inputs
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Please provide both username and password.");
            RequestDispatcher disp = request.getRequestDispatcher("login.jsp");
            disp.forward(request, response);
            return;
        }

        try {
            // Find user by username
            User user = ufl.findByUsername(username.trim());

            // Validate credentials safely against nulls
            if (user != null && user.getPasswordHash() != null && user.getPasswordHash().equals(password)) {

                // Fetch associated PersonalInfoEntity profile safely
                PersonalInfoEntity profile = null;
                try {
                    profile = profileFacade.findByUser(user);
                } catch (Exception e) {
                    // Profile lookup fail-safe (allows user to log in even if profile record doesn't exist yet)
                    log("Profile load failed for user: " + username, e);
                }

                // Save entities and status in session for Dashboard.jsp
                session.setAttribute("currentUser", user);
                session.setAttribute("PersonalInfo", profile);
                session.setAttribute("isRegistered", true); // Marks user as logged in for future updates

                // Redirect to Dashboard
                response.sendRedirect(request.getContextPath() + "/Dashboard.jsp");
            } else {
                // Authentication failure
                request.setAttribute("errorMessage", "Invalid username or password. Please try again.");
                RequestDispatcher disp = request.getRequestDispatcher("login.jsp");
                disp.forward(request, response);
            }
        } catch (Exception e) {
            // Catch EJB exceptions gracefully to prevent StandardWrapperValve 500 errors
            log("Error during login process for user: " + username, e);
            request.setAttribute("errorMessage", "An error occurred while connecting to the authentication service.");
            RequestDispatcher disp = request.getRequestDispatcher("login.jsp");
            disp.forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Login Servlet handling user database verification and session profile setup.";
    }
}
