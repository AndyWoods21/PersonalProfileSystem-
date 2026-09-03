<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Email OTP</title>
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
            
            /* Light Grey Buttons & Accents */
            --btn-dark: #e0e0e0;                            /* Light grey primary button */
            --btn-dark-text: #1e1e1e;                       /* Dark text for contrast */
            --btn-hover: #ffffff;                           /* Pure white hover */
            --danger-color: #ff5252;                        /* Accent red */
            --success-color: #4ade80;                       /* Success green */
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
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
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

        .signup-container {
            background: var(--bg-light-gray);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            width: 100%;
            max-width: 450px;
            padding: 2.5rem 2rem;
            box-shadow: var(--shadow-soft);
            position: relative;
            z-index: 1;
        }

        .signup-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .signup-header h1 {
            font-size: 1.6rem;
            color: var(--text-heading);
            margin-bottom: 0.5rem;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .signup-header p {
            color: var(--text-body);
            font-size: 0.9rem;
            line-height: 1.4;
        }

        .alert {
            padding: 0.85rem 1rem;
            border-radius: var(--radius-md);
            font-size: 0.875rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
        }

        .alert-error {
            background-color: rgba(255, 82, 82, 0.15);
            border: 1px solid rgba(255, 82, 82, 0.3);
            color: var(--danger-color);
        }

        .alert-success {
            background-color: rgba(74, 222, 128, 0.15);
            border: 1px solid rgba(74, 222, 128, 0.3);
            color: var(--success-color);
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        label {
            display: block;
            font-size: 0.81rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--text-heading);
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        input[type="text"] {
            width: 100%;
            padding: 0.85rem 1rem;
            background-color: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: var(--radius-md);
            color: var(--text-heading);
            font-size: 1.35rem;
            letter-spacing: 0.35rem;
            text-align: center;
            font-weight: 700;
            transition: all 0.2s ease;
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
        }

        input[type="text"]:focus {
            outline: none;
            border-color: var(--btn-dark);
            background-color: rgba(65, 65, 65, 0.45);
            box-shadow: 0 0 15px rgba(224, 224, 224, 0.15);
        }

        .btn-submit {
            width: 100%;
            padding: 0.85rem;
            background-color: var(--btn-dark);
            color: var(--btn-dark-text);
            border: none;
            border-radius: var(--radius-pill);
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-top: 0.5rem;
            box-shadow: 0 4px 12px rgba(255, 255, 255, 0.1);
        }

        .btn-submit:hover {
            background-color: var(--btn-hover);
            color: #000000;
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(255, 255, 255, 0.25);
        }

        .login-prompt {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.25rem;
            border-top: 1px solid var(--glass-border);
            font-size: 0.875rem;
            color: var(--text-body);
        }

        .login-prompt a {
            color: var(--text-heading);
            text-decoration: none;
            font-weight: 700;
            margin-left: 0.25rem;
            transition: color 0.2s;
            border-bottom: 1px dotted var(--text-body);
        }

        .login-prompt a:hover {
            color: #ffffff;
            border-bottom-style: solid;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 1rem;
            color: var(--text-body);
            text-decoration: none;
            font-size: 0.85rem;
            transition: color 0.2s;
        }

        .back-link:hover {
            color: var(--text-heading);
        }
    </style>
</head>
<body>

    <canvas id="techCanvas"></canvas>

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
        <a href="${pageContext.request.contextPath}/index.html" class="back-link">Go to landing page </a>
    </div>

</body>
</html>