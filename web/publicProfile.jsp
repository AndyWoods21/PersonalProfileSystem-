<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Guard: Prevent direct rendering if attributes were not populated by PublicProfileServlet --%>
<c:if test="${empty requestScope.publicUser}">
    <c:redirect url="/error.jsp" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:out value="${not empty requestScope.publicProfile.fullname ? requestScope.publicProfile.fullname : requestScope.publicUser.username}" /> — Public Profile
    </title>
    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.65);
            --glass-header-bg: rgba(255, 255, 255, 0.75);
            --glass-border: rgba(255, 255, 255, 0.8);
            --text-color: #0f172a;
            --text-muted: #64748b;
            --accent-color: #0284c7;
            --accent-hover: #0369a1;
            --border-color: rgba(226, 232, 240, 0.8);
            --danger-color: #dc2626;
            --danger-hover: #b91c1c;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body { 
            font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif; 
            background-image: url('${pageContext.request.contextPath}/background.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            color: var(--text-color); 
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Top Navigation Bar */
        header {
            background: var(--glass-header-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--glass-border);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.05);
        }

        .nav-brand {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--accent-color);
            text-decoration: none;
            letter-spacing: -0.025em;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 1.25rem;
        }

        .nav-link {
            color: var(--text-color);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .nav-link:hover {
            color: var(--accent-color);
        }

        .btn-logout {
            background-color: rgba(254, 226, 226, 0.6);
            color: var(--danger-color);
            border: 1px solid rgba(220, 38, 38, 0.3);
            padding: 0.4rem 0.9rem;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
        }

        .btn-logout:hover {
            background-color: var(--danger-color);
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(220, 38, 38, 0.25);
        }

        /* Main Profile Card */
        main {
            flex: 1;
            padding: 2rem 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card { 
            background: var(--glass-bg); 
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border); 
            padding: 2.5rem 2rem; 
            border-radius: 16px; 
            width: 100%;
            max-width: 600px; 
            margin: auto; 
            box-shadow: 0 20px 40px -15px rgba(15, 23, 42, 0.15), 
                        0 0 15px 0 rgba(255, 255, 255, 0.5) inset;
        }

        h1 { 
            color: var(--text-color); 
            margin-bottom: 0.5rem; 
            font-size: 1.8rem;
            font-weight: 700;
        }

        .title { 
            color: var(--text-muted); 
            font-size: 1rem; 
            font-weight: 500;
            margin-bottom: 1.75rem; 
            padding-bottom: 1.25rem;
            border-bottom: 1px solid var(--border-color);
        }

        .detail { 
            margin-bottom: 1.25rem; 
        }

        .label { 
            font-weight: 700; 
            color: var(--accent-color); 
            display: block; 
            font-size: 0.8rem; 
            text-transform: uppercase; 
            letter-spacing: 0.05em;
            margin-bottom: 0.35rem;
        }

        p {
            color: var(--text-color);
            line-height: 1.6;
            font-size: 0.95rem;
        }

        footer {
            background: var(--glass-header-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            text-align: center;
            padding: 1.25rem;
            border-top: 1px solid var(--glass-border);
            color: var(--text-muted);
            font-size: 0.85rem;
            margin-top: auto;
        }
    </style>
</head>
<body>

    <!-- Header Navigation Bar -->
    <header>
        <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="nav-brand">DevProfile</a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="nav-link">Dashboard</a>
            <a href="${pageContext.request.contextPath}/ConnectionsServlet.do" class="nav-link">Discover Connections</a>
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn-logout">Log Out</a>
        </nav>
    </header>

    <!-- Public Profile Content -->
    <main>
        <div class="card">
            <h1>
                <c:out value="${not empty requestScope.publicProfile.fullname ? requestScope.publicProfile.fullname : requestScope.publicUser.username}" />
            </h1>
            
            <p class="title">
                <c:out value="${not empty requestScope.publicProfile.jobTitle ? requestScope.publicProfile.jobTitle : 'No title specified'}" />
                &bull;
                <c:out value="${not empty requestScope.publicProfile.location ? requestScope.publicProfile.location : 'Unspecified'}" />
            </p>
            
            <div class="detail">
                <span class="label">Username</span>
                <p>@<c:out value="${requestScope.publicUser.username}" /></p>
            </div>

            <div class="detail">
                <span class="label">About</span>
                <p>
                    <c:out value="${not empty requestScope.publicProfile.professionalSummary ? requestScope.publicProfile.professionalSummary : 'No summary provided.'}" />
                </p>
            </div>
        </div>
    </main>

    <footer>
        <p>&copy; 2026 DevProfile. All rights reserved.</p>
    </footer>

</body>
</html>