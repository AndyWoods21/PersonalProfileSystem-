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
import za.ac.org.Reference;
import za.ac.org.User;


public class ReferenceServlet extends HttpServlet {

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

        List<Reference> list = em.createQuery(
                "SELECT r FROM Reference r WHERE r.user.id = :userId", Reference.class)
                .setParameter("userId", sessionUser.getId())
                .getResultList();

        request.setAttribute("referenceList", list);
        request.getRequestDispatcher("/manageReferences.jsp").forward(request, response);
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

        String name = request.getParameter("name");
        String jobTitle = request.getParameter("jobTitle");
        String company = request.getParameter("company");
        String email = request.getParameter("email");
        String testimonial = request.getParameter("testimonial");

        try {
            utx.begin();
            User userRef = em.find(User.class, sessionUser.getId());
            Reference ref = new Reference(name, jobTitle, company, email, testimonial);
            ref.setUser(userRef);
            em.persist(ref);
            utx.commit();
        } catch (Exception e) {
            try {
                if (utx != null) utx.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            throw new ServletException("Error saving Reference", e);
        }

        response.sendRedirect(request.getContextPath() + "/ReferenceServlet.do");
    }
}