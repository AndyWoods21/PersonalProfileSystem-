<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login.jsp?error=unauthorized" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Skills — DevProfile</title>
    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.25);
            --glass-card: rgba(255, 255, 255, 0.45);
            --glass-border: rgba(255, 255, 255, 0.5);
            --glass-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15);
            --text-main: #1e293b;
            --text-muted: #475569;
            --accent-color: #2563eb;
            --accent-hover: #1d4ed8;
            --danger-color: #dc2626;
            --danger-hover: #b91c1c;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: system-ui, -apple-system, sans-serif;
            background: url('${pageContext.request.contextPath}/background.jpg') no-repeat center center fixed;
            background-size: cover;
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        header {
            background: var(--glass-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--glass-border);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--glass-shadow);
        }

        .logo {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--accent-color);
            text-decoration: none;
        }

        .btn-logout {
            color: var(--danger-color);
            background: rgba(255, 255, 255, 0.5);
            border: 1px solid var(--danger-color);
            padding: 0.4rem 0.9rem;
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .btn-logout:hover {
            background: var(--danger-color);
            color: #ffffff;
        }

        .app-container {
            display: flex;
            flex: 1;
        }

        .sidebar {
            width: 260px;
            background: var(--glass-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-right: 1px solid var(--glass-border);
            padding: 1.5rem 1rem;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            flex-shrink: 0;
            box-shadow: var(--glass-shadow);
        }

        .sidebar-section-title {
            font-size: 0.75rem;
            text-transform: uppercase;
            color: var(--text-muted);
            padding: 0 0.75rem;
            margin-bottom: 0.5rem;
            font-weight: 700;
            letter-spacing: 0.05em;
        }

        .nav-menu {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
        }

        .nav-item a {
            display: flex;
            align-items: center;
            padding: 0.65rem 0.85rem;
            color: var(--text-main);
            text-decoration: none;
            font-size: 0.9rem;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .nav-item a:hover {
            background: rgba(255, 255, 255, 0.5);
            color: var(--accent-color);
        }

        .nav-item.active a {
            background: var(--accent-color);
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        main {
            flex: 1;
            padding: 2.5rem;
            max-width: 1000px;
        }

        .card {
            background: var(--glass-card);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 1.75rem;
            margin-bottom: 2rem;
            box-shadow: var(--glass-shadow);
        }

        .card h2 {
            font-size: 1.25rem;
            color: var(--text-main);
            margin-bottom: 1.25rem;
            font-weight: 700;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-bottom: 0.4rem;
            font-weight: 600;
        }

        .form-control {
            width: 100%;
            padding: 0.65rem 0.85rem;
            background: rgba(255, 255, 255, 0.6);
            border: 1px solid var(--glass-border);
            border-radius: 8px;
            color: var(--text-main);
            font-size: 0.9rem;
            outline: none;
            transition: all 0.2s ease;
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.9);
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 1rem;
        }

        .btn-submit {
            background-color: var(--accent-color);
            color: #ffffff;
            border: none;
            padding: 0.65rem 1.4rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
        }

        .btn-submit:hover {
            background-color: var(--accent-hover);
            transform: translateY(-1px);
        }

        .item-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1rem;
        }

        .item-card {
            background: rgba(255, 255, 255, 0.5);
            border: 1px solid var(--glass-border);
            padding: 1rem;
            border-radius: 12px;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .item-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
        }

        .item-card h3 {
            font-size: 1rem;
            color: var(--text-main);
            margin-bottom: 0.25rem;
        }

        .empty-text {
            color: var(--text-muted);
            font-style: italic;
        }
    </style>
</head>
<body>
    <header>
        <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="logo">DevProfile Management</a>
        <a href="${pageContext.request.contextPath}/LogoutServlet.do" class="btn-logout">Log Out</a>
    </header>

    <div class="app-container">
        <aside class="sidebar">
            <div>
                <p class="sidebar-section-title">Overview</p>
                <ul class="nav-menu">
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/Dashboard.jsp">📊 Dashboard</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/EditInfoServlet.do">👤 Personal Info</a></li>
                </ul>
            </div>
            <div>
                <p class="sidebar-section-title">Manage Sections</p>
                <ul class="nav-menu">
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/WorkExperienceServlet.do">💼 Work Experience</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/EducationServlet.do">🎓 Education</a></li>
                    <li class="nav-item active"><a href="${pageContext.request.contextPath}/SkillServlet.do">⚡ Skills</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/CertificationServlet.do">📜 Certifications</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ReferenceServlet.do">💬 References</a></li>
                </ul>
            </div>
        </aside>

        <main>
            <div class="card">
                <h2>Add Technical Skill</h2>
                <form action="${pageContext.request.contextPath}/SkillServlet.do" method="post">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Skill Name</label>
                            <input type="text" name="skillName" class="form-control" required placeholder="e.g. Java EE / SQL">
                        </div>
                        <div class="form-group">
                            <label>Category</label>
                            <input type="text" name="category" class="form-control" placeholder="e.g. Backend, Frontend, Embedded">
                        </div>
                        <div class="form-group">
                            <label>Proficiency Level</label>
                            <select name="proficiencyLevel" class="form-control">
                                <option value="Beginner">Beginner</option>
                                <option value="Intermediate">Intermediate</option>
                                <option value="Advanced">Advanced</option>
                                <option value="Expert">Expert</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn-submit">Add Skill</button>
                </form>
            </div>

            <div class="card">
                <h2>Your Skills</h2>
                <c:choose>
                    <c:when test="${not empty requestScope.skillList}">
                        <div class="item-list">
                            <c:forEach var="item" items="${requestScope.skillList}">
                                <div class="item-card">
                                    <h3><c:out value="${item.skillName}" /></h3>
                                    <p style="color: var(--accent-color); font-size: 0.85rem; font-weight: 600;"><c:out value="${item.category}" /></p>
                                    <p style="color: var(--text-muted); font-size: 0.8rem; margin-top: 0.25rem;">Level: <c:out value="${item.proficiencyLevel}" /></p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="empty-text">No skills added yet. Create skills above to showcase on your profile.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</body>
</html>