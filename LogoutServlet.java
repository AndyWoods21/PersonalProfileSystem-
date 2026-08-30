package za.ac.Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet", "/LogoutServlet.do"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Fetch current session without creating a new one
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Invalidate session and destroy CDI bean scopes
            session.invalidate();
        }

        // Send a clean 302 redirect back to the login page
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Handles user session termination and logout redirection.";
    }
}