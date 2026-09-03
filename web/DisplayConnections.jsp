<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Security Gatekeeper --%>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login.jsp?error=unauthorized" />
</c:if>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Discover Connections — DevProfile</title>
        <style>
            /* Standard Neutral Dark Grey Color Palette */
            :root {
                --bg-canvas-tint: rgba(30, 30, 30, 0.75);        /* Semi-transparent dark overlay */
                --bg-main: #1e1e1e;                              /* Standard dark grey background */
                --bg-light-gray: rgba(45, 45, 45, 0.45);        /* Main container: highly transparent dark grey */
                --card-bg: rgba(55, 55, 55, 0.35);               /* Cards/Divs: increased transparency */
                --badge-bg: rgba(220, 220, 220, 0.12);           /* Subtle light grey pill badge */
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
                background: var(--bg-light-gray);             /* 45% opacity background */
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

            /* Banner / Page Header Module */
            .welcome-card {
                position: relative;
                background-color: var(--card-bg);
                border: 1px solid var(--glass-border);
                border-radius: var(--radius-md);
                padding: 2rem;
                margin-bottom: 1.75rem;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                backdrop-filter: blur(12px);
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

            /* Connections Grid Layout */
            .connections-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
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
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .card:hover {
                transform: translateY(-4px);
                background-color: rgba(65, 65, 65, 0.45);       /* Slightly higher opacity on hover */
                border-color: rgba(255, 255, 255, 0.25);
                box-shadow: 0 12px 30px rgba(0, 0, 0, 0.4);
            }

            .profile-name {
                font-size: 1.25rem;
                font-weight: 800;
                color: var(--text-heading);
                margin-bottom: 0.25rem;
                letter-spacing: -0.3px;
            }

            .profile-title {
                color: #60A5FA;
                font-size: 0.875rem;
                font-weight: 700;
                margin-bottom: 0.75rem;
            }

            .profile-meta {
                color: #aaaaaa;
                font-size: 0.85rem;
                font-weight: 500;
                margin-bottom: 1rem;
            }

            .profile-bio {
                color: var(--text-body);
                font-size: 0.9rem;
                line-height: 1.5;
                margin-bottom: 1.5rem;
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .card-actions {
                margin-top: auto;
                padding-top: 1rem;
                border-top: 1px solid var(--glass-border);
            }

            .empty-state {
                background-color: var(--card-bg);
                border: 1px solid var(--glass-border);
                padding: 3rem;
                border-radius: var(--radius-md);
                text-align: center;
                color: var(--text-body);
                backdrop-filter: blur(16px);
            }

            .empty-state h3 {
                font-size: 1.25rem;
                color: var(--text-heading);
                margin-bottom: 0.5rem;
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
                            <a href="${pageContext.request.contextPath}/Dashboard.jsp"> Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/EditInfoServlet.do"> Personal Info</a>
                        </li>
                        <li class="nav-item active">
                            <a href="${pageContext.request.contextPath}/ConnectionsServlet.do"> Discover Connections</a>
                        </li>
                    </ul>
                </div>

                <div>
                    <p class="sidebar-section-title">Manage Sections</p>
                    <ul class="nav-menu">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/WorkExperienceServlet.do"> Work Experience</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/EducationServlet.do"> Education</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/SkillServlet.do">Skills</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/CertificationServlet.do"> Certifications</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/ReferenceServlet.do"> References</a>
                        </li>
                    </ul>
                </div>
            </aside>

            <main>
                <div class="welcome-card">
                    <div class="welcome-text">
                        <h1>Discover Connections</h1>
                        <p>Connect with other developers across the platform.</p>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty requestScope.connectionsList}">
                        <div class="connections-grid">
                            <c:forEach var="item" items="${requestScope.connectionsList}">
                                <div class="card">
                                    <div>
                                        <div class="profile-name">
                                            <c:out value="${not empty item.fullname ? item.fullname : item.user.username}" />
                                        </div>
                                        <div class="profile-title">
                                            <c:out value="${not empty item.jobTitle ? item.jobTitle : 'Developer'}" />
                                        </div>
                                        <div class="profile-meta">
                                            📍 <c:out value="${not empty item.location ? item.location : 'Location Unspecified'}" />
                                        </div>
                                        <div class="profile-bio">
                                            <c:out value="${not empty item.professionalSummary ? item.professionalSummary : 'No professional summary provided.'}" />
                                        </div>
                                    </div>
                                    <div class="card-actions">
                                        <a href="${pageContext.request.contextPath}/ViewProfileServlet.do?username=${item.user.username}" class="btn-action-sm">View Profile ↗</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <h3>No Profiles Found</h3>
                            <p>There are currently no public profiles available to show.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>

        <footer>
            <p>&copy; 2026 DevProfile. All rights reserved.</p>
        </footer>

    </body>
</html>