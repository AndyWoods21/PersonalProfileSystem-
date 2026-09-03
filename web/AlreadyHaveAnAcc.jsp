<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Automatic Meta Refresh: Redirects to login.jsp after 5 seconds -->
    <meta http-equiv="refresh" content="5;url=${pageContext.request.contextPath}/login.jsp" />
    <title>Account Already Exists</title>
    <style>
        :root {
            --bg-color: #0f172a;
            --card-bg: #1e293b;
            --text-color: #f8fafc;
            --text-muted: #94a3b8;
            --accent-color: #38bdf8;
            --accent-hover: #0284c7;
            --border-color: #334155;
            --warning-color: #f59e0b;
            --warning-bg: rgba(245, 158, 11, 0.1);
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
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }

        .alert-container {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            width: 100%;
            max-width: 450px;
            padding: 2.5rem 2rem;
            text-align: center;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3);
        }

        .icon-box {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .alert-container h1 {
            font-size: 1.6rem;
            color: var(--text-color);
            margin-bottom: 0.75rem;
        }

        .alert-container p {
            color: var(--text-muted);
            font-size: 0.95rem;
            line-height: 1.5;
            margin-bottom: 1.5rem;
        }

        .redirect-notice {
            background-color: var(--warning-bg);
            border: 1px solid var(--warning-color);
            color: var(--warning-color);
            padding: 0.75rem 1rem;
            border-radius: 6px;
            font-size: 0.875rem;
            margin-bottom: 1.5rem;
        }

        .btn-group {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 0.75rem;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            transition: background-color 0.2s, border-color 0.2s;
        }

        .btn-primary {
            background-color: var(--accent-color);
            color: var(--bg-color);
        }

        .btn-primary:hover {
            background-color: var(--accent-hover);
        }

        .btn-secondary {
            background-color: transparent;
            color: var(--text-muted);
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            color: var(--text-color);
            border-color: var(--text-muted);
        }
    </style>
</head>
<body>

    <div class="alert-container">
        <div class="icon-box">⚠️</div>
        <h1>Account Already Exists</h1>
        <p>It looks like a user with that username or email address is already registered in our system[cite: 1, 2].</p>

        <div class="redirect-notice">
            <span>Redirecting to the login page in <strong id="countdown">5</strong> seconds...</span>
        </div>

        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary">Go to Login Page Now &rarr;</a>
            <a href="${pageContext.request.contextPath}/signUp.jsp" class="btn btn-secondary">&larr; Try Registering with Different Details</a>
        </div>
    </div>

    <script>
        // JS Countdown timer script
        let timeLeft = 5;
        const countdownElement = document.getElementById('countdown');

        const timer = setInterval(() => {
            timeLeft--;
            if (countdownElement) {
                countdownElement.textContent = timeLeft;
            }
            if (timeLeft <= 0) {
                clearInterval(timer);
                window.location.href = "${pageContext.request.contextPath}/login.jsp";
            }
        }, 1000);
    </script>
</body>
</html>