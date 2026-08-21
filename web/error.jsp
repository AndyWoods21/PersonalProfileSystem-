<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page isErrorPage="true" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error — DevProfile</title>
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

        /* App Layout Container */
        .app-container {
            display: flex;
            flex: 1;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            max-width: 1280px;
            width: 100%;
            margin: 0 auto;
        }

        .card {
            background-color: var(--bg-main);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 2.5rem;
            box-shadow: var(--shadow-soft);
            backdrop-filter: blur(8px);
            max-width: 540px;
            width: 100%;
            text-align: center;
        }

        .error-icon {
            width: 64px;
            height: 64px;
            background-color: rgba(239, 68, 68, 0.1);
            color: var(--danger-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem auto;
            font-size: 1.75rem;
            font-weight: bold;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .card h1 {
            font-size: 1.5rem;
            font-weight: 800;
            letter-spacing: -0.5px;
            color: var(--text-dark);
            margin-bottom: 0.75rem;
        }

        .error-message {
            color: var(--text-muted);
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 2rem;
        }

        .actions {
            display: flex;
            gap: 0.75rem;
            justify-content: center;
            flex-wrap: wrap;
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
            text-decoration: none;
            display: inline-block;
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
            <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="btn-action-sm">Dashboard</a>
        </div>
    </header>

    <div class="app-container">
        <!-- Main Error Card -->
        <div class="card">
            <div class="error-icon">!</div>
            
            <h1>Something Went Wrong</h1>
            
            <p class="error-message">
                <% 
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null && !errorMessage.trim().isEmpty()) {
                        out.print(errorMessage);
                    } else if (exception != null && exception.getMessage() != null) {
                        out.print(exception.getMessage());
                    } else {
                        out.print("An unexpected error occurred while processing your request.");
                    }
                %>
            </p>

            <div class="actions">
                <a href="javascript:history.back()" class="btn-cancel">Go Back</a>
                <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="btn-submit">Go to Dashboard</a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <p>&copy; 2026 DevProfile. All rights reserved.</p>
    </footer>

</body>
</html>