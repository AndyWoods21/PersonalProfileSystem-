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
import za.ac.org.Certification;
import za.ac.org.User;


public class CertificationServlet extends HttpServlet {

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

        List<Certification> list = em.createQuery(
                "SELECT c FROM Certification c WHERE c.user.id = :userId", Certification.class)
                .setParameter("userId", sessionUser.getId())
                .getResultList();

        request.setAttribute("certificationList", list);
        request.getRequestDispatcher("/manageCertifications.jsp").forward(request, response);
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

        String title = request.getParameter("title");
        String issuingOrganization = request.getParameter("issuingOrganization");
        String issueDate = request.getParameter("issueDate");
        String credentialUrl = request.getParameter("credentialUrl");

        try {
            utx.begin();
            User userRef = em.find(User.class, sessionUser.getId());
            Certification cert = new Certification(title, issuingOrganization, issueDate, credentialUrl);
            cert.setUser(userRef);
            em.persist(cert);
            utx.commit();
        } catch (Exception e) {
            try {
                if (utx != null) utx.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            throw new ServletException("Error saving Certification", e);
        }

        response.sendRedirect(request.getContextPath() + "/CertificationServlet.do");
    }
}