<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Management Area Registration</title>
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
            --success-color: #22c55e;
            --success-bg: rgba(34, 197, 94, 0.1);
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

        .signup-container {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            width: 100%;
            max-width: 450px;
            padding: 2.5rem 2rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3);
        }

        .signup-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .signup-header h1 {
            font-size: 1.6rem;
            color: var(--text-color);
            margin-bottom: 0.5rem;
        }

        .signup-header p {
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        .alert {
            padding: 0.75rem 1rem;
            border-radius: 6px;
            font-size: 0.875rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-error {
            background-color: var(--error-bg);
            border: 1px solid var(--error-color);
            color: var(--error-color);
        }

        .alert-success {
            background-color: var(--success-bg);
            border: 1px solid var(--success-color);
            color: var(--success-color);
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
        input[type="email"],
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

        input:focus {
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

        .login-prompt {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.25rem;
            border-top: 1px solid var(--border-color);
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        .login-prompt a {
            color: var(--accent-color);
            text-decoration: none;
            font-weight: 600;
            margin-left: 0.25rem;
            transition: color 0.2s;
        }

        .login-prompt a:hover {
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

    <div class="signup-container">
        <div class="signup-header">
            <h1>Create Account</h1>
            <p>Register as developer to access management controls[cite: 1, 2].</p>
        </div>

        <%-- Dynamic Error/Success Banners --%>
        <% 
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            
            if (error != null || request.getAttribute("errorMessage") != null) {
                String message = (request.getAttribute("errorMessage") != null) 
                                 ? (String) request.getAttribute("errorMessage") 
                                 : "Registration failed. Please check your details and try again[cite: 1, 2].";
        %>
            <div class="alert alert-error">
                <span>⚠️ <%= message %></span>
            </div>
        <% } else if (success != null) { %>
            <div class="alert alert-success">
                <span>✅ Account created successfully! You can now log in[cite: 1, 2].</span>
            </div>
        <% } %>

        <!-- Registration form submitting to SignUpServlet.do -->
        <form action="SignUpServlet.do" method="POST" id="signUpForm">
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input 
                    type="text" 
                    id="fullName" 
                    name="fullName" 
                    placeholder="e.g. Jane Doe" 
                    required 
                    autocomplete="name"
                />
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input 
                    type="email" 
                    id="email" 
                    name="email" 
                    placeholder="name@example.com" 
                    required 
                    autocomplete="email"
                />
            </div>

            <div class="form-group">
                <label for="username">Username</label>
                <input 
                    type="text" 
                    id="username" 
                    name="username" 
                    placeholder="Choose a username" 
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
                    placeholder="Create a password" 
                    required 
                    minlength="6"
                    autocomplete="new-password"
                />
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input 
                    type="password" 
                    id="confirmPassword" 
                    name="confirmPassword" 
                    placeholder="Re-enter password" 
                    required 
                    minlength="6"
                    autocomplete="new-password"
                />
            </div>

            <button type="submit" class="btn-submit">Create Developer Profile Account</button>
        </form>

        <div class="login-prompt">
            <span>Already registered?</span>
            <a href="login.jsp">Sign In</a>
        </div>

        <a href="${pageContext.request.contextPath}/" class="back-link">&larr; Back to Public Profile</a>
    </div>

    <script>
        // Client-side Input and Password Match Validation
        document.getElementById('signUpForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match. Please verify and try again[cite: 1, 2].');
            }
        });
    </script>
</body>
</html>