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
import za.ac.org.User;
import za.ac.org.WorkExperience;

public class WorkExperienceServlet extends HttpServlet {

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

        List<WorkExperience> list = em.createQuery(
                "SELECT w FROM WorkExperience w WHERE w.user.id = :userId", WorkExperience.class)
                .setParameter("userId", sessionUser.getId())
                .getResultList();

        request.setAttribute("workList", list);
        request.getRequestDispatcher("/manageWorkExperience.jsp").forward(request, response);
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

        String companyName = request.getParameter("companyName");
        String jobTitle = request.getParameter("jobTitle");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String description = request.getParameter("description");

        try {
            utx.begin();
            em.joinTransaction(); // <-- Crucial when mixing UserTransaction with @PersistenceContext

            User userRef = em.find(User.class, sessionUser.getId());
            WorkExperience work = new WorkExperience(companyName, jobTitle, startDate, endDate, description);
            work.setUser(userRef);
            em.persist(work);

            utx.commit();
        } catch (Exception e) {
            try {
                if (utx != null) {
                    utx.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            throw new ServletException("Error saving WorkExperience", e);
        }

        response.sendRedirect(request.getContextPath() + "/WorkExperienceServlet.do");
    }
}
