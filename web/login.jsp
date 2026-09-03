<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Management Area Login</title>
    
    <!-- Google Identity Services Library -->
    <script src="https://accounts.google.com/gsi/client" async defer></script>

    <style>
        :root {
            /* Dark Gray Glassmorphism Color Palette */
            --glass-bg: rgba(31, 41, 55, 0.85);             /* Translucent dark gray card background */
            --glass-border: rgba(229, 231, 235, 0.2);       /* Light gray outline */
            --text-heading: #F9FAFB;                         /* Off-white heading text */
            --text-body: #D1D5DB;                            /* Light gray secondary text */
            --btn-dark: #111827;                             /* Deep dark gray button */
            --btn-hover: #030712;                            /* Hover state to solid black */
            --input-bg: rgba(17, 24, 39, 0.7);              /* Darker input background */
            --input-border: rgba(107, 114, 128, 0.5);        /* Light gray input border */
            --input-placeholder: #9CA3AF;                    /* Light gray placeholder text */
            --badge-bg: #374151;                             /* Medium slate gray pill tag background */
            --error-color: #fca5a5;
            --error-bg: rgba(153, 27, 27, 0.85);
            --success-color: #86efac;
            --success-bg: rgba(20, 83, 45, 0.85);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background-color: #000000;
            color: var(--text-heading);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem 1rem;
            position: relative;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        /* Fullscreen Matrix Canvas fixed in background */
        #matrixCanvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: -1;
            pointer-events: none;
        }

        /* Dark Gray Container with Light Gray Outline */
        .login-container {
            position: relative;
            z-index: 1;
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            width: 100%;
            max-width: 440px;
            padding: 2.5rem 2rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6), 
                        0 0 15px rgba(255, 255, 255, 0.05);
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .login-header h1 {
            font-size: 1.75rem;
            color: var(--text-heading);
            margin-bottom: 0.5rem;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .login-header p {
            color: var(--text-body);
            font-size: 0.95rem;
        }

        .alert {
            padding: 0.75rem 1rem;
            border-radius: 10px;
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
            border: 1px solid rgba(239, 68, 68, 0.4);
            color: var(--error-color);
        }

        .alert-success {
            background-color: var(--success-bg);
            border: 1px solid rgba(34, 197, 94, 0.4);
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
            color: var(--text-heading);
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 0.75rem 1rem;
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: 10px;
            color: var(--text-heading);
            font-size: 0.95rem;
            transition: all 0.2s ease;
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
        }

        input[type="text"]::placeholder,
        input[type="password"]::placeholder {
            color: var(--input-placeholder);
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #FFFFFF;
            background-color: rgba(17, 24, 39, 0.9);
            box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.15);
        }

        .btn-submit {
            width: 100%;
            padding: 0.85rem;
            background-color: var(--btn-dark);
            color: #ffffff;
            border: 1px solid var(--glass-border);
            border-radius: 9999px;
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.25s ease;
            margin-top: 0.5rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
        }

        .btn-submit:hover {
            background-color: var(--btn-hover);
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.6);
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
            background-color: var(--glass-border);
            z-index: 1;
        }

        .divider span {
            position: relative;
            z-index: 2;
            background-color: var(--badge-bg);
            padding: 0.2rem 0.75rem;
            color: var(--text-body);
            font-size: 0.8rem;
            font-weight: 600;
            border-radius: 9999px;
            border: 1px solid var(--glass-border);
        }

        .signup-prompt {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.25rem;
            border-top: 1px solid var(--glass-border);
            font-size: 0.875rem;
            color: var(--text-body);
        }

        .signup-prompt a {
            color: var(--text-heading);
            text-decoration: none;
            font-weight: 700;
            margin-left: 0.25rem;
            transition: color 0.2s;
        }

        .signup-prompt a:hover {
            text-decoration: underline;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 1.25rem;
            color: var(--text-body);
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 500;
            transition: color 0.2s;
        }

        .back-link:hover {
            color: var(--text-heading);
        }
    </style>
