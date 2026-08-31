<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Email OTP</title>
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

        input[type="text"] {
            width: 100%;
            padding: 0.75rem 1rem;
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: 8px;
            color: var(--text-color);
            font-size: 1.25rem;
            letter-spacing: 0.35rem;
            text-align: center;
            font-weight: 700;
            transition: all 0.2s ease;
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
        }

        input[type="text"]:focus {
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
            margin-top: 1rem;
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
            <h1>Enter Verification Code</h1>
            <p>We've sent a 6-digit OTP code to your registered email address.</p>
        </div>

        <% String error = (String) request.getAttribute("errorMessage"); %>
        <% if (error != null) { %>
            <div class="alert alert-error">
                <span><%= error %></span>
            </div>
        <% } %>

        <% String success = (String) request.getAttribute("successMessage"); %>
        <% if (success != null) { %>
            <div class="alert alert-success">
                <span><%= success %></span>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/VerifyEmailServlet.do" method="POST">
            <div class="form-group">
                <label for="otp">OTP Code</label>
                <input type="text" id="otp" name="otp" maxlength="6" pattern="\d{6}" required placeholder="123456" autocomplete="one-time-code" />
            </div>
            
            <button type="submit" class="btn-submit">Verify Account</button>
        </form>

        <div class="login-prompt">
    Didn't receive code? 
    <a href="${pageContext.request.contextPath}/ResendOtpServlet.do?email=${sessionScope.userEmail != null ? sessionScope.userEmail : sessionScope.PersonalInfo.email}">Resend OTP</a>
</div>

        <a href="${pageContext.request.contextPath}/login.jsp" class="back-link">&larr; Back to Login</a>
        <a href="${pageContext.request.contextPath}/dashboard.jsp" class="back-link">Go to Dashboard</a>
    </div>

</body>
</html>
