package za.ac.Servlet;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.PersistenceException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import za.ac.org.Certification;
import za.ac.org.Education;
import za.ac.org.PersonalInfoEntity;
import za.ac.org.Reference;
import za.ac.org.Skill;
import za.ac.org.User;
import za.ac.org.WorkExperience;

@WebServlet(name = "ViewProfileServlet", urlPatterns = {"/ViewProfileServlet", "/ViewProfileServlet.do"})
public class ViewProfileServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ViewProfileServlet.class.getName());

    @PersistenceContext
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath() != null ? request.getContextPath() : "";

        // 1. Guard against Null / Empty parameter
        String username = request.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect(contextPath + "/DisplayConnections.jsp");
            return;
        }

        String trimmedUsername = username.trim();

        try {
            if (em == null) {
                LOGGER.severe("EntityManager is not injected or initialized.");
                response.sendRedirect(contextPath + "/DisplayConnections.jsp?error=server");
                return;
            }

            // 2. Fetch target user safely
            User profileUser = null;
            try {
                profileUser = em.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class)
                        .setParameter("username", trimmedUsername)
                        .getSingleResult();
            } catch (NoResultException e) {
                response.sendRedirect(contextPath + "/DisplayConnections.jsp?error=notfound");
                return;
            }

            if (profileUser == null || profileUser.getId() == null) {
                response.sendRedirect(contextPath + "/DisplayConnections.jsp?error=notfound");
                return;
            }

            Long userId = profileUser.getId();

            // 3. Fetch personal details safely
            PersonalInfoEntity personalInfo = null;
            try {
                personalInfo = em.createQuery("SELECT p FROM PersonalInfoEntity p WHERE p.user.id = :userId", PersonalInfoEntity.class)
                        .setParameter("userId", userId)
                        .getSingleResult();
            } catch (Exception e) {
                // Personal info is optional
                personalInfo = null;
            }

            // 4. Fetch profile sections safely (isolated try-catch for persistence errors)
            List<WorkExperience> workList = safeQueryList(
                    "SELECT w FROM WorkExperience w WHERE w.user.id = :userId", WorkExperience.class, userId);

            List<Education> eduList = safeQueryList(
                    "SELECT e FROM Education e WHERE e.user.id = :userId", Education.class, userId);

            List<Skill> skillList = safeQueryList(
                    "SELECT s FROM Skill s WHERE s.user.id = :userId", Skill.class, userId);

            List<Certification> certList = safeQueryList(
                    "SELECT c FROM Certification c WHERE c.user.id = :userId", Certification.class, userId);

            List<Reference> refList = safeQueryList(
                    "SELECT r FROM Reference r WHERE r.user.id = :userId", Reference.class, userId);

            // 5. Pass data to request
            request.setAttribute("profileUser", profileUser);
            request.setAttribute("personalInfo", personalInfo);
            request.setAttribute("workList", workList);
            request.setAttribute("eduList", eduList);
            request.setAttribute("skillList", skillList);
            request.setAttribute("certList", certList);
            request.setAttribute("refList", refList);

            request.getRequestDispatcher("/SpecificProfileDisplay.jsp").forward(request, response);

        } catch (PersistenceException pe) {
            LOGGER.log(Level.SEVERE, "Database error retrieving profile for: " + trimmedUsername, pe);
            response.sendRedirect(contextPath + "/DisplayConnections.jsp?error=dberror");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error retrieving profile for: " + trimmedUsername, e);
            response.sendRedirect(contextPath + "/DisplayConnections.jsp?error=true");
        }
    }

    /**
     * Helper method to execute JPA queries safely and return an empty list on failure.
     */
    private <T> List<T> safeQueryList(String qlString, Class<T> clazz, Long userId) {
        try {
            List<T> result = em.createQuery(qlString, clazz)
                    .setParameter("userId", userId)
                    .getResultList();
            return (result != null) ? result : Collections.emptyList();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to query " + clazz.getSimpleName() + " for userId: " + userId, e);
            return Collections.emptyList();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}