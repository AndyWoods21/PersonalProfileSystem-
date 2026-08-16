<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Guard: Prevent direct rendering if attributes were not populated by PublicProfileServlet --%>
<c:if test="${empty requestScope.publicUser}">
    <c:redirect url="/error.jsp" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:out value="${not empty requestScope.publicProfile.fullname ? requestScope.publicProfile.fullname : requestScope.publicUser.username}" /> — Public Profile
    </title>
    <style>
        body { 
            font-family: system-ui, -apple-system, sans-serif; 
            background: #0f172a; 
            color: #f8fafc; 
            padding: 2rem; 
        }
        .card { 
            background: #1e293b; 
            border: 1px solid #334155; 
            padding: 2rem; 
            border-radius: 12px; 
            max-width: 600px; 
            margin: 2rem auto; 
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3);
        }
        h1 { 
            color: #38bdf8; 
            margin-bottom: 0.5rem; 
        }
        .title { 
            color: #94a3b8; 
            font-size: 1.1rem; 
            margin-bottom: 1.5rem; 
        }
        .detail { 
            margin-bottom: 1.25rem; 
        }
        .label { 
            font-weight: bold; 
            color: #38bdf8; 
            display: block; 
            font-size: 0.85rem; 
            text-transform: uppercase; 
            letter-spacing: 0.05em;
            margin-bottom: 0.25rem;
        }
        p {
            color: #e2e8f0;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>
            <c:out value="${not empty requestScope.publicProfile.fullname ? requestScope.publicProfile.fullname : requestScope.publicUser.username}" />
        </h1>
        
        <p class="title">
            <c:out value="${not empty requestScope.publicProfile.jobTitle ? requestScope.publicProfile.jobTitle : 'No title specified'}" />
            &bull;
            <c:out value="${not empty requestScope.publicProfile.location ? requestScope.publicProfile.location : 'Unspecified'}" />
        </p>
        
        <div class="detail">
            <span class="label">Username</span>
            <p>@<c:out value="${requestScope.publicUser.username}" /></p>
        </div>

        <div class="detail">
            <span class="label">About</span>
            <p>
                <c:out value="${not empty requestScope.publicProfile.professionalSummary ? requestScope.publicProfile.professionalSummary : 'No summary provided.'}" />
            </p>
        </div>
    </div>
</body>
</html>