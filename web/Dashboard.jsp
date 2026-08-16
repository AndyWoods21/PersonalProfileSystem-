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
    <title>User Dashboard — <c:out value="${not empty sessionScope.PersonalInfo.fullname ? sessionScope.PersonalInfo.fullname : 'Not Provided'}" /></title>
    <style>
        :root {
            --bg-color: #0f172a;
            --card-bg: #1e293b;
            --text-color: #f8fafc;
            --text-muted: #94a3b8;
            --accent-color: #38bdf8;
            --accent-hover: #0284c7;
            --border-color: #334155;
            --danger-color: #ef4444;
            --danger-hover: #dc2626;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Top Navigation Header */
        header {
            background-color: var(--card-bg);
            border-bottom: 1px solid var(--border-color);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--accent-color);
            text-decoration: none;
        }

        .user-nav {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .badge {
            background-color: rgba(56, 189, 248, 0.15);
            color: var(--accent-color);
            border: 1px solid rgba(56, 189, 248, 0.3);
            padding: 0.25rem 0.6rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .btn-public {
            background-color: var(--accent-color);
            color: var(--bg-color);
            padding: 0.4rem 0.9rem;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 600;
            text-decoration: none;
            transition: background-color 0.2s;
        }

        .btn-public:hover {
            background-color: var(--accent-hover);
        }

        .btn-logout {
            background-color: transparent;
            color: var(--danger-color);
            border: 1px solid var(--danger-color);
            padding: 0.4rem 0.9rem;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-logout:hover {
            background-color: var(--danger-color);
            color: #ffffff;
        }

        /* Main Dashboard Container */
        main {
            max-width: 900px;
            margin: 2.5rem auto;
            width: 90%;
            flex: 1;
        }

        .welcome-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.2);
        }

        .welcome-text h1 {
            font-size: 1.8rem;
            margin-bottom: 0.4rem;
        }

        .welcome-text p {
            color: var(--text-muted);
            font-size: 0.95rem;
        }

        /* Grid Layout for Profile Information */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 1.5rem;
        }

        @media (max-width: 768px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
            .welcome-card {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.75rem;
        }

        .card h2 {
            font-size: 1.15rem;
            color: var(--accent-color);
            margin-bottom: 1.25rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid var(--border-color);
        }

        .info-row {
            margin-bottom: 1rem;
        }

        .info-row:last-child {
            margin-bottom: 0;
        }

        .info-label {
            display: block;
            font-size: 0.8rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.25rem;
        }

        .info-value {
            font-size: 0.975rem;
            font-weight: 500;
            color: var(--text-color);
            word-break: break-word;
        }

        /* Actions Section */
        .card-actions {
            margin-top: 1.5rem;
            display: flex;
            gap: 1rem;
        }

        .btn-action {
            display: inline-block;
            padding: 0.6rem 1.2rem;
            background-color: var(--accent-color);
            color: var(--bg-color);
            border-radius: 6px;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            transition: background-color 0.2s;
        }

        .btn-action:hover {
            background-color: var(--accent-hover);
        }

        /* Footer */
        footer {
            text-align: center;
            padding: 1.5rem;
            border-top: 1px solid var(--border-color);
            color: var(--text-muted);
            font-size: 0.85rem;
            margin-top: auto;
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <header>
        <a href="${pageContext.request.contextPath}/" class="logo">DevProfile Management</a>
        <div class="user-nav">
            <span class="badge"><c:out value="${sessionScope.currentUser.role}" /></span>
            <a href="${pageContext.request.contextPath}/PublicProfileServlet.do?user=${sessionScope.currentUser.username}" target="_blank" class="btn-action">View Public Profile ↗</a>
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn-logout">Log Out</a>
        </div>
    </header>

    <!-- Main Content Area -->
    <main>
        <!-- Welcome Banner -->
        <div class="welcome-card">
            <div class="welcome-text">
                <h1>Welcome back, <c:out value="${not empty sessionScope.PersonalInfo.fullname ? sessionScope.PersonalInfo.fullname : 'Not Provided'}" />!</h1>
                <p>Manage your account settings and profile information from your personal dashboard.</p>
            </div>
            <a href="${pageContext.request.contextPath}/AddInformation.jsp" class="btn-action">Edit Profile &rarr;</a>
        </div>

        <div class="dashboard-grid">
            <!-- Account Credentials Overview -->
            <div class="card">
                <h2>Account Information</h2>
                <div class="info-row">
                    <span class="info-label">Username</span>
                    <span class="info-value"><c:out value="${sessionScope.currentUser.username}" /></span>
                </div>
                <div class="info-row" style="margin-top: 1.25rem;">
                    <span class="info-label">Email Address</span>
                    <span class="info-value"><c:out value="${not empty sessionScope.PersonalInfo.email ? sessionScope.PersonalInfo.email : 'Not Provided'}" /></span>
                </div>
                <div class="info-row" style="margin-top: 1.25rem;">
                    <span class="info-label">Account Role</span>
                    <span class="info-value"><c:out value="${sessionScope.currentUser.role}" /></span>
                </div>
            </div>

            <!-- Professional Profile Overview -->
            <div class="card">
                <h2>Profile Details</h2>
                <div class="info-row">
                    <span class="info-label">Full Name</span>
                    <span class="info-value"><c:out value="${not empty sessionScope.PersonalInfo.fullname ? sessionScope.PersonalInfo.fullname : 'Not Provided'}" /></span>
                </div>
                <div class="info-row" style="margin-top: 1.25rem;">
                    <span class="info-label">Professional Title / Role</span>
                    <span class="info-value"><c:out value="${not empty sessionScope.PersonalInfo.jobTitle ? sessionScope.PersonalInfo.jobTitle : 'No title specified'}" /></span>
                </div>
                <div class="info-row" style="margin-top: 1.25rem;">
                    <span class="info-label">Location</span>
                    <span class="info-value"><c:out value="${not empty sessionScope.PersonalInfo.location ? sessionScope.PersonalInfo.location : 'No location specified'}" /></span>
                </div>
                <div class="info-row" style="margin-top: 1.25rem;">
                    <span class="info-label">Professional Bio / Summary</span>
                    <span class="info-value"><c:out value="${not empty sessionScope.PersonalInfo.professionalSummary ? sessionScope.PersonalInfo.professionalSummary : 'No summary added yet.'}" /></span>
                </div>

                <div class="card-actions">
                    <a href="${pageContext.request.contextPath}/PublicProfileServlet.do?user=${sessionScope.currentUser.username}" target="_blank" class="btn-action">View Public Profile ↗</a>
                </div>
            </div>
        </div>
    </main>

    <footer>
        <p>&copy; 2026 DevProfile. All rights reserved.</p>
    </footer>

</body>
</html>