package za.ac.Servlet;

import za.ac.bl.PersonalInfoEntityFacadeLocal;
import za.ac.bl.UserFacadeLocal;
import za.ac.org.PersonalInfoEntity;
import za.ac.org.User;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;

/**
 * PublicProfileServlet handles public routing for developer profiles.
 * Mapped in web.xml as /PublicProfileServlet.do
 * URL Format: /PublicProfileServlet.do?user=username
 */
@WebServlet(name = "PublicProfileServlet", urlPatterns = {"/PublicProfileServlet", "/PublicProfileServlet.do"})
public class PublicProfileServlet extends HttpServlet {

    @EJB
    private UserFacadeLocal userFacade;

    @EJB
    private PersonalInfoEntityFacadeLocal personalInfoFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Extract requested username parameter from query string
        String username = request.getParameter("user");

        // Validate username parameter presence
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("errorMessage", "No developer profile specified.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        try {
            // Find target user account by username
            User targetUser = userFacade.findByUsername(username.trim());

            if (targetUser == null) {
                request.setAttribute("errorMessage", "Developer profile '" + username + "' not found.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Retrieve corresponding profile information
            PersonalInfoEntity profileInfo = personalInfoFacade.findByUser(targetUser);

            // Bind data to request scope and forward to JSP view
            request.setAttribute("publicUser", targetUser);
            request.setAttribute("publicProfile", profileInfo);
            RequestDispatcher disp =
            request.getRequestDispatcher("publicProfile.jsp");
            disp.forward(request, response);

        } catch (Exception e) {
            getServletContext().log("Error fetching public profile for username: " + username, e);
            request.setAttribute("errorMessage", "An error occurred while loading the public profile.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Delegate POST requests to GET handler
        doGet(request, response);
    }
}