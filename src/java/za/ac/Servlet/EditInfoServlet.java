package za.ac.Servlet;

import java.io.IOException;
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

@WebServlet(name = "EditInfoServlet", urlPatterns = {"/EditInfoServlet", "/EditInfoServlet.do"})
public class EditInfoServlet extends HttpServlet {

    @EJB
    private PersonalInfoEntityFacadeLocal pifl;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("editInfo.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
            // 2. Fetch fresh managed entity or create new one attached to currentUser
            PersonalInfoEntity profile = pifl.findByUser(currentUser);
            
            boolean isNew = false;
            if (profile == null) {
                profile = new PersonalInfoEntity();
                profile.setUser(currentUser);
                isNew = true;
            }

            // 3. Update field values from request parameters
            String fullname = request.getParameter("fullname");
            String title = request.getParameter("title");
            String location = request.getParameter("location");
            String bio = request.getParameter("bio");

            profile.setFullname(fullname != null ? fullname.trim() : "");
            profile.setJobTitle(title != null ? title.trim() : "");
            profile.setLocation(location != null ? location.trim() : "");
            profile.setProfessionalSummary(bio != null ? bio.trim() : "");

            // 4. Persist changes to database
            if (isNew) {
                pifl.create(profile);
            } else {
                pifl.edit(profile);
            }

            // 5. Refresh session attribute with saved entity and redirect
            session.setAttribute("PersonalInfo", profile);
            response.sendRedirect(request.getContextPath() + "/Dashboard.jsp");

        } catch (Exception e) {
            log("Error persisting profile updates for user: " + currentUser.getUsername(), e);
            
            // Extract root cause message to prevent displaying 'null' in the error banner
            Throwable cause = e;
            while (cause.getCause() != null) {
                cause = cause.getCause();
            }
            String errorMsg = (cause.getMessage() != null && !cause.getMessage().isEmpty()) 
                    ? cause.getMessage() 
                    : cause.getClass().getSimpleName();

            request.setAttribute("errorMessage", "Could not update profile details: " + errorMsg);
            request.getRequestDispatcher("editInfo.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles editing and persisting profile changes for logged-in users.";
    }
}