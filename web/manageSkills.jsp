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
        /* Standard Neutral Dark Grey Color Palette */
        --bg-canvas-tint: rgba(30, 30, 30, 0.75);        /* Semi-transparent dark overlay */
        --bg-main: #1e1e1e;                             /* Standard dark grey background */
        --bg-light-gray: rgba(45, 45, 45, 0.45);        /* Main container: highly transparent dark grey */
        --card-bg: rgba(55, 55, 55, 0.35);               /* Cards/Divs: increased transparency */
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
        flex-direction: column;
        position: relative;
        overflow-x: hidden;
        -webkit-font-smoothing: antialiased;
    }

    /* Sticky Navigation Header */
    header {
        background-color: rgba(30, 30, 30, 0.7);
        border-bottom: 1px solid var(--glass-border);
        padding: 0.85rem 2rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: sticky;
        top: 0;
        z-index: 1000;
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
    }

    .logo {
        font-size: 1.2rem;
        font-weight: 800;
        color: var(--text-heading);
        text-decoration: none;
        letter-spacing: -0.5px;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .btn-logout {
        background-color: transparent;
        color: var(--danger-color);
        border: 1px solid rgba(255, 82, 82, 0.4);
        padding: 0.45rem 0.95rem;
        border-radius: var(--radius-pill);
        font-size: 0.82rem;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s;
    }

    .btn-logout:hover {
        background-color: var(--danger-color);
        color: #ffffff;
        box-shadow: 0 4px 12px rgba(255, 82, 82, 0.3);
    }

    /* Main App Container Shell */
    .app-container {
        display: flex;
        flex: 1;
        max-width: 1280px;
        width: 100%;
        margin: 2rem auto;
        border-radius: var(--radius-lg);
        background: var(--bg-light-gray);
        border: 1px solid var(--glass-border);
        box-shadow: var(--shadow-soft);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        overflow: hidden;
        position: relative;
        z-index: 1;
    }

    /* Sidebar Styling */
    .sidebar {
        width: 250px;
        background-color: rgba(20, 20, 20, 0.35);
        border-right: 1px solid var(--glass-border);
        padding: 1.75rem 1rem;
        display: flex;
        flex-direction: column;
        gap: 1.75rem;
        flex-shrink: 0;
    }

    .sidebar-section-title {
        font-size: 0.7rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: var(--text-muted);
        padding: 0 0.75rem;
        margin-bottom: 0.5rem;
        font-weight: 700;
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
        gap: 0.75rem;
        padding: 0.7rem 0.85rem;
        color: var(--text-body);
        text-decoration: none;
        font-size: 0.9rem;
        font-weight: 500;
        border-radius: var(--radius-md);
        transition: all 0.2s ease;
    }

    .nav-item a:hover {
        background-color: rgba(255, 255, 255, 0.08);
        color: var(--text-heading);
    }

    .nav-item.active a {
        background-color: var(--btn-dark);
        color: var(--btn-dark-text);
        font-weight: 700;
    }

    /* Main Body Area */
    main {
        flex: 1;
        padding: 2.5rem;
    }

    /* Card Panels & Form Layout */
    .card {
        background-color: var(--card-bg);
        border: 1px solid var(--glass-border);
        border-radius: var(--radius-md);
        padding: 1.75rem;
        margin-bottom: 2rem;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease;
    }

    .card:hover {
        border-color: rgba(255, 255, 255, 0.25);
        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.4);
    }

    .card h2 {
        font-size: 1.1rem;
        font-weight: 700;
        color: var(--text-heading);
        margin-bottom: 1.25rem;
        padding-bottom: 0.6rem;
        border-bottom: 1px solid var(--glass-border);
    }

    .form-group {
        margin-bottom: 1rem;
    }

    .form-group label {
        display: block;
        font-size: 0.72rem;
        color: var(--text-muted);
        text-transform: uppercase;
        letter-spacing: 0.8px;
        margin-bottom: 0.4rem;
        font-weight: 700;
    }

    .form-control {
        width: 100%;
        padding: 0.65rem 0.85rem;
        background: rgba(30, 30, 30, 0.5);
        border: 1px solid var(--glass-border);
        border-radius: var(--radius-md);
        color: var(--text-heading);
        font-size: 0.9rem;
        outline: none;
        transition: all 0.2s ease;
    }

    .form-control:focus {
        background: rgba(30, 30, 30, 0.85);
        border-color: var(--btn-dark);
        box-shadow: 0 0 0 3px rgba(224, 224, 224, 0.15);
    }

    .form-control option {
        background-color: #2a2a2a;
        color: #f5f5f5;
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr 1fr;
        gap: 1rem;
    }

    .btn-submit {
        background-color: var(--btn-dark);
        color: var(--btn-dark-text);
        border: none;
        padding: 0.65rem 1.4rem;
        border-radius: var(--radius-pill);
        font-weight: 700;
        font-size: 0.9rem;
        cursor: pointer;
        transition: all 0.2s ease;
        box-shadow: 0 4px 12px rgba(255, 255, 255, 0.1);
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
    }

    .btn-submit:hover {
        background-color: var(--btn-hover);
        color: #000000;
        transform: translateY(-2px);
        box-shadow: 0 6px 18px rgba(255, 255, 255, 0.25);
    }

    /* Item List & Cards */
    .item-list {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        gap: 1rem;
    }

    .item-card {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid var(--glass-border);
        padding: 1.25rem;
        border-radius: var(--radius-md);
        backdrop-filter: blur(8px);
        -webkit-backdrop-filter: blur(8px);
        transition: transform 0.2s ease, box-shadow 0.2s ease, background-color 0.2s ease;
    }

    .item-card:hover {
        transform: translateY(-2px);
        background: rgba(255, 255, 255, 0.08);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
    }

    .item-card h3 {
        font-size: 1rem;
        color: var(--text-heading);
        margin-bottom: 0.25rem;
        font-weight: 700;
    }

    .empty-text {
        color: var(--text-muted);
        font-style: italic;
        font-size: 0.9rem;
    }

    /* Responsive Breaks */
    @media (max-width: 900px) {
        .app-container {
            flex-direction: column;
            margin: 0;
            border-radius: 0;
        }
        .sidebar {
            width: 100%;
            border-right: none;
            border-bottom: 1px solid var(--glass-border);
        }
        .form-row {
            grid-template-columns: 1fr;
        }
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
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/Dashboard.jsp">Dashboard</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/EditInfoServlet.do">Personal Info</a></li>
                </ul>
            </div>
            <div>
                <p class="sidebar-section-title">Manage Sections</p>
                <ul class="nav-menu">
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/WorkExperienceServlet.do">Work Experience</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/EducationServlet.do">Education</a></li>
                    <li class="nav-item active"><a href="${pageContext.request.contextPath}/SkillServlet.do">Skills</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/CertificationServlet.do">Certifications</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ReferenceServlet.do">References</a></li>
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