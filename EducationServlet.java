package za.ac.Servlet;

import java.io.IOException;
import java.util.List;
import javax.annotation.Resource;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.transaction.UserTransaction;
import za.ac.org.Education;
import za.ac.org.User;


public class EducationServlet extends HttpServlet {

    @PersistenceContext
    private EntityManager em;

    @Resource
    private UserTransaction utx;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        List<Education> list = em.createQuery(
                "SELECT e FROM Education e WHERE e.user.id = :userId", Education.class)
                .setParameter("userId", sessionUser.getId())
                .getResultList();

        request.setAttribute("educationList", list);
        request.getRequestDispatcher("/manageEducation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String institutionName = request.getParameter("institutionName");
        String degree = request.getParameter("degree");
        String fieldOfStudy = request.getParameter("fieldOfStudy");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        try {
            utx.begin();
            User userRef = em.find(User.class, sessionUser.getId());
            Education edu = new Education(institutionName, degree, fieldOfStudy, startDate, endDate);
            edu.setUser(userRef);
            em.persist(edu);
            utx.commit();
        } catch (Exception e) {
            try {
                if (utx != null) utx.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            throw new ServletException("Error saving Education", e);
        }

        response.sendRedirect(request.getContextPath() + "/EducationServlet.do");
    }
}