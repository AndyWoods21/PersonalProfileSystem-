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
        /* Standard Neutral Dark Grey Color Palette */
        --bg-canvas-tint: rgba(30, 30, 30, 0.75);        /* Semi-transparent dark overlay */
        --bg-main: #1e1e1e;                             /* Standard dark grey background */
        --bg-light-gray: rgba(45, 45, 45, 0.45);        /* Main container: highly transparent dark grey */
        --card-bg: rgba(55, 55, 55, 0.35);               /* Cards/Divs: increased transparency */
        --badge-bg: rgba(220, 220, 220, 0.12);          /* Subtle light grey pill badge */
        --text-heading: #f5f5f5;                        /* Bright off-white heading */
        --text-body: #cccccc;                           /* Light neutral grey text */
        
        /* Light Grey Buttons */
        --btn-dark: #e0e0e0;                            /* Light grey primary button */
        --btn-dark-text: #1e1e1e;                       /* Dark text for contrast */
        --btn-hover: #ffffff;                           /* Pure white hover */
        --danger-color: #ff5252;                        /* Accent red */
        --accent-glow: #e0e0e0;                         /* Neutral light grey glow */
        
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
        background-color: var(--card-bg);              /* 35% opacity dark grey */
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

    <!-- Fullscreen Pop-Up Tech Words Canvas Dynamic Background -->
    <canvas id="techCanvas"></canvas>

    <!-- Top Navigation Header -->
    <header>
        <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="logo">DevProfile Management</a>
        <div class="user-nav">
            <span class="badge"><c:out value="${sessionScope.currentUser.role}" /></span>
            <button onclick="downloadCV()" class="btn-action-sm btn-print">Print CV (PDF)</button>
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
                        <a href="${pageContext.request.contextPath}/Dashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
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
                        <a href="${pageContext.request.contextPath}/WorkExperienceServlet.do"> Work Experience</a>
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
                <!-- Account Credentials Overview -->
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
                <ul class="cv-contact-inline">
                    <li>
                        <c:choose>
                            <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.phone}">
                                <c:out value="${sessionScope.PersonalInfo.phone}" />
                            </c:when>
                            <c:otherwise>
                                <span class="cv-not-provided">Phone not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                    <li>
                        <c:choose>
                            <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.email}">
                                <c:out value="${sessionScope.PersonalInfo.email}" />
                            </c:when>
                            <c:otherwise>
                                <span class="cv-not-provided">Email not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                    <li>
                        <c:choose>
                            <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.location}">
                                <c:out value="${sessionScope.PersonalInfo.location}" />
                            </c:when>
                            <c:otherwise>
                                <span class="cv-not-provided">Location not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                    <li>
                        <c:choose>
                            <c:when test="${not empty sessionScope.PersonalInfo and not empty sessionScope.PersonalInfo.websiteUrl}">
                                <c:out value="${sessionScope.PersonalInfo.websiteUrl}" />
                            </c:when>
                            <c:otherwise>
                                <span class="cv-not-provided">Portfolio not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Two Column Body -->
        <div class="cv-body-layout">
            <div class="cv-col-left">
                <!-- Main Column Sections (Summary, Experience, etc.) -->
            </div>
            <div class="cv-col-right">
                <div>
                    <div class="cv-section-title">Skills</div>
                    <div class="cv-skills-grid">
                        <span class="cv-skill-pill">Java</span>
                        <span class="cv-skill-pill">JPA / EJB</span>
                        <span class="cv-skill-pill">Servlets</span>
                        <span class="cv-skill-pill">SQL</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

    <!-- Floating Tech Canvas Script -->
    <script>
        const canvas = document.getElementById('techCanvas');
        const ctx = canvas.getContext('2d');

        function resizeCanvas() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        }
        window.addEventListener('resize', resizeCanvas);
        resizeCanvas();

        const techWords = [
            'Python', 'SQL', 'Java', 'JavaScript', 'HTML5', 
            'CSS3', 'Git', 'Maven', 'JPA', 'EJB', 
            'Servlets', 'Rest API', 'PostgreSQL', 'Docker'
        ];

        class Word {
            constructor() {
                this.reset();
            }

            reset() {
                this.x = Math.random() * canvas.width;
                this.y = Math.random() * canvas.height;
                this.text = techWords[Math.floor(Math.random() * techWords.length)];
                this.fontSize = Math.floor(Math.random() * 16) + 14;
                this.speedY = -(Math.random() * 0.5 + 0.2);
                this.opacity = 0;
                this.maxOpacity = Math.random() * 0.4 + 0.15;
                this.fadeIn = true;
            }

            update() {
                this.y += this.speedY;

                if (this.fadeIn) {
                    this.opacity += 0.005;
                    if (this.opacity >= this.maxOpacity) this.fadeIn = false;
                } else {
                    this.opacity -= 0.003;
                }

                if (this.opacity <= 0 || this.y < 0) {
                    this.reset();
                    this.y = canvas.height + 20;
                }
            }

            draw() {
                ctx.fillStyle = `rgba(180, 180, 180, ${this.opacity})`;
                ctx.font = `${this.fontSize}px Consolas, monospace`;
                ctx.fillText(this.text, this.x, this.y);
            }
        }

        const wordCount = 35;
        const wordsArray = [];
        for (let i = 0; i < wordCount; i++) {
            wordsArray.push(new Word());
        }

        function animate() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            wordsArray.forEach(word => {
                word.update();
                word.draw();
            });
            requestAnimationFrame(animate);
        }

        animate();

        function downloadCV() {
            const element = document.getElementById('cv-content');
            const opt = {
                margin: 0,
                filename: 'Developer_CV.pdf',
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: { scale: 2 },
                jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
            };
            html2pdf().set(opt).from(element).save();
        }
    </script>
</body>
</html>