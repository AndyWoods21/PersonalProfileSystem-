<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="za.ac.org.User" %>
<%@ page import="za.ac.org.PersonalInfoEntity" %>
<%
    // Retrieve objects stored in the session by SignUpServlet and AddInformationServlet
    User user = (User) session.getAttribute("currentUser");
    PersonalInfoEntity pi = (PersonalInfoEntity) session.getAttribute("PersonalInfo");

    // Fallbacks to prevent NullPointerExceptions if session expired or was bypassed
    String username = (user != null && user.getUsername() != null) ? user.getUsername() : "N/A";
    String fullName = (pi != null && pi.getFullname() != null) ? pi.getFullname() : "N/A";
    String email = (pi != null && pi.getEmail() != null) ? pi.getEmail() : "N/A";
    String jobTitle = (pi != null && pi.getJobTitle() != null && !pi.getJobTitle().isEmpty()) ? pi.getJobTitle() : "Not specified";
    String location = (pi != null && pi.getLocation() != null && !pi.getLocation().isEmpty()) ? pi.getLocation() : "Not specified";
    String bio = (pi != null && pi.getProfessionalSummary() != null && !pi.getProfessionalSummary().isEmpty()) ? pi.getProfessionalSummary() : "No bio provided.";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Your Registration Details</title>
    <style>
        :root {
            --bg-color: #0f172a;
            --card-bg: #1e293b;
            --text-color: #f8fafc;
            --text-muted: #94a3b8;
            --accent-color: #38bdf8;
            --accent-hover: #0284c7;
            --border-color: #334155;
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

        .confirm-container {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            width: 100%;
            max-width: 550px;
            padding: 2.5rem 2rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3);
        }

        .confirm-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .confirm-header h1 {
            font-size: 1.6rem;
            color: var(--text-color);
            margin-bottom: 0.5rem;
        }

        .confirm-header p {
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        .details-group {
            background-color: var(--bg-color);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 1.25rem;
            margin-bottom: 1.5rem;
        }

        .details-group h2 {
            font-size: 1.1rem;
            color: var(--accent-color);
            margin-bottom: 1rem;
            padding-bottom: 0.4rem;
            border-bottom: 1px solid var(--border-color);
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            font-size: 0.925rem;
        }

        .detail-item:last-child {
            margin-bottom: 0;
        }

        .detail-label {
            color: var(--text-muted);
            font-weight: 500;
        }

        .detail-value {
            color: var(--text-color);
            font-weight: 600;
            text-align: right;
            max-width: 60%;
            word-break: break-word;
        }

        .btn-group {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .btn {
            flex: 1;
            padding: 0.75rem;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
            transition: background-color 0.2s, border-color 0.2s;
        }

        .btn-primary {
            background-color: var(--accent-color);
            color: var(--bg-color);
            border: none;
        }

        .btn-primary:hover {
            background-color: var(--accent-hover);
        }

        .btn-secondary {
            background-color: transparent;
            color: var(--text-color);
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            background-color: var(--border-color);
        }
    </style>
</head>
<body>

    <div class="confirm-container">
        <div class="confirm-header">
            <h1>Confirm Details</h1>
            <p>Please review your information before completing account creation.</p>
        </div>

        <!-- Account Credentials Section -->
        <div class="details-group">
            <h2>Account Details</h2>
            <div class="detail-item">
                <span class="detail-label">Username:</span>
                <span class="detail-value"><%= username %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Email Address:</span>
                <span class="detail-value"><%= email %></span>
            </div>
        </div>

        <!-- Personal Info Section -->
        <div class="details-group">
            <h2>Personal & Professional Details</h2>
            <div class="detail-item">
                <span class="detail-label">Full Name:</span>
                <span class="detail-value"><%= fullName %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Title / Role:</span>
                <span class="detail-value"><%= jobTitle %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Location:</span>
                <span class="detail-value"><%= location %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Bio:</span>
                <span class="detail-value"><%= bio %></span>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="btn-group">
            <!-- Navigate back to AddInformation.jsp if user wants to edit -->
            <a href="ConfirmSignUp.do" class="btn btn-secondary">&larr; Edit Details</a>

            <!-- Final submission to complete profile process -->
            <a href="${pageContext.request.contextPath}/login.jsp?success=true" class="btn btn-primary">Finish & Login &rarr;</a>
        </div>
    </div>

</body>
</html>