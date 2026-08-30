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
            --bg-color: #0f172a;
            --card-bg: #1e293b;
            --text-color: #f8fafc;
            --text-muted: #94a3b8;
            --accent-color: #38bdf8;
            --accent-hover: #0284c7;
            --border-color: #334155;
            --input-disabled: #0f172a;
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
            padding: 2rem 1rem;
        }

        .profile-container {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            width: 100%;
            max-width: 550px;
            padding: 2.5rem 2rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3);
        }

        .profile-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .profile-header h1 {
            font-size: 1.6rem;
            color: var(--text-color);
            margin-bottom: 0.5rem;
        }

        .profile-header p {
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
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-color);
        }

        input[type="text"],
        input[type="email"],
        input[type="url"],
        textarea {
            width: 100%;
            padding: 0.75rem 1rem;
            background-color: var(--bg-color);
            border: 1px solid var(--border-color);
            border-radius: 6px;
            color: var(--text-color);
            font-size: 0.95rem;
            transition: border-color 0.2s, box-shadow 0.2s;
            font-family: inherit;
        }

        input[readonly] {
            background-color: var(--input-disabled);
            color: var(--text-muted);
            cursor: not-allowed;
            border-style: dashed;
        }

        input:focus:not([readonly]),
        textarea:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.15);
        }

        textarea {
            resize: vertical;
            min-height: 90px;
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

        .skip-link {
            display: block;
            text-align: center;
            margin-top: 1.25rem;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.875rem;
            transition: color 0.2s;
        }

        .skip-link:hover {
            color: var(--accent-color);
        }
    </style>
</head>
<body>

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
            <div class="alert-error" style="background-color: #fef3c7; border-color: #f59e0b; color: #b45309;">
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