</head>
<body>

    <!-- Matrix Digital Rain Canvas Background -->
    <canvas id="matrixCanvas"></canvas>

    <div class="login-container">
        <div class="login-header">
            <h1>Welcome Back</h1>
            <p>Enter your credentials to access the management area.</p>
        </div>

        <%-- Dynamic Error Banner --%>
        <c:if test="${not empty param.error or not empty errorMessage}">
            <div class="alert alert-error">
                <span>⚠️ <c:out value="${not empty errorMessage ? errorMessage : 'Invalid username or password.'}" /></span>
            </div>
        </c:if>

        <%-- Dynamic Success Banner --%>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                <span>✅ <c:out value="${successMessage}" /></span>
            </div>
        </c:if>

        <!-- Form submitting directly to LoginServlet.do -->
        <form action="${pageContext.request.contextPath}/LoginServlet.do" method="POST" id="loginForm">
            <div class="form-group">
                <label for="username">Username</label>
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

            <button type="submit" class="btn-submit">Log In</button>
        </form>

        <!-- Google Sign-In Divider & Action Container -->
        <div class="divider">
            <span>OR</span>
        </div>

        <div id="g_id_onload"
             data-client_id="983198702888-j2n21nvkgkddb10k5dk72m9rpn024h8s.apps.googleusercontent.com"
             data-callback="handleCredentialResponse">
        </div>

        <div class="g_id_signin" 
             data-type="standard" 
             data-shape="pill" 
             data-theme="filled_blue" 
             data-text="sign_in_with" 
             data-size="large" 
             data-logo_alignment="left"
             style="width: 100%; display: flex; justify-content: center;">
        </div>

        <!-- Hidden form for posting Google ID token to GoogleAuthServlet -->
        <form id="googleAuthForm" action="${pageContext.request.contextPath}/GoogleAuthServlet" method="POST" style="display:none;">
            <input type="hidden" name="idToken" id="googleIdToken">
        </form>

        <!-- Sign Up Option -->
        <div class="signup-prompt">
            <span>Don't have an account?</span>
            <a href="${pageContext.request.contextPath}/signUp.jsp">Sign Up</a>
        </div>

        <a href="${pageContext.request.contextPath}/" class="back-link">&larr; Back to Public Profile</a>
    </div>

    <script>
        // Matrix Rain Background Animation with "LOGIN" vertical text streams
        const canvas = document.getElementById('matrixCanvas');
        const ctx = canvas.getContext('2d');

        function resizeCanvas() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        }
        resizeCanvas();

        // Custom set incorporating "LOGIN", katakana, and digits
        const matrixChars = 'LOGINLOGINLOGINアァカサタナハマヤャラワガザダバパイィキシチニヒミリヰギジヂビピウゥクスツヌフムユュルグズブヅプエェケセテネヘメレヱゲゼデベペオォコソトノホモヨョロヲゴゾドボポヴッン0123456789';
        const fontSize = 16;
        let columns = Math.floor(canvas.width / fontSize);
        let drops = Array(columns).fill(1);

        function drawMatrix() {
            ctx.fillStyle = 'rgba(0, 0, 0, 0.05)';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            ctx.fillStyle = '#0F0';
            ctx.font = `${fontSize}px monospace`;

            for (let i = 0; i < drops.length; i++) {
                // Periodically sequence "LOGIN" down selected vertical drops
                let text;
                const dropPosition = drops[i];

                if (i % 3 === 0) { // Render "L-O-G-I-N" on every 3rd stream
                    const loginWord = "LOGIN";
                    text = loginWord[(dropPosition - 1) % loginWord.length];
                } else {
                    text = matrixChars.charAt(Math.floor(Math.random() * matrixChars.length));
                }

                const x = i * fontSize;
                const y = dropPosition * fontSize;

                ctx.fillText(text, x, y);

                if (y > canvas.height && Math.random() > 0.975) {
                    drops[i] = 0;
                }
                drops[i]++;
            }
        }

        window.addEventListener('resize', () => {
            resizeCanvas();
            columns = Math.floor(canvas.width / fontSize);
            drops = Array(columns).fill(1);
        });

        setInterval(drawMatrix, 33);

        // Client-side Input Validation
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();

            if (!username || !password) {
                e.preventDefault();
                alert('Please enter both your username and password.');
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