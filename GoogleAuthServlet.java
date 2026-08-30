package za.ac.Servlet;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.gson.GsonFactory;

import java.io.IOException;
import java.util.Collections;
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

@WebServlet(name = "GoogleAuthServlet", urlPatterns = {"/GoogleAuthServlet", "/GoogleAuthServlet.do"})
public class GoogleAuthServlet extends HttpServlet {

    private static final String CLIENT_ID = "983198702888-j2n21nvkgkddb10k5dk72m9rpn024h8s.apps.googleusercontent.com";

    @EJB
    private UserFacadeLocal ufl;

    @EJB
    private PersonalInfoEntityFacadeLocal pifl;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idTokenString = request.getParameter("idToken");

        if (idTokenString == null || idTokenString.isEmpty()) {
            request.setAttribute("errorMessage", "Google authentication token missing.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            // Use trusted Google NetHttpTransport to bypass local expired truststore issues
            HttpTransport transport = GoogleNetHttpTransport.newTrustedTransport();

            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    transport, new GsonFactory())
                    .setAudience(Collections.singletonList(CLIENT_ID))
                    .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);

            if (idToken != null) {
                Payload payload = idToken.getPayload();

                String email = payload.getEmail();
                boolean emailVerified = Boolean.valueOf(payload.getEmailVerified());
                String name = (String) payload.get("name");

                // Check if user already exists by email/username
                User user = ufl.findByUsername(email);

                if (user == null) {
                    // Sign-Up Flow: Register user automatically via Google
                    user = new User();
                    user.setUsername(email);
                    user.setPasswordHash("GOOGLE_AUTH_EXTERNAL");
                    user.setRole("USER");
                    user.setVerified(emailVerified);
                    ufl.create(user);

                    user = ufl.findByUsername(email);

                    PersonalInfoEntity pi = new PersonalInfoEntity();
                    pi.setFullname(name != null ? name : "");
                    pi.setEmail(email);
                    pi.setUser(user);
                    pifl.create(pi);
                }

                // Sign-In / Authentication Success
                HttpSession session = request.getSession(true);
                PersonalInfoEntity profile = pifl.findByUser(user);

                session.setAttribute("currentUser", user);
                session.setAttribute("PersonalInfo", profile);
                session.setAttribute("isRegistered", true);

                response.sendRedirect(request.getContextPath() + "/Dashboard.jsp");

            } else {
                request.setAttribute("errorMessage", "Invalid Google ID Token.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            log("Google Authentication Error", e);
            request.setAttribute("errorMessage", "Google Sign-In failed: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}