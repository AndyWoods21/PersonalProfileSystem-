<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Security Gatekeeper: Check if user is logged in --%>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login.jsp?error=unauthorized" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard — <c:out value="${not empty sessionScope.PersonalInfo.fullname ? sessionScope.PersonalInfo.fullname : sessionScope.currentUser.username}" /></title>
    
    <!-- Client-Side PDF Generation Engine -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
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
    -webkit-backdrop-filter: blur(8px);
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
    flex-wrap: wrap;
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
    padding: 0.5rem 1rem;
    border-radius: var(--radius-pill);
    font-size: 0.85rem;
    font-weight: 600;
    text-decoration: none;
    transition: opacity 0.2s;
    border: none;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
}

.btn-action-sm:hover {
    opacity: 0.9;
}

.btn-print {
    background: linear-gradient(135deg, #0284C7, #2563EB);
    color: #FFFFFF;
    box-shadow: 0 4px 12px rgba(2, 132, 199, 0.3);
}

.btn-logout {
    background-color: transparent;
    color: var(--danger-color);
    border: 1px solid var(--danger-color);
    padding: 0.45rem 0.9rem;
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

.not-provided {
    color: #94A3B8;
    font-style: italic;
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
    -webkit-backdrop-filter: blur(8px);
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
    padding: 0.75rem 0.85rem;
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

/* Welcome Banner Card */
.welcome-card {
    background-color: var(--card-cream);
    border: 1px solid rgba(0, 0, 0, 0.04);
    border-radius: var(--radius-lg);
    padding: 2rem;
    margin-bottom: 1.75rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    box-shadow: var(--shadow-soft);
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
}

.welcome-text h1 {
    font-size: 1.75rem;
    font-weight: 800;
    letter-spacing: -0.5px;
    margin-bottom: 0.35rem;
}

.welcome-text p {
    color: var(--text-muted);
    font-size: 0.95rem;
}

/* Grid Layout for Cards */
.dashboard-grid {
    display: grid;
    grid-template-columns: 1fr 2fr;
    gap: 1.5rem;
}

.card {
    background-color: var(--bg-main);
    border: 1px solid var(--border-color);
    border-radius: var(--radius-lg);
    padding: 1.75rem;
    box-shadow: var(--shadow-soft);
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
}

.card-dark-theme {
    background-color: var(--card-dark);
    color: #FFFFFF;
    border: none;
}

.card h2 {
    font-size: 1.15rem;
    font-weight: 700;
    color: var(--text-dark);
    margin-bottom: 1.25rem;
    padding-bottom: 0.5rem;
    border-bottom: 1px solid var(--border-color);
}

.card-dark-theme h2 {
    color: #FFFFFF;
    border-bottom-color: rgba(255, 255, 255, 0.1);
}

.info-row {
    margin-bottom: 1.15rem;
}

.info-row:last-child {
    margin-bottom: 0;
}

.info-label {
    display: block;
    font-size: 0.75rem;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.6px;
    font-weight: 700;
    margin-bottom: 0.3rem;
}

.card-dark-theme .info-label {
    color: #94A3B8;
}

.info-value {
    font-size: 0.95rem;
    font-weight: 500;
    color: var(--text-dark);
    word-break: break-word;
}

.card-dark-theme .info-value {
    color: #F8FAFC;
}

.card-actions {
    margin-top: 1.75rem;
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
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
    -webkit-backdrop-filter: blur(8px);
}

/* ==========================================================
   HIGH-VISIBILITY PROFESSIONAL CV TEMPLATE FOR PDF EXPORT
   ========================================================== */
#cv-pdf-wrapper {
    position: absolute;
    left: -9999px;
    top: -9999px;
    width: 794px; /* A4 Width at standard DPI */
}

.cv-template {
    background-color: #ffffff;
    color: #1e293b;
    font-family: 'Segoe UI', Arial, sans-serif;
    box-sizing: border-box;
    min-height: 1122px;
    display: flex;
    flex-direction: column;
}

.cv-header-bar {
    background-color: #0f172a;
    color: #ffffff;
    padding: 35px 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 4px solid #0284c7;
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
    color: #38bdf8;
    font-weight: 600;
}

.cv-header-contact {
    text-align: right;
    font-size: 0.85rem;
    color: #cbd5e1;
    line-height: 1.6;
}

.cv-body-layout {
    display: flex;
    flex: 1;
}

.cv-col-left {
    width: 32%;
    background-color: #f8fafc;
    border-right: 1px solid #e2e8f0;
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
    color: #0f172a;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 0.8px;
    border-bottom: 2px solid #0284c7;
    padding-bottom: 6px;
    margin-bottom: 12px;
}

.cv-text-p {
    font-size: 0.88rem;
    line-height: 1.5;
    color: #334155;
}

.cv-timeline-item {
    margin-bottom: 16px;
}

.cv-timeline-item:last-child {
    margin-bottom: 0;
}

.cv-timeline-header {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    margin-bottom: 2px;
}

.cv-timeline-role {
    font-size: 0.95rem;
    font-weight: 700;
    color: #0f172a;
}

.cv-timeline-date {
    font-size: 0.8rem;
    font-weight: 600;
    color: #0284c7;
}

.cv-timeline-org {
    font-size: 0.85rem;
    font-weight: 600;
    color: #64748b;
    margin-bottom: 6px;
}

.cv-skills-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
}

.cv-skill-pill {
    background-color: #e0f2fe;
    color: #0369a1;
    border: 1px solid #bae6fd;
    padding: 4px 10px;
    border-radius: 6px;
    font-size: 0.8rem;
    font-weight: 700;
}

.cv-list-simple {
    list-style: none;
    font-size: 0.85rem;
    line-height: 1.5;
    color: #334155;
}

.cv-list-simple li {
    margin-bottom: 10px;
    padding-bottom: 8px;
    border-bottom: 1px dashed #e2e8f0;
}

.cv-list-simple li:last-child {
    border-bottom: none;
}

.cv-not-provided {
    color: #94a3b8;
    font-style: italic;
    font-size: 0.85rem;
}

/* ==========================================================
   RESPONSIVE MOBILE BREAKPOINTS
   ========================================================== */

/* Tablet & Mobile Layout Adjustment */
@media (max-width: 900px) {
    .app-container {
        flex-direction: column;
    }

    .sidebar {
        width: 100%;
        border-right: none;
        border-bottom: 1px solid var(--border-color);
        padding: 1.25rem;
        gap: 1rem;
    }

    .nav-menu {
        flex-direction: row;
        overflow-x: auto;
        padding-bottom: 0.5rem;
        -webkit-overflow-scrolling: touch;
    }

    .nav-item {
        flex-shrink: 0;
    }

    .dashboard-grid {
        grid-template-columns: 1fr;
    }

    .welcome-card {
        flex-direction: column;
        align-items: flex-start;
        gap: 1.25rem;
    }
}

/* Small Smartphone Breakpoint */
@media (max-width: 600px) {
    header {
        padding: 0.85rem 1rem;
        flex-direction: column;
        gap: 0.75rem;
        align-items: stretch;
    }

    header .logo {
        text-align: center;
    }

    .user-nav {
        justify-content: center;
        gap: 0.5rem;
    }

    .btn-action-sm, 
    .btn-logout {
        flex: 1;
        justify-content: center;
        text-align: center;
    }

    main {
        padding: 1rem;
    }

    .welcome-card, 
    .card {
        padding: 1.25rem;
        border-radius: var(--radius-md);
    }

    .welcome-text h1 {
        font-size: 1.4rem;
    }

    .card-actions {
        flex-direction: column;
    }

    .card-actions button,
    .card-actions a {
        width: 100%;
        justify-content: center;
    }
}
</style>
</head>
<body>

    <!-- Top Navigation Header -->
    <header>
        <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="logo">DevProfile Management</a>
        <div class="user-nav">
            <span class="badge"><c:out value="${sessionScope.currentUser.role}" /></span>
            <button onclick="downloadCV()" class="btn-action-sm btn-print">📄 Print CV (PDF)</button>
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
                    <li class="nav-item active">
                        <a href="${pageContext.request.contextPath}/Dashboard.jsp">📊 Dashboard</a>
                    </li>
                    <li class="nav-item">
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
            <!-- Welcome Banner -->
            <div class="welcome-card">
                <div class="welcome-text">
                    <h1>
                        Welcome back, 
                        <c:choose>
                            <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.fullname}">
                                <c:out value="${sessionScope.PersonalInfo.fullname}" />
                            </c:when>
                            <c:otherwise>
                                <c:out value="${sessionScope.currentUser.username}" />
                            </c:otherwise>
                        </c:choose>!
                    </h1>
                    <p>Manage your account settings and profile information from your personal dashboard.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/EditInfoServlet.do" class="btn-action-sm">Edit Profile &rarr;</a>
                </div>
            </div>

            <div class="dashboard-grid">
                <!-- Account Credentials Overview (Dark Accent Card) -->
                <div class="card card-dark-theme">
                    <h2>Account Information</h2>
                    <div class="info-row">
                        <span class="info-label">Username</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.currentUser and not empty sessionScope.currentUser.username}">
                                    <c:out value="${sessionScope.currentUser.username}" />
                                </c:when>
                                <c:otherwise>
                                    <span class="not-provided">Information not provided</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Email Address</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.email}">
                                    <c:out value="${sessionScope.PersonalInfo.email}" />
                                </c:when>
                                <c:otherwise>
                                    <span class="not-provided">Information not provided</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Account Role</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.currentUser and not empty sessionScope.currentUser.role}">
                                    <c:out value="${sessionScope.currentUser.role}" />
                                </c:when>
                                <c:otherwise>
                                    <span class="not-provided">Information not provided</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <!-- Professional Profile Overview -->
                <div class="card">
                    <h2>Profile Details</h2>
                    <div class="info-row">
                        <span class="info-label">Full Name</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.fullname}">
                                    <c:out value="${sessionScope.PersonalInfo.fullname}" />
                                </c:when>
                                <c:otherwise>
                                    <span class="not-provided">Information not provided</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Phone</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.phone}">
                                    <c:out value="${sessionScope.PersonalInfo.phone}" />
                                </c:when>
                                <c:otherwise>
                                    <span class="not-provided">Information not provided</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Professional Title / Role</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.jobTitle}">
                                    <c:out value="${sessionScope.PersonalInfo.jobTitle}" />
                                </c:when>
                                <c:otherwise>
                                    <span class="not-provided">Information not provided</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Location</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.location}">
                                    <c:out value="${sessionScope.PersonalInfo.location}" />
                                </c:when>
                                <c:otherwise>
                                    <span class="not-provided">Information not provided</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Website / Portfolio</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.websiteUrl}">
                                    <c:out value="${sessionScope.PersonalInfo.websiteUrl}" />
                                </c:when>
                                <c:otherwise>
                                    <span class="not-provided">Information not provided</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Professional Bio / Summary</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.professionalSummary}">
                                    <c:out value="${sessionScope.PersonalInfo.professionalSummary}" />
                                </c:when>
                                <c:otherwise>
                                    <span class="not-provided">Information not provided</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="card-actions">
                        <a href="${pageContext.request.contextPath}/PublicProfileServlet.do?user=${sessionScope.currentUser.username}" target="_blank" class="btn-action-sm">View Public Profile ↗</a>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- High-Visibility PDF Output Printable Template -->
    <div id="cv-pdf-wrapper">
        <div class="cv-template" id="cv-content">
            <!-- Header Block -->
            <div class="cv-header-bar">
                <div class="cv-name-title">
                    <h1>
                        <c:choose>
                            <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.fullname}">
                                <c:out value="${sessionScope.PersonalInfo.fullname}" />
                            </c:when>
                            <c:when test="${not empty sessionScope.currentUser and not empty sessionScope.currentUser.username}">
                                <c:out value="${sessionScope.currentUser.username}" />
                            </c:when>
                            <c:otherwise>
                                <span class="cv-not-provided">Information not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </h1>
                    <div class="cv-subtitle">
                        <c:choose>
                            <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.jobTitle}">
                                <c:out value="${sessionScope.PersonalInfo.jobTitle}" />
                            </c:when>
                            <c:otherwise>
                                <span class="cv-not-provided">Information not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="cv-header-contact">
                    <p>📍 Location: 
                        <c:choose>
                            <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.location}">
                                <c:out value="${sessionScope.PersonalInfo.location}" />
                            </c:when>
                            <c:otherwise>
                                <span class="cv-not-provided">Information not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p>📧 Email: 
                        <c:choose>
                            <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.email}">
                                <c:out value="${sessionScope.PersonalInfo.email}" />
                            </c:when>
                            <c:otherwise>
                                <span class="cv-not-provided">Information not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p>📞 Phone: 
                        <c:choose>
                            <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.phone}">
                                <c:out value="${sessionScope.PersonalInfo.phone}" />
                            </c:when>
                            <c:otherwise>
                                <span class="cv-not-provided">Information not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p>🌐 Portfolio: 
                        <c:choose>
                            <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.websiteUrl}">
                                <c:out value="${sessionScope.PersonalInfo.websiteUrl}" />
                            </c:when>
                            <c:otherwise>
                                <span class="cv-not-provided">Information not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>

            <!-- Two Column Body -->
            <div class="cv-body-layout">
                <!-- Left Sidebar Column -->
                <div class="cv-col-left">
                    <div>
                        <div class="cv-section-title">Skills</div>
                        <div class="cv-skills-grid">
                            <c:choose>
                                <c:when test="${not empty sessionScope.skillsList}">
                                    <c:forEach items="${sessionScope.skillsList}" var="skill">
                                        <span class="cv-skill-pill">
                                            <c:out value="${not empty skill.skillName ? skill.skillName : 'Skill'}" />
                                            <c:if test="${not empty skill.proficiencyLevel}">
                                                • <c:out value="${skill.proficiencyLevel}" />
                                            </c:if>
                                        </span>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <span class="cv-not-provided">Information not provided</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div>
                        <div class="cv-section-title">Certifications</div>
                        <ul class="cv-list-simple">
                            <c:choose>
                                <c:when test="${not empty sessionScope.certificationsList}">
                                    <c:forEach items="${sessionScope.certificationsList}" var="cert">
                                        <li>
                                            <strong><c:out value="${not empty cert.title ? cert.title : 'Certification Title'}" /></strong><br/>
                                            <span style="color: #64748b;">
                                                <c:out value="${not empty cert.issuingOrganization ? cert.issuingOrganization : 'Organization N/A'}" />
                                            </span><br/>
                                            <small style="color: #0284c7;">
                                                Issued: <c:out value="${not empty cert.issueDate ? cert.issueDate : 'Date N/A'}" />
                                            </small>
                                        </li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li><span class="cv-not-provided">Information not provided</span></li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>

                    <div>
                        <div class="cv-section-title">References</div>
                        <ul class="cv-list-simple">
                            <c:choose>
                                <c:when test="${not empty sessionScope.referencesList}">
                                    <c:forEach items="${sessionScope.referencesList}" var="ref">
                                        <li>
                                            <strong><c:out value="${not empty ref.name ? ref.name : 'Reference Name'}" /></strong><br/>
                                            <span style="color: #0f172a; font-weight: 600;">
                                                <c:out value="${not empty ref.jobTitle ? ref.jobTitle : ''}" />
                                                <c:if test="${not empty ref.company}"> @ <c:out value="${ref.company}" /></c:if>
                                            </span><br/>
                                            <span style="color: #64748b;">
                                                <c:out value="${not empty ref.email ? ref.email : (not empty ref.contact ? ref.contact : 'Contact N/A')}" />
                                            </span>
                                            <c:if test="${not empty ref.testimonial}">
                                                <div style="font-style: italic; font-size: 0.8rem; margin-top: 4px; color: #475569;">
                                                    "<c:out value="${ref.testimonial}" />"
                                                </div>
                                            </c:if>
                                        </li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li><span class="cv-not-provided">Information not provided</span></li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>

                <!-- Main Content Column -->
                <div class="cv-col-right">
                    <div>
                        <div class="cv-section-title">Professional Summary</div>
                        <p class="cv-text-p">
                            <c:choose>
                                <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.professionalSummary}">
                                    <c:out value="${sessionScope.PersonalInfo.professionalSummary}" />
                                </c:when>
                                <c:otherwise>
                                    <span class="cv-not-provided">Information not provided</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <div>
                        <div class="cv-section-title">Work Experience</div>
                        <c:choose>
                            <c:when test="${not empty sessionScope.workExperienceList}">
                                <c:forEach items="${sessionScope.workExperienceList}" var="work">
                                    <div class="cv-timeline-item">
                                        <div class="cv-timeline-header">
                                            <div class="cv-timeline-role">
                                                <c:out value="${not empty work.jobTitle ? work.jobTitle : 'Title Unspecified'}" />
                                            </div>
                                            <div class="cv-timeline-date">
                                                <c:out value="${not empty work.startDate ? work.startDate : 'N/A'}" /> — 
                                                <c:out value="${not empty work.endDate ? work.endDate : 'Present'}" />
                                            </div>
                                        </div>
                                        <div class="cv-timeline-org">
                                            <c:out value="${not empty work.companyName ? work.companyName : 'Company Unspecified'}" />
                                        </div>
                                        <div class="cv-text-p">
                                            <c:choose>
                                                <c:when test="${not empty work.description}">
                                                    <c:out value="${work.description}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="cv-not-provided">Information not provided</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="cv-not-provided">Information not provided</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div>
                        <div class="cv-section-title">Education</div>
                        <c:choose>
                            <c:when test="${not empty sessionScope.educationList}">
                                <c:forEach items="${sessionScope.educationList}" var="edu">
                                    <div class="cv-timeline-item">
                                        <div class="cv-timeline-header">
                                            <div class="cv-timeline-role">
                                                <c:out value="${not empty edu.degree ? edu.degree : 'Degree Unspecified'}" />
                                                <c:if test="${not empty edu.fieldOfStudy}"> in <c:out value="${edu.fieldOfStudy}" /></c:if>
                                            </div>
                                            <div class="cv-timeline-date">
                                                <c:out value="${not empty edu.startDate ? edu.startDate : (not empty edu.startYear ? edu.startYear : 'N/A')}" /> — 
                                                <c:out value="${not empty edu.endDate ? edu.endDate : (not empty edu.endYear ? edu.endYear : 'N/A')}" />
                                            </div>
                                        </div>
                                        <div class="cv-timeline-org">
                                            <c:out value="${not empty edu.institutionName ? edu.institutionName : (not empty edu.institution ? edu.institution : 'Institution Unspecified')}" />
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="cv-not-provided">Information not provided</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 DevProfile. All rights reserved.</p>
    </footer>

    <!-- JavaScript PDF Generator Trigger -->
    <script>
        function downloadCV() {
            const element = document.getElementById('cv-content');
            const userName = "${not empty sessionScope.PersonalInfo.fullname ? sessionScope.PersonalInfo.fullname : sessionScope.currentUser.username}";
            
            const opt = {
                margin:       0,
                filename:     userName.replace(/\s+/g, '_') + '_CV.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2, useCORS: true, logging: false },
                jsPDF:        { unit: 'pt', format: 'a4', orientation: 'portrait' }
            };

            html2pdf().set(opt).from(element).save();
        }
    </script>
</body>
</html>
