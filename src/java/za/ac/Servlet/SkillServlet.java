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
import za.ac.org.Skill;
import za.ac.org.User;


public class SkillServlet extends HttpServlet {

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

        List<Skill> list = em.createQuery(
                "SELECT s FROM Skill s WHERE s.user.id = :userId", Skill.class)
                .setParameter("userId", sessionUser.getId())
                .getResultList();

        request.setAttribute("skillList", list);
        request.getRequestDispatcher("/manageSkills.jsp").forward(request, response);
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

        String skillName = request.getParameter("skillName");
        String category = request.getParameter("category");
        String proficiencyLevel = request.getParameter("proficiencyLevel");

        try {
            utx.begin();
            User userRef = em.find(User.class, sessionUser.getId());
            Skill skill = new Skill(skillName, category, proficiencyLevel);
            skill.setUser(userRef);
            em.persist(skill);
            utx.commit();
        } catch (Exception e) {
            try {
                if (utx != null) utx.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            throw new ServletException("Error saving Skill", e);
        }

        response.sendRedirect(request.getContextPath() + "/SkillServlet.do");
    }
}