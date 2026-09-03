<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Profile Information</title>
    <style>
        :root {
            /* Standard Neutral Dark Grey Color Palette */
            --bg-canvas-tint: rgba(30, 30, 30, 0.75);        /* Semi-transparent dark overlay */
            --bg-main: #1e1e1e;                             /* Standard dark grey background */
            --bg-light-gray: rgba(45, 45, 45, 0.45);        /* Main container: highly transparent dark grey */
            --card-bg: rgba(55, 55, 55, 0.35);             /* Cards/Divs: increased transparency */
            --badge-bg: rgba(220, 220, 220, 0.12);          /* Subtle light grey pill badge */
            --text-heading: #f5f5f5;                        /* Bright off-white heading */
            --text-body: #cccccc;                           /* Light neutral grey text */
            --text-muted: #aaaaaa;                          /* Muted label/text color */
            
            /* Light Grey Buttons & Accents */
            --btn-dark: #e0e0e0;                            /* Light grey primary button */
            --btn-dark-text: #1e1e1e;                       /* Dark text for contrast */
            --btn-hover: #ffffff;                           /* Pure white hover */
            --danger-color: #ff5252;                        /* Accent red */
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
            z-index: -1;
            pointer-events: none;
        }

        .profile-container {
            background-color: var(--card-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            width: 100%;
            max-width: 580px;
            padding: 2.5rem;
            box-shadow: var(--shadow-soft);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            position: relative;
            z-index: 1;
        }

        .profile-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .profile-header h1 {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-heading);
            margin-bottom: 0.5rem;
            letter-spacing: -0.5px;
        }

        .profile-header p {
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        .alert-error {
            background-color: rgba(255, 82, 82, 0.1);
            border: 1px solid rgba(255, 82, 82, 0.4);
            color: var(--danger-color);
            padding: 0.85rem 1rem;
            border-radius: var(--radius-md);
            font-size: 0.875rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        @media (max-width: 480px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        label {
            display: block;
            font-size: 0.72rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            font-weight: 700;
            margin-bottom: 0.35rem;
        }

        input[type="text"],
        input[type="email"],
        input[type="url"],
        textarea {
            width: 100%;
            padding: 0.75rem 1rem;
            background-color: rgba(30, 30, 30, 0.6);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            color: var(--text-heading);
            font-size: 0.95rem;
            transition: all 0.2s ease;
            font-family: inherit;
            outline: none;
        }

        input[readonly] {
            background-color: rgba(15, 15, 15, 0.8);
            color: var(--text-muted);
            cursor: not-allowed;
            border-style: dashed;
        }

        input:focus:not([readonly]),
        textarea:focus {
            background: rgba(40, 40, 40, 0.9);
            border-color: var(--btn-dark);
            box-shadow: 0 0 0 3px rgba(224, 224, 224, 0.15);
        }

        textarea {
            resize: vertical;
            min-height: 95px;
        }

        .btn-submit {
            width: 100%;
            padding: 0.75rem;
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

        .skip-link {
            display: block;
            text-align: center;
            margin-top: 1.5rem;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 500;
            transition: color 0.2s;
        }

        .skip-link:hover {
            color: var(--text-heading);
        }
    </style>
</head>
<body>

    <!-- Background Animation Canvas -->
    <canvas id="techCanvas"></canvas>

    <div class="profile-container">
        <div class="profile-header">
            <h1>Complete Your Profile</h1>
            <p>Tell us a bit more about yourself to customize your space.</p>
        </div>

        <%-- Declarative Error Banner --%>
        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert-error">
                <span>⚠️ <c:out value="${requestScope.errorMessage}" /></span>
            </div>
        </c:if>

        <%-- Email Verification Status Banner --%>
        <c:if test="${not sessionScope.currentUser.verified}">
            <div class="alert-error" style="background-color: rgba(254, 243, 199, 0.1); border-color: #f59e0b; color: #fbbf24;">
                <span>⚠️ Your email (<strong><c:out value="${sessionScope.PersonalInfo.email}"/></strong>) is not verified yet. Please check your inbox for the link.</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/AddInformationServlet.do" method="POST" id="infoForm">
            
            <!-- Pre-filled & Read-only section from Session -->
            <div class="form-row">
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input 
                        type="text" 
                        id="fullName" 
                        name="fullName" 
                        value="<c:out value='${sessionScope.PersonalInfo.fullname}' />" 
                        readonly 
                        title="Set during registration"
                    />
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        value="<c:out value='${sessionScope.PersonalInfo.email}' />" 
                        readonly 
                        title="Set during registration"
                    />
                </div>
            </div>

            <!-- Additional Details to Complete Profile -->
            <div class="form-group">
                <label for="title">Professional Title / Role</label>
                <input 
                    type="text" 
                    id="title" 
                    name="title" 
                    value="<c:out value='${sessionScope.PersonalInfo.jobTitle}' />"
                    placeholder="e.g. Full-Stack Developer / Student" 
                    required 
                />
            </div>

            <div class="form-group">
                <label for="location">Location</label>
                <input 
                    type="text" 
                    id="location" 
                    name="location" 
                    value="<c:out value='${sessionScope.PersonalInfo.location}' />"
                    placeholder="e.g. Johannesburg, South Africa" 
                />
            </div>

            <div class="form-group">
                <label for="bio">Short Bio</label>
                <textarea 
                    id="bio" 
                    name="bio" 
                    placeholder="Write a brief introduction about your skills and interests..."
                ><c:out value="${sessionScope.PersonalInfo.professionalSummary}" /></textarea>
            </div>

            <div class="form-group">
                <label for="website">Portfolio / Website Link</label>
                <input 
                    type="url" 
                    id="website" 
                    name="website" 
                    value="<c:out value='${sessionScope.PersonalInfo.websiteUrl}' />"
                    placeholder="https://yourportfolio.com" 
                />
            </div>

            <button type="submit" class="btn-submit">Save & Complete Profile</button>
        </form>

        <a href="${pageContext.request.contextPath}/" class="skip-link">Skip for now &rarr;</a>
    </div>

</body>
</html>