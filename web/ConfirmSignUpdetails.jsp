<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Profile Information — DevProfile</title>
    <style>
        :root {
            /* Shared Light Glass Theme Palette from Index */
            --glass-bg: rgba(255, 255, 255, 0.65);
            --glass-bg-hover: rgba(255, 255, 255, 0.82);
            --glass-border: rgba(255, 255, 255, 0.7);
            --glass-header: rgba(255, 255, 255, 0.75);
            
            /* Text & Accent Tokens */
            --text-dark: #0f172a;
            --text-muted: #475569;
            --accent-color: #2563eb;
            --accent-gradient: linear-gradient(135deg, #1d4ed8 0%, #6d28d9 100%);
            --accent-light: rgba(37, 99, 235, 0.12);
            
            /* Elevation & Blur */
            --glass-shadow: 0 10px 32px 0 rgba(0, 0, 0, 0.12);
            --glass-blur: blur(18px);
            
            /* Input & Error Tokens */
            --input-bg: rgba(255, 255, 255, 0.75);
            --input-border: rgba(255, 255, 255, 0.8);
            --input-readonly-bg: rgba(241, 245, 249, 0.5);
            --error-color: #dc2626;
            --error-bg: rgba(254, 226, 226, 0.75);
            --error-border: rgba(248, 113, 113, 0.6);
            
            /* Radii */
            --radius-sm: 10px;
            --radius-md: 16px;
            --radius-lg: 24px;
            --radius-pill: 9999px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(rgba(15, 23, 42, 0.35), rgba(15, 23, 42, 0.35)), url('${pageContext.request.contextPath}/background.jpg') no-repeat center center fixed;
            background-size: cover;
            color: var(--text-dark);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            -webkit-font-smoothing: antialiased;
        }

        /* Top Navigation Header Matching Index */
        header {
            position: sticky;
            top: 0;
            background: var(--glass-header);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border-bottom: 1px solid var(--glass-border);
            z-index: 1000;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }

        nav {
            max-width: 1280px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 2rem;
            gap: 1rem;
        }

        nav .logo {
            font-weight: 800;
            font-size: 1.35rem;
            letter-spacing: -0.5px;
            background: var(--accent-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-decoration: none;
        }

        nav a.nav-link {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        nav a.nav-link:hover {
            color: var(--accent-color);
        }

        /* Main Wrapper */
        main {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 1.5rem;
        }

        /* Outer Glass Container */
        .profile-container {
            background: var(--glass-bg);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            width: 100%;
            max-width: 580px;
            padding: 2.5rem;
            box-shadow: var(--glass-shadow);
            transition: all 0.25s ease;
        }

        .profile-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .profile-header h1 {
            font-size: 2rem;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            letter-spacing: -0.5px;
        }

        .profile-header p {
            color: var(--text-muted);
            font-size: 0.95rem;
        }

        .alert-error {
            background-color: var(--error-bg);
            border: 1px solid var(--error-border);
            color: var(--error-color);
            padding: 0.85rem 1.1rem;
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.25rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        label {
            display: block;
            font-size: 0.875rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--text-dark);
        }

        /* Glass Form Inputs */
        input[type="text"],
        input[type="email"],
        input[type="url"],
        textarea {
            width: 100%;
            padding: 0.8rem 1rem;
            background: var(--input-bg);
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
            border: 1px solid var(--input-border);
            border-radius: var(--radius-sm);
            color: var(--text-dark);
            font-size: 0.95rem;
            transition: all 0.2s ease;
            font-family: inherit;
        }

        input[readonly] {
            background: var(--input-readonly-bg);
            color: var(--text-muted);
            cursor: not-allowed;
            border-style: dashed;
        }

        input:focus:not([readonly]),
        textarea:focus {
            outline: none;
            background: #ffffff;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        /* Primary CTA Button with Accent Gradient */
        .btn-submit {
            width: 100%;
            padding: 0.9rem 1.25rem;
            background: var(--accent-gradient);
            color: #ffffff;
            border: none;
            border-radius: var(--radius-pill);
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
            transition: all 0.25s ease;
            margin-top: 0.5rem;
        }

        .btn-submit:hover {
            opacity: 0.95;
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.45);
            transform: translateY(-2px);
        }

        .skip-link {
            display: block;
            text-align: center;
            margin-top: 1.25rem;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 600;
            transition: color 0.2s;
        }

        .skip-link:hover {
            color: var(--accent-color);
        }

        footer {
            text-align: center;
            padding: 2rem;
            color: #ffffff;
            font-size: 0.85rem;
            font-weight: 600;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.4);
        }

        @media (max-width: 600px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .profile-container {
                padding: 1.75rem 1.25rem;
            }
        }
    </style>
</head>
<body>

    <!-- Header / Navigation Matching Index -->
    <header>
        <nav>
            <a href="${pageContext.request.contextPath}/" class="logo">DevProfile</a>
            <a href="${pageContext.request.contextPath}/" class="nav-link">&larr; Back to Home</a>
        </nav>
    </header>

    <main>
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

                <button type="submit" class="btn-submit">Save & Complete Profile &rarr;</button>
            </form>

            <a href="${pageContext.request.contextPath}/" class="skip-link">Skip for now &rarr;</a>
        </div>
    </main>

    <footer>
        <p>&copy; 2026 DevProfile Platform. All rights reserved.</p>
    </footer>

</body>
</html>
