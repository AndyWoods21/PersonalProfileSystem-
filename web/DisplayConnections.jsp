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
            }

            /* Welcome / Page Banner Header */
            .page-header-card {
                background-color: var(--card-cream);
                border: 1px solid rgba(0,0,0,0.04);
                border-radius: var(--radius-lg);
                padding: 2rem;
                margin-bottom: 1.75rem;
                box-shadow: var(--shadow-soft);
                backdrop-filter: blur(8px);
            }

            .page-header-card h1 {
                font-size: 1.75rem;
                font-weight: 800;
                letter-spacing: -0.5px;
                margin-bottom: 0.35rem;
            }

            .page-header-card p {
                color: var(--text-muted);
                font-size: 0.95rem;
            }

            /* Connections Grid Layout */
            .connections-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 1.5rem;
            }

            .connection-card {
                background-color: var(--bg-main);
                border: 1px solid var(--border-color);
                border-radius: var(--radius-lg);
                padding: 1.75rem;
                box-shadow: var(--shadow-soft);
                backdrop-filter: blur(8px);
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                transition: transform 0.2s ease, border-color 0.2s ease;
            }

            .connection-card:hover {
                transform: translateY(-3px);
                border-color: var(--navy-cta);
            }

            .profile-name {
                font-size: 1.25rem;
                font-weight: 800;
                color: var(--text-dark);
                margin-bottom: 0.25rem;
                letter-spacing: -0.3px;
            }

            .profile-title {
                color: var(--accent-blue);
                font-size: 0.875rem;
                font-weight: 700;
                margin-bottom: 0.75rem;
            }

            .profile-meta {
                color: var(--text-muted);
                font-size: 0.85rem;
                font-weight: 500;
                margin-bottom: 1rem;
            }

            .profile-bio {
                color: var(--text-dark);
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
                border-top: 1px solid var(--border-color);
            }

            .btn-view {
                display: block;
                text-align: center;
                background-color: var(--navy-cta);
                color: #FFFFFF;
                padding: 0.55rem 1rem;
                border-radius: var(--radius-pill);
                text-decoration: none;
                font-size: 0.875rem;
                font-weight: 600;
                transition: opacity 0.2s;
            }

            .btn-view:hover {
                opacity: 0.9;
            }

            .empty-state {
                background-color: var(--bg-main);
                border: 1px solid var(--border-color);
                padding: 3rem;
                border-radius: var(--radius-lg);
                text-align: center;
                color: var(--text-muted);
                box-shadow: var(--shadow-soft);
                backdrop-filter: blur(8px);
            }

            .empty-state h3 {
                font-size: 1.25rem;
                color: var(--text-dark);
                margin-bottom: 0.5rem;
            }

            /* Responsive Layout Adjustments */
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
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/EditInfoServlet.do">👤 Personal Info</a>
                        </li>
                        <li class="nav-item active">
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
                <!-- Page Header Card -->
                <div class="page-header-card">
                    <h1>Discover Connections</h1>
                    <p>Connect with other developers across the platform.</p>
                </div>

                <c:choose>
                    <c:when test="${not empty requestScope.connectionsList}">
                        <div class="connections-grid">
                            <c:forEach var="item" items="${requestScope.connectionsList}">
                                <div class="connection-card">
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
                                        <a href="${pageContext.request.contextPath}/ViewProfileServlet.do?username=${item.user.username}" class="btn-view">View Profile ↗</a>                                </div>
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