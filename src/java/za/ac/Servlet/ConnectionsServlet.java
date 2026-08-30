package za.ac.Servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
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

@WebServlet(name = "ConnectionsServlet", urlPatterns = {"/ConnectionsServlet", "/ConnectionsServlet.do"})
public class ConnectionsServlet extends HttpServlet {

    @EJB
    private PersonalInfoEntityFacadeLocal pifl;

    @EJB
    private UserFacadeLocal userFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // 1. Session Gatekeeper
        if (currentUser == null) {
            request.setAttribute("errorMessage", "Session expired. Please log in again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            // 2. Retrieve all registered users
            List<User> allUsers = userFacade.findAll();
            List<PersonalInfoEntity> connections = new ArrayList<>();

            // 3. Match profiles or attach default objects for users without profile records
            for (User u : allUsers) {
                PersonalInfoEntity profile = pifl.findByUser(u);
                if (profile == null) {
                    profile = new PersonalInfoEntity();
                    profile.setUser(u);
                }
                connections.add(profile);
            }

            // 4. Attach list to request scope and forward to JSP
            request.setAttribute("connectionsList", connections);
            request.getRequestDispatcher("DisplayConnections.jsp").forward(request, response);

        } catch (Exception e) {
            log("Error retrieving public connections directory: ", e);
            request.setAttribute("errorMessage", "Failed to load directory: " + e.getMessage());
            request.getRequestDispatcher("Dashboard.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Retrieves all public profiles for developer connection matching.";
    }
}