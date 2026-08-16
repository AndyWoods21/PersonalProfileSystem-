<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Management Area Login</title>
    <style>
        :root {
            --bg-color: #0f172a;
            --card-bg: #1e293b;
            --text-color: #f8fafc;
            --text-muted: #94a3b8;
            --accent-color: #38bdf8;
            --accent-hover: #0284c7;
            --border-color: #334155;
            --error-color: #ef4444;
            --error-bg: rgba(239, 68, 68, 0.1);
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
            padding: 1rem;
        }

        .login-container {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            width: 100%;
            max-width: 400px;
            padding: 2.5rem 2rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3);
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .login-header h1 {
            font-size: 1.6rem;
            color: var(--text-color);
            margin-bottom: 0.5rem;
        }

        .login-header p {
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        .alert-error {
            background-color: var(--error-bg);
            border: 1px solid var(--error-color);
            color: var(--error-color);
            padding: 0.75rem 1rem;
            border-radius: 6px;
            font-size: 0.875rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-color);
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 0.75rem 1rem;
            background-color: var(--bg-color);
            border: 1px solid var(--border-color);
            border-radius: 6px;
            color: var(--text-color);
            font-size: 0.95rem;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.15);
        }

        .btn-submit {
            width: 100%;
            padding: 0.75rem;
            background-color: var(--accent-color);
            color: var(--bg-color);
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 0.5rem;
        }

        .btn-submit:hover {
            background-color: var(--accent-hover);
        }

        /* Signup prompt styling */
        .signup-prompt {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.25rem;
            border-top: 1px solid var(--border-color);
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        .signup-prompt a {
            color: var(--accent-color);
            text-decoration: none;
            font-weight: 600;
            margin-left: 0.25rem;
            transition: color 0.2s;
        }

        .signup-prompt a:hover {
            color: var(--accent-hover);
            text-decoration: underline;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 1.25rem;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.875rem;
            transition: color 0.2s;
        }

        .back-link:hover {
            color: var(--accent-color);
        }
    </style>
</head>
<body>

    <div class="login-container">
        <div class="login-header">
            <h1>Profile Management</h1>
            <p>Please enter your credentials to log in[cite: 1, 2].</p>
        </div>

        <%-- Dynamic Error Banner using JSTL --%>
        <c:if test="${not empty param.error or not empty errorMessage}">
            <div class="alert-error">
                <span>⚠️ <c:out value="${not empty errorMessage ? errorMessage : 'Invalid username or password. Please try again.'}" /></span>[cite: 1, 2]
            </div>
        </c:if>

        <!-- Form submitting directly to LoginServlet.do -->
        <form action="${pageContext.request.contextPath}/LoginServlet.do" method="POST" id="loginForm">
            <div class="form-group">
                <label for="username">Username or Email</label>
                <input 
                    type="text" 
                    id="username" 
                    name="username" 
                    placeholder="Enter your username" 
                    required 
                    autocomplete="username"
                />
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input 
                    type="password" 
                    id="password" 
                    name="password" 
                    placeholder="Enter your password" 
                    required 
                    autocomplete="current-password"
                />
            </div>

            <button type="submit" class="btn-submit">Sign In</button>
        </form>

        <!-- Sign Up Option -->
        <div class="signup-prompt">
            <span>Don't have an account?</span>
            <a href="${pageContext.request.contextPath}/signUp.jsp">Sign Up</a>
        </div>

        <a href="${pageContext.request.contextPath}/" class="back-link">&larr; Back to Public Profile</a>
    </div>

    <script>
        // Client-side Input Validation
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();

            if (!username || !password) {
                e.preventDefault();
                alert('Please fill in all required fields[cite: 1, 2].');
            }
        });
    </script>
</body>
</html>