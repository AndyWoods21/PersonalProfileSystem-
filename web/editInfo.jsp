<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="za.ac.org.PersonalInfoEntity" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Security Gatekeeper: Check if user is logged in --%>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login.jsp?error=unauthorized" />
</c:if>

<%
    // Retrieve profile data from session
    PersonalInfoEntity profile = (PersonalInfoEntity) session.getAttribute("PersonalInfo");
    if (profile == null) {
        profile = new PersonalInfoEntity();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile — DevProfile</title>
    <style>
        :root {
            --bg-main: rgba(255, 255, 255, 0.95);
            --bg-gray: #F8FAFC;
            --card-cream: rgba(253, 248, 240, 0.95);
            --card-dark: rgba(26, 26, 46, 0.95);
            --text-dark: #111111;
            --text-muted: #64748B;
            --accent-green: #22C55E;
            --accent-blue: #0284C7;
            --navy-cta: #1A1A2E;
            --danger-color: #EF4444;
            --border-color: #E2E8F0;
            --shadow-soft: 0 10px 25px -5px rgba(0, 0, 0, 0.08), 0 8px 10px -6px rgba(0, 0, 0, 0.03);
            --radius-lg: 24px;
            --radius-md: 16px;
            --radius-pill: 9999px;
            --input-bg: #FFFFFF;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: url('${pageContext.request.contextPath}/background.jpg') no-repeat center center fixed;
            background-size: cover;
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Top Navigation Header */
        header {
            background-color: var(--bg-main);
            border-bottom: 1px solid var(--border-color);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
            backdrop-filter: blur(8px);
        }

        .logo {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--navy-cta);
            text-decoration: none;
            letter-spacing: -0.5px;
        }

        .user-nav {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .badge {
            background-color: #F1F5F9;
            color: var(--navy-cta);
            border: 1px solid var(--border-color);
            padding: 0.35rem 0.75rem;
            border-radius: var(--radius-pill);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }

        .btn-action-sm {
            background-color: var(--navy-cta);
            color: #FFFFFF;
            padding: 0.45rem 0.9rem;
            border-radius: var(--radius-pill);
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            transition: opacity 0.2s;
        }

        .btn-action-sm:hover {
            opacity: 0.9;
        }

        .btn-logout {
            background-color: transparent;
            color: var(--danger-color);
            border: 1px solid var(--danger-color);
            padding: 0.4rem 0.85rem;
            border-radius: var(--radius-pill);
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-logout:hover {
            background-color: var(--danger-color);
            color: #FFFFFF;
        }

        /* App Layout Container */
        .app-container {
            display: flex;
            flex: 1;
            max-width: 1280px;
            width: 100%;
            margin: 0 auto;
        }

        /* Left Sidebar Menu */
        .sidebar {
            width: 260px;
            background-color: var(--bg-main);
            border-right: 1px solid var(--border-color);
            padding: 1.75rem 1rem;
            display: flex;
            flex-direction: column;
            gap: 1.75rem;
            flex-shrink: 0;
            backdrop-filter: blur(8px);
        }

        .sidebar-section-title {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: var(--text-muted);
            padding: 0 0.75rem;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .nav-menu {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
        }

        .nav-item a {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.65rem 0.85rem;
            color: var(--text-dark);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            border-radius: var(--radius-md);
            transition: all 0.2s ease;
        }

        .nav-item a:hover {
            background-color: var(--card-cream);
        }

        .nav-item.active a {
            background-color: var(--navy-cta);
            color: #FFFFFF;
            font-weight: 600;
        }

        /* Main Content Area */
        main {
            flex: 1;
            padding: 2rem;
            max-width: 850px;
        }

        .card {
            background-color: var(--bg-main);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 2rem;
            box-shadow: var(--shadow-soft);
            backdrop-filter: blur(8px);
        }

        .card h2 {
            font-size: 1.5rem;
            font-weight: 800;
            letter-spacing: -0.5px;
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid var(--border-color);
        }

        .alert-error {
            background-color: rgba(239, 68, 68, 0.1);
            color: var(--danger-color);
            padding: 0.85rem 1rem;
            border-radius: var(--radius-md);
            margin-bottom: 1.5rem;
            border: 1px solid rgba(239, 68, 68, 0.2);
            font-size: 0.9rem;
            font-weight: 500;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            font-size: 0.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 0.85rem 1rem;
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            color: var(--text-dark);
            font-size: 0.95rem;
            font-family: inherit;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input[type="text"]:focus,
        textarea:focus {
            outline: none;
            border-color: var(--navy-cta);
            box-shadow: 0 0 0 3px rgba(26, 26, 46, 0.1);
        }

        textarea {
            resize: vertical;
            min-height: 130px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 1.25rem;
            border-top: 1px solid var(--border-color);
        }

        .btn-submit {
            background-color: var(--navy-cta);
            color: #FFFFFF;
            padding: 0.65rem 1.5rem;
            border: none;
            border-radius: var(--radius-pill);
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.2s;
        }

        .btn-submit:hover {
            opacity: 0.9;
        }

        .btn-cancel {
            background-color: transparent;
            color: var(--text-muted);
            border: 1px solid var(--border-color);
            padding: 0.65rem 1.5rem;
            border-radius: var(--radius-pill);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-block;
            transition: all 0.2s;
        }

        .btn-cancel:hover {
            background-color: var(--card-cream);
            color: var(--text-dark);
        }

        /* Responsive Adjustments */
        @media (max-width: 900px) {
            .app-container {
                flex-direction: column;
            }
            .sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid var(--border-color);
            }
        }

        /* Footer */
        footer {
            text-align: center;
            padding: 1.5rem;
            border-top: 1px solid var(--border-color);
            background-color: var(--bg-main);
            color: var(--text-muted);
            font-size: 0.85rem;
            margin-top: auto;
            backdrop-filter: blur(8px);
        }
    </style>
</head>
<body>

    <!-- Top Navigation Header -->
    <header>
        <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="logo">DevProfile Management</a>
        <div class="user-nav">
            <span class="badge"><c:out value="${sessionScope.currentUser.role}" /></span>
            <a href="${pageContext.request.contextPath}/PublicProfileServlet.do?user=${sessionScope.currentUser.username}" target="_blank" class="btn-action-sm">View Public Profile ↗</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet.do" class="btn-logout">Log Out</a>
        </div>
    </header>

    <div class="app-container">
        <!-- Sidebar Navigation Menu -->
        <aside class="sidebar">
            <div>
                <p class="sidebar-section-title">Overview</p>
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/Dashboard.jsp">📊 Dashboard</a>
                    </li>
                    <li class="nav-item active">
                        <a href="${pageContext.request.contextPath}/EditInfoServlet.do">👤 Personal Info</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/ConnectionsServlet.do">🌐 Discover Connections</a>
                    </li>
                </ul>
            </div>

            <div>
                <p class="sidebar-section-title">Manage Sections</p>
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/WorkExperienceServlet.do">💼 Work Experience</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/EducationServlet.do">🎓 Education</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/SkillServlet.do">⚡ Skills</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/CertificationServlet.do">📜 Certifications</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/ReferenceServlet.do">💬 References</a>
                    </li>
                </ul>
            </div>
        </aside>

        <!-- Main Content Area -->
        <main>
            <div class="card">
                <h2>Edit Profile Information</h2>

                <%-- Error message banner --%>
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert-error">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/EditInfoServlet.do" method="POST">
                    
                    <div class="form-group">
                        <label for="fullname">Full Name</label>
                        <input type="text" 
                               id="fullname" 
                               name="fullname" 
                               value="<%= profile.getFullname() != null ? profile.getFullname() : "" %>" 
                               placeholder="e.g. John Doe" 
                               required />
                    </div>

                    <div class="form-group">
                        <label for="title">Job Title</label>
                        <input type="text" 
                               id="title" 
                               name="title" 
                               value="<%= profile.getJobTitle() != null ? profile.getJobTitle() : "" %>" 
                               placeholder="e.g. Software Developer" />
                    </div>

                    <div class="form-group">
                        <label for="location">Location</label>
                        <input type="text" 
                               id="location" 
                               name="location" 
                               value="<%= profile.getLocation() != null ? profile.getLocation() : "" %>" 
                               placeholder="e.g. Pretoria, South Africa" />
                    </div>

                    <div class="form-group">
                        <label for="bio">Professional Summary / Bio</label>
                        <textarea id="bio" 
                                  name="bio" 
                                  placeholder="Write a brief overview of your skills and background..."><%= profile.getProfessionalSummary() != null ? profile.getProfessionalSummary() : "" %></textarea>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="btn-cancel">Cancel</a>
                        <button type="submit" class="btn-submit">Save Changes</button>
                    </div>

                </form>
            </div>
        </main>
    </div>

    <footer>
        <p>&copy; 2026 DevProfile. All rights reserved.</p>
    </footer>

</body>
</html>