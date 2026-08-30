<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Management Area Registration</title>
    
    <!-- Google Identity Services Library -->
    <script src="https://accounts.google.com/gsi/client" async defer></script>

    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.65);
            --glass-border: rgba(255, 255, 255, 0.8);
            --text-color: #0f172a;
            --text-muted: #64748b;
            --accent-color: #0284c7;
            --accent-hover: #0369a1;
            --input-bg: rgba(255, 255, 255, 0.75);
            --input-border: rgba(203, 213, 225, 0.8);
            --error-color: #dc2626;
            --error-bg: rgba(254, 226, 226, 0.85);
            --success-color: #16a34a;
            --success-bg: rgba(220, 252, 231, 0.85);
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
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }

        .signup-container {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            width: 100%;
            max-width: 450px;
            padding: 2.5rem 2rem;
            box-shadow: 0 20px 40px -15px rgba(15, 23, 42, 0.15), 
                        0 0 15px 0 rgba(255, 255, 255, 0.5) inset;
        }

        .signup-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .signup-header h1 {
            font-size: 1.6rem;
            color: var(--text-color);
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .signup-header p {
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        .alert {
            padding: 0.75rem 1rem;
            border-radius: 8px;
            font-size: 0.875rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
        }

        .alert-error {
            background-color: var(--error-bg);
            border: 1px solid rgba(220, 38, 38, 0.3);
            color: var(--error-color);
        }

        .alert-success {
            background-color: var(--success-bg);
            border: 1px solid rgba(22, 163, 74, 0.3);
            color: var(--success-color);
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        label {
            display: block;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-color);
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 0.75rem 1rem;
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: 8px;
            color: var(--text-color);
            font-size: 0.95rem;
            transition: all 0.2s ease;
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: var(--accent-color);
            background-color: rgba(255, 255, 255, 0.9);
            box-shadow: 0 0 0 4px rgba(2, 132, 199, 0.15);
        }

        .btn-submit {
            width: 100%;
            padding: 0.75rem;
            background-color: var(--accent-color);
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-top: 0.5rem;
            box-shadow: 0 4px 12px rgba(2, 132, 199, 0.25);
        }

        .btn-submit:hover {
            background-color: var(--accent-hover);
            box-shadow: 0 6px 16px rgba(2, 132, 199, 0.35);
        }

        .divider {
            text-align: center;
            margin: 1.5rem 0 1rem;
            position: relative;
        }

        .divider::before {
            content: "";
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background-color: rgba(226, 232, 240, 0.8);
            z-index: 1;
        }

        .divider span {
            position: relative;
            z-index: 2;
            background-color: rgba(255, 255, 255, 0.85);
            padding: 0 0.75rem;
            color: var(--text-muted);
            font-size: 0.8rem;
            font-weight: 600;
            border-radius: 4px;
        }

        .login-prompt {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.25rem;
            border-top: 1px solid rgba(226, 232, 240, 0.8);
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
            <p>Register as developer to access management controls.</p>
        </div>

        <%-- Dynamic Error/Success Banners --%>
        <% 
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            
            if (error != null || request.getAttribute("errorMessage") != null) {
                String message = (request.getAttribute("errorMessage") != null) 
                                 ? (String) request.getAttribute("errorMessage") 
                                 : "Registration failed. Please check your details and try again.";
        %>
            <div class="alert alert-error">
                <span>⚠️ <%= message %></span>
            </div>
        <% } else if (success != null) { %>
            <div class="alert alert-success">
                <span>✅ Account created successfully! You can now log in.</span>
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

        <!-- Google Sign-Up Divider & Container -->
        <div class="divider">
            <span>OR</span>
        </div>

        <div id="g_id_onload"
             data-client_id="983198702888-j2n21nvkgkddb10k5dk72m9rpn024h8s.apps.googleusercontent.com"
             data-callback="handleCredentialResponse">
        </div>

        <div class="g_id_signin" 
             data-type="standard" 
             data-shape="rectangular" 
             data-theme="outline" 
             data-text="signup_with" 
             data-size="large" 
             data-logo_alignment="left"
             style="width: 100%; display: flex; justify-content: center;">
        </div>

        <!-- Hidden form for posting Google ID token to GoogleAuthServlet -->
        <form id="googleAuthForm" action="${pageContext.request.contextPath}/GoogleAuthServlet" method="POST" style="display:none;">
            <input type="hidden" name="idToken" id="googleIdToken">
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
                alert('Passwords do not match. Please verify and try again.');
            }
        });

        // Google Authentication Response Handler
        function handleCredentialResponse(response) {
            document.getElementById('googleIdToken').value = response.credential;
            document.getElementById('googleAuthForm').submit();
        }
    </script>
</body>
</html>