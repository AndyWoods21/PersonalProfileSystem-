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
            /* Standard Neutral Dark Grey Color Palette */
            --bg-canvas-tint: rgba(30, 30, 30, 0.75);        /* Semi-transparent dark overlay */
            --bg-main: #1e1e1e;                              /* Standard dark grey background */
            --bg-light-gray: rgba(45, 45, 45, 0.45);        /* Main container: highly transparent dark grey */
            --card-bg: rgba(55, 55, 55, 0.35);               /* Cards/Divs: increased transparency */
            --badge-bg: rgba(220, 220, 220, 0.12);          /* Subtle light grey pill badge */
            --text-heading: #f5f5f5;                         /* Bright off-white heading */
            --text-body: #cccccc;                            /* Light neutral grey text */
            
            /* Light Grey Buttons */
            --btn-dark: #e0e0e0;                             /* Light grey primary button */
            --btn-dark-text: #1e1e1e;                        /* Dark text for contrast */
            --btn-hover: #ffffff;                            /* Pure white hover */
            --danger-color: #ff5252;                         /* Accent red */
            --accent-glow: #e0e0e0;                          /* Neutral light grey glow */
            
            /* Structural Standards */
            --glass-border: rgba(255, 255, 255, 0.12);      /* Subtle glass border */
            --card-border: rgba(255, 255, 255, 0.15);       /* Subtle border for divs */
            --shadow-soft: 0 20px 50px -10px rgba(0, 0, 0, 0.5), 0 0 20px rgba(0, 0, 0, 0.3);
            --radius-lg: 24px;
            --radius-md: 14px;
            --radius-pill: 9999px;
            
            /* Form Input Standards */
            --border-color: rgba(255, 255, 255, 0.15);
            --text-muted: #aaaaaa;
            --input-bg: rgba(30, 30, 30, 0.6);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: var(--bg-main);
            background-image: linear-gradient(var(--bg-canvas-tint), var(--bg-canvas-tint)), url('https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            color: var(--text-heading);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            position: relative;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        /* Background Animation Canvas */
        #techCanvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: -10;
            pointer-events: none;
        }

        /* Sticky Navigation Header */
        header {
            background-color: rgba(30, 30, 30, 0.7);
            border-bottom: 1px solid var(--glass-border);
            padding: 0.85rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
        }

        .logo {
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--text-heading);
            text-decoration: none;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .user-nav {
            display: flex;
            align-items: center;
            gap: 0.85rem;
        }

        .badge {
            background-color: var(--badge-bg);
            color: var(--text-heading);
            border: 1px solid var(--glass-border);
            padding: 0.35rem 0.85rem;
            border-radius: var(--radius-pill);
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Light Grey Action Buttons */
        .btn-action-sm {
            background-color: var(--btn-dark);
            color: var(--btn-dark-text);
            padding: 0.5rem 1.1rem;
            border-radius: var(--radius-pill);
            font-size: 0.85rem;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s ease;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            box-shadow: 0 4px 12px rgba(255, 255, 255, 0.1);
        }

        .btn-action-sm:hover {
            background-color: var(--btn-hover);
            color: #000000;
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(255, 255, 255, 0.25);
        }

        .btn-secondary-outline {
            background-color: transparent;
            color: var(--text-heading);
            border: 1px solid var(--glass-border);
        }

        .btn-secondary-outline:hover {
            background-color: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.3);
        }

        .btn-print {
            background-color: var(--btn-dark);
            color: var(--btn-dark-text);
        }

        .btn-logout {
            background-color: transparent;
            color: var(--danger-color);
            border: 1px solid rgba(255, 82, 82, 0.4);
            padding: 0.45rem 0.95rem;
            border-radius: var(--radius-pill);
            font-size: 0.82rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-logout:hover {
            background-color: var(--danger-color);
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(255, 82, 82, 0.3);
        }

        .not-provided {
            color: #888888;
            font-style: italic;
        }

        /* Main App Container Shell (More Transparent) */
        .app-container {
            display: flex;
            flex: 1;
            max-width: 1280px;
            width: 100%;
            margin: 2rem auto;
            border-radius: var(--radius-lg);
            background: var(--bg-light-gray);              /* 45% opacity background */
            border: 1px solid var(--glass-border);
            box-shadow: var(--shadow-soft);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            overflow: hidden;
            position: relative;
            z-index: 1;
        }

        /* Sidebar Styling */
        .sidebar {
            width: 250px;
            background-color: rgba(20, 20, 20, 0.35);      /* Transparent dark grey sidebar */
            border-right: 1px solid var(--glass-border);
            padding: 1.75rem 1rem;
            display: flex;
            flex-direction: column;
            gap: 1.75rem;
            flex-shrink: 0;
        }

        .sidebar-section-title {
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #aaaaaa;
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
            padding: 0.7rem 0.85rem;
            color: var(--text-body);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            border-radius: var(--radius-md);
            transition: all 0.2s ease;
        }

        .nav-item a:hover {
            background-color: rgba(255, 255, 255, 0.08);
            color: var(--text-heading);
        }

        .nav-item.active a {
            background-color: var(--btn-dark);
            color: var(--btn-dark-text);
            font-weight: 700;
        }

        /* Main Body Area */
        main {
            flex: 1;
            padding: 2rem;
        }

        /* Welcome / Banner Module */
        .welcome-card {
            position: relative;
            background-color: var(--card-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 2.25rem 2rem 4.5rem 2rem;
            margin-bottom: 1.75rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            backdrop-filter: blur(12px);
        }

        .hero-wave-graphic {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 70px;
            background-image: url('background.gif');
            background-size: cover;
            background-position: center bottom;
            opacity: 0.25;
            pointer-events: none;
            z-index: 1;
        }

        .welcome-text {
            position: relative;
            z-index: 2;
        }

        .welcome-text h1 {
            font-size: 1.8rem;
            font-weight: 800;
            letter-spacing: -0.5px;
            margin-bottom: 0.35rem;
            color: var(--text-heading);
        }

        .welcome-text p {
            color: var(--text-body);
            font-size: 0.95rem;
        }

        .welcome-actions {
            position: relative;
            z-index: 2;
        }

        /* Dashboard Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
        }

        /* Card Panels (More Transparent Divs) */
        .card {
            background-color: var(--card-bg);               /* 35% opacity dark grey */
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 1.75rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            transition: transform 0.25s cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 0.25s ease, border-color 0.25s ease;
        }

        .card:hover {
            transform: translateY(-4px);
            background-color: rgba(65, 65, 65, 0.45);      /* Slightly higher opacity on hover */
            border-color: rgba(255, 255, 255, 0.25);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.4);
        }

        .card h2 {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-heading);
            margin-bottom: 1.25rem;
            padding-bottom: 0.6rem;
            border-bottom: 1px solid var(--glass-border);
        }

        .info-row {
            margin-bottom: 1.15rem;
        }

        .info-row:last-child {
            margin-bottom: 0;
        }

        .info-label {
            display: block;
            font-size: 0.72rem;
            color: #aaaaaa;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }

        .info-value {
            font-size: 0.95rem;
            font-weight: 500;
            color: var(--text-heading);
            word-break: break-word;
        }

        .card-actions {
            margin-top: 1.75rem;
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        /* Form Control Enhancements for Dark Theme */
        .alert-error {
            background-color: rgba(239, 68, 68, 0.15);
            color: var(--danger-color);
            padding: 0.85rem 1rem;
            border-radius: var(--radius-md);
            margin-bottom: 1.5rem;
            border: 1px solid rgba(239, 68, 68, 0.3);
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
            color: var(--text-heading);
            font-size: 0.95rem;
            font-family: inherit;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input[type="text"]:focus,
        textarea:focus {
            outline: none;
            border-color: var(--btn-dark);
            box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.1);
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
            border-top: 1px solid var(--glass-border);
        }

        .btn-submit {
            background-color: var(--btn-dark);
            color: var(--btn-dark-text);
            padding: 0.65rem 1.5rem;
            border: none;
            border-radius: var(--radius-pill);
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-submit:hover {
            background-color: var(--btn-hover);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 255, 255, 0.2);
        }

        .btn-cancel {
            background-color: transparent;
            color: var(--text-muted);
            border: 1px solid var(--glass-border);
            padding: 0.65rem 1.5rem;
            border-radius: var(--radius-pill);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-block;
            transition: all 0.2s;
        }

        .btn-cancel:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: var(--text-heading);
        }

        /* Responsive Breaks */
        @media (max-width: 900px) {
            .app-container {
                flex-direction: column;
                margin: 0;
                border-radius: 0;
            }
            .sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid var(--glass-border);
            }
            .welcome-card {
                flex-direction: column;
                align-items: flex-start;
                gap: 1.25rem;
                padding-bottom: 3.5rem;
            }
        }

        /* Footer Container */
        footer {
            text-align: center;
            padding: 1.75rem 1.5rem;
            border-top: 1px solid var(--glass-border);
            background: rgba(30, 30, 30, 0.8);
            color: #aaaaaa;
            font-size: 0.85rem;
            margin-top: auto;
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            position: relative;
            z-index: 10;
        }

        /* High-Visibility PDF CV Layout Structure */
        #cv-pdf-wrapper {
            position: absolute;
            left: -9999px;
            top: -9999px;
            width: 794px;
        }

        .cv-template {
            background-color: #ffffff;
            color: #1e1e1e;
            font-family: 'Segoe UI', Arial, sans-serif;
            box-sizing: border-box;
            min-height: 1122px;
            display: flex;
            flex-direction: column;
        }

        .cv-header-bar {
            background-color: #2a2a2a;
            color: #ffffff;
            padding: 35px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 4px solid #cccccc;
        }

        .cv-name-title h1 {
            font-size: 2.2rem;
            font-weight: 800;
            letter-spacing: -0.5px;
            color: #ffffff;
            margin-bottom: 4px;
        }

        .cv-name-title .cv-subtitle {
            font-size: 1.1rem;
            color: #e0e0e0;
            font-weight: 600;
        }

        .cv-header-contact {
            text-align: right;
            font-size: 0.85rem;
            color: #cccccc;
            line-height: 1.6;
        }

        .cv-body-layout {
            display: flex;
            flex: 1;
        }

        .cv-col-left {
            width: 32%;
            background-color: #f0f0f0;
            border-right: 1px solid #e0e0e0;
            padding: 30px 24px;
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .cv-col-right {
            width: 68%;
            padding: 30px 35px;
            display: flex;
            flex-direction: column;
            gap: 26px;
            background-color: #ffffff;
        }

        .cv-section-title {
            font-size: 1.1rem;
            color: #1e1e1e;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            border-bottom: 2px solid #666666;
            padding-bottom: 6px;
            margin-bottom: 12px;
        }

        .cv-skills-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .cv-skill-pill {
            background-color: #e0e0e0;
            color: #1e1e1e;
            border: 1px solid #cccccc;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 700;
        }

        .cv-not-provided {
            color: #888888;
            font-style: italic;
            font-size: 0.85rem;
        }
    </style>
</head>
<body>

    <header>
        <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="logo">DevProfile Management</a>
        <div class="user-nav">
            <span class="badge"><c:out value="${sessionScope.currentUser.role}" /></span>
            <a href="${pageContext.request.contextPath}/PublicProfileServlet.do?user=${sessionScope.currentUser.username}" target="_blank" class="btn-action-sm">View Public Profile ↗</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet.do" class="btn-logout">Log Out</a>
        </div>
    </header>

    <div class="app-container">
        <aside class="sidebar">
            <div>
                <p class="sidebar-section-title">Overview</p>
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/Dashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item active">
                        <a href="${pageContext.request.contextPath}/EditInfoServlet.do">Personal Info</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/ConnectionsServlet.do">Discover Connections</a>
                    </li>
                </ul>
            </div>

            <div>
                <p class="sidebar-section-title">Manage Sections</p>
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/WorkExperienceServlet.do">Work Experience</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/EducationServlet.do">Education</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/SkillServlet.do">Skills</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/CertificationServlet.do">Certifications</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/ReferenceServlet.do">References</a>
                    </li>
                </ul>
            </div>
        </aside>

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