<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Security Gatekeeper --%>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login.jsp?error=unauthorized" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${not empty personalInfo and not empty personalInfo.fullname}">
                <c:out value="${personalInfo.fullname}" />
            </c:when>
            <c:when test="${not empty profileUser and not empty profileUser.username}">
                <c:out value="${profileUser.username}" />
            </c:when>
            <c:otherwise>
                Developer
            </c:otherwise>
        </c:choose> — Profile
    </title>

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
            
            /* Light Grey Buttons */
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

        nav {
            max-width: 1280px;
            margin: 0 auto;
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
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

        nav ul {
            display: flex;
            list-style: none;
            gap: 1rem;
            align-items: center;
        }

        nav a, nav button {
            color: var(--text-body);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.2s ease;
            background: none;
            border: none;
            cursor: pointer;
        }

        nav a:hover, nav button:hover {
            color: var(--text-heading);
        }

        /* Light Grey Action Buttons */
        .btn-print, nav .btn-print {
            background-color: var(--btn-dark) !important;
            color: var(--btn-dark-text) !important;
            padding: 0.5rem 1.1rem;
            border-radius: var(--radius-pill);
            font-size: 0.85rem;
            font-weight: 700;
            box-shadow: 0 4px 12px rgba(255, 255, 255, 0.1);
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .btn-print:hover, nav .btn-print:hover {
            background-color: var(--btn-hover) !important;
            color: #000000 !important;
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(255, 255, 255, 0.25);
        }

        nav a.btn-back {
            background-color: var(--btn-dark);
            color: var(--btn-dark-text);
            padding: 0.5rem 1.1rem;
            border-radius: var(--radius-pill);
            font-weight: 700;
            box-shadow: 0 4px 12px rgba(255, 255, 255, 0.1);
        }

        nav a.btn-back:hover {
            background-color: var(--btn-hover);
            color: #000000;
            transform: translateY(-2px);
        }

        main {
            max-width: 1280px;
            margin: 0 auto;
            padding: 2.5rem 2rem;
            width: 100%;
            flex: 1;
        }

        /* Hero / Welcome Banner Module */
        .hero {
            position: relative;
            background-color: var(--card-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 2.25rem 2.5rem;
            margin-bottom: 2.5rem;
            display: flex;
            align-items: center;
            gap: 2.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
        }

        .avatar {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--glass-border);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            flex-shrink: 0;
        }

        .hero-text h1 {
            font-size: 2.2rem;
            font-weight: 800;
            line-height: 1.15;
            letter-spacing: -0.5px;
            color: var(--text-heading);
            margin-bottom: 0.35rem;
        }

        .hero-text .title {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--text-heading);
            margin-bottom: 0.75rem;
        }

        .hero-text p:not(.title) {
            color: var(--text-body);
            font-size: 0.95rem;
            max-width: 720px;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2.5rem;
        }

        @media (max-width: 992px) {
            .dashboard-grid { 
                grid-template-columns: 1fr; 
            }
            .hero { 
                flex-direction: column; 
                text-align: center; 
            }
        }

        .main-content, .sidebar {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        /* Card Panels */
        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 2rem;
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease;
        }

        .card:hover {
            transform: translateY(-3px);
            background-color: rgba(65, 65, 65, 0.45);
            border-color: rgba(255, 255, 255, 0.25);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.4);
        }

        .card h2 {
            font-size: 1.15rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: var(--text-heading);
            letter-spacing: -0.3px;
            padding-bottom: 0.6rem;
            border-bottom: 1px solid var(--glass-border);
        }

        .item-box {
            margin-bottom: 1.5rem;
            padding-bottom: 1.25rem;
            border-bottom: 1px solid var(--glass-border);
        }

        .item-box:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }

        .item-box h3 {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--text-heading);
        }

        .item-box .subtitle {
            color: var(--text-body);
            font-size: 0.9rem;
            font-weight: 600;
        }

        .item-box .meta {
            color: #aaaaaa;
            font-size: 0.85rem;
            margin-bottom: 0.5rem;
        }

        .item-box p {
            color: var(--text-body);
            font-size: 0.95rem;
        }

        .skills-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
        }

        .skill-badge {
            background-color: var(--badge-bg);
            border: 1px solid var(--glass-border);
            padding: 0.5rem 1rem;
            border-radius: var(--radius-pill);
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-heading);
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .skill-level {
            font-size: 0.75rem;
            color: var(--text-body);
            font-weight: 700;
        }

        .contact-info p {
            margin-bottom: 0.75rem;
            font-size: 0.95rem;
            color: var(--text-body);
        }

        .contact-info strong {
            color: var(--text-heading);
        }

        .not-provided {
            color: #888888;
            font-style: italic;
        }

        footer {
            text-align: center;
            padding: 2.5rem;
            color: #aaaaaa;
            font-size: 0.875rem;
            background: rgba(30, 30, 30, 0.8);
            border-top: 1px solid var(--glass-border);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
        }

        /* PRINT STYLESHEET */
    @media print {
    @page {
        size: A4;
        margin: 15mm;
    }

    body {
        background: #ffffff !important;
        color: #000000 !important;
        font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif !important;
        font-size: 11pt !important;
        line-height: 1.5 !important;
        -webkit-print-color-adjust: exact !important;
        print-color-adjust: exact !important;
        margin: 0 !important;
        padding: 0 !important;
    }

    /* Hide navigation, headers, footers, buttons, profile images, and avatars */
    header, footer, nav, .sidebar, .sidebar-nav, .btn-logout, .btn-submit, .logo, .avatar, .profile-picture, img, .empty-text {
        display: none !important;
    }

    /* Preserve original layout flow without forcing a grid */
    .app-container, main {
        display: block !important;
        width: 100% !important;
        max-width: 100% !important;
        margin: 0 !important;
        padding: 0 !important;
        background: #ffffff !important;
        border: none !important;
        box-shadow: none !important;
    }

    /* Strip all grey backgrounds, shadows, and rounded container boxes */
    .card, .profile-header, .hero-section {
        background: #ffffff !important;
        color: #000000 !important;
        border: none !important;
        box-shadow: none !important;
        padding: 0 !important;
        margin-bottom: 20px !important;
        backdrop-filter: none !important;
        display: block !important;
    }

    /* Force all text elements to pure black */
    h1, h2, h3, h4, h5, h6, p, span, li, a, div {
        color: #000000 !important;
        background: transparent !important;
    }

    /* Section Headings with clean black borders */
    .card h2 {
        font-size: 13pt !important;
        font-weight: 800 !important;
        text-transform: uppercase !important;
        letter-spacing: 0.8px !important;
        color: #000000 !important;
        border-bottom: 2px solid #000000 !important;
        padding-bottom: 4px !important;
        margin-bottom: 12px !important;
    }

    .item-list {
        display: block !important;
    }

    .item-card {
        background: transparent !important;
        border: none !important;
        padding: 0 !important;
        margin-bottom: 10px !important;
        box-shadow: none !important;
        display: flex !important;
        justify-content: space-between !important;
        align-items: baseline !important;
    }

    .item-card h3 {
        font-size: 11.5pt !important;
        font-weight: 700 !important;
        color: #000000 !important;
        margin: 0 !important;
    }

    .item-card p, 
    .item-card span {
        font-size: 10.5pt !important;
        font-weight: 500 !important;
        color: #000000 !important;
        margin: 0 !important;
    }
}
/*}*/
</style>
</head>
<body>

    <canvas id="techCanvas"></canvas>

    <header>
        <nav>
            <a href="${pageContext.request.contextPath}/DisplayConnections.jsp" class="logo">DevProfile</a>
            <ul>
                <li><a href="#experience">Experience</a></li>
                <li><a href="#education">Education</a></li>
                <li><a href="#skills">Skills</a></li>
                <li><a href="#certifications">Certifications</a></li>
                <li>
                    <button onclick="window.print()" class="btn-print">Print CV</button>
                </li>
                <li><a href="${pageContext.request.contextPath}/DisplayConnections.jsp" class="btn-back">← Back to Connections</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <section class="hero">
            <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80" alt="Avatar" class="avatar">
            <div class="hero-text">
                <h1>
                    <c:choose>
                        <c:when test="${not empty personalInfo and not empty personalInfo.fullname}">
                            <c:out value="${personalInfo.fullname}" />
                        </c:when>
                        <c:when test="${not empty profileUser and not empty profileUser.username}">
                            <c:out value="${profileUser.username}" />
                        </c:when>
                        <c:otherwise>
                            <span class="not-provided">Information not provided</span>
                        </c:otherwise>
                    </c:choose>
                </h1>
                
                <p class="title">
                    <c:choose>
                        <c:when test="${not empty personalInfo and not empty personalInfo.jobTitle}">
                            <c:out value="${personalInfo.jobTitle}" />
                        </c:when>
                        <c:otherwise>
                            Software Developer
                        </c:otherwise>
                    </c:choose>
                </p>
                
                <p class="summary-text">
                    <c:choose>
                        <c:when test="${not empty personalInfo and not empty personalInfo.professionalSummary}">
                            <c:out value="${personalInfo.professionalSummary}" />
                        </c:when>
                        <c:otherwise>
                            <span class="not-provided">Information not provided</span>
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
        </section>

        <div class="dashboard-grid">
            
            <div class="main-content">

                <section id="experience" class="card">
                    <h2> Work Experience</h2>
                    <c:choose>
                        <c:when test="${not empty workList}">
                            <c:forEach var="work" items="${workList}">
                                <div class="item-box">
                                    <h3>
                                        <c:choose>
                                            <c:when test="${not empty work.jobTitle}">
                                                <c:out value="${work.jobTitle}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="not-provided">Title not provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </h3>
                                    
                                    <p class="subtitle">
                                        <c:choose>
                                            <c:when test="${not empty work.companyName}">
                                                <c:out value="${work.companyName}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="not-provided">Company not provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    
                                    <p class="meta">
                                        <c:out value="${not empty work.startDate ? work.startDate : 'N/A'}" /> — 
                                        <c:out value="${not empty work.endDate ? work.endDate : 'Present'}" />
                                    </p>
                                    
                                    <p>
                                        <c:choose>
                                            <c:when test="${not empty work.description}">
                                                <c:out value="${work.description}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="not-provided">Information not provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="not-provided">Information not provided</p>
                        </c:otherwise>
                    </c:choose>
                </section>

                <section id="education" class="card">
                    <h2> Education</h2>
                    <c:choose>
                        <c:when test="${not empty eduList}">
                            <c:forEach var="edu" items="${eduList}">
                                <div class="item-box">
                                    <h3>
                                        <c:out value="${not empty edu.degree ? edu.degree : 'Degree Unspecified'}" />
                                        <c:if test="${not empty edu.fieldOfStudy}"> in <c:out value="${edu.fieldOfStudy}" /></c:if>
                                    </h3>
                                    
                                    <p class="subtitle">
                                        <c:choose>
                                            <c:when test="${not empty edu.institutionName}">
                                                <c:out value="${edu.institutionName}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="not-provided">Institution not provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    
                                    <p class="meta">
                                        <c:out value="${not empty edu.startDate ? edu.startDate : 'N/A'}" /> — 
                                        <c:out value="${not empty edu.endDate ? edu.endDate : 'N/A'}" />
                                    </p>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="not-provided">Information not provided</p>
                        </c:otherwise>
                    </c:choose>
                </section>

                <section class="card">
                    <h2> References</h2>
                    <c:choose>
                        <c:when test="${not empty refList}">
                            <c:forEach var="ref" items="${refList}">
                                <div class="item-box">
                                    <h3>
                                        <c:choose>
                                            <c:when test="${not empty ref.name}">
                                                <c:out value="${ref.name}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="not-provided">Name not provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </h3>
                                    
                                    <p class="subtitle">
                                        <c:out value="${not empty ref.jobTitle ? ref.jobTitle : 'Title Unspecified'}" /> — 
                                        <c:out value="${not empty ref.company ? ref.company : 'Company Unspecified'}" />
                                    </p>
                                    
                                    <p class="meta">
                                        <c:choose>
                                            <c:when test="${not empty ref.email}">
                                                <c:out value="${ref.email}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="not-provided">Email not provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    
                                    <c:if test="${not empty ref.testimonial}">
                                        <blockquote style="font-style: italic; color: var(--text-body); margin-top: 0.5rem;">
                                            "<c:out value="${ref.testimonial}" />"
                                        </blockquote>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="not-provided">Information not provided</p>
                        </c:otherwise>
                    </c:choose>
                </section>

            </div>

            <div class="sidebar">

                <section id="skills" class="card">
                    <h2>Skills</h2>
                    <c:choose>
                        <c:when test="${not empty skillList}">
                            <div class="skills-grid">
                                <c:forEach var="skill" items="${skillList}">
                                    <div class="skill-badge">
                                        <c:out value="${not empty skill.skillName ? skill.skillName : 'Skill'}" />
                                        <c:if test="${not empty skill.proficiencyLevel}">
                                            <span class="skill-level">• <c:out value="${skill.proficiencyLevel}" /></span>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="not-provided">Information not provided</p>
                        </c:otherwise>
                    </c:choose>
                </section>

                <section id="certifications" class="card">
                    <h2> Certifications</h2>
                    <c:choose>
                        <c:when test="${not empty certList}">
                            <c:forEach var="cert" items="${certList}">
                                <div class="item-box">
                                    <h3>
                                        <c:choose>
                                            <c:when test="${not empty cert.title}">
                                                <c:out value="${cert.title}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="not-provided">Certification title not provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </h3>
                                    
                                    <p class="subtitle">
                                        <c:choose>
                                            <c:when test="${not empty cert.issuingOrganization}">
                                                <c:out value="${cert.issuingOrganization}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="not-provided">Organization not provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    
                                    <p class="meta">
                                        Issued: <c:out value="${not empty cert.issueDate ? cert.issueDate : 'Date not provided'}" />
                                    </p>
                                    
                                    <c:if test="${not empty cert.credentialUrl}">
                                        <a href="<c:out value='${cert.credentialUrl}' />" target="_blank" style="color: var(--text-heading); font-size: 0.85rem; font-weight: 600; text-decoration: underline;">View Credential ↗</a>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="not-provided">Information not provided</p>
                        </c:otherwise>
                    </c:choose>
                </section>

                <section class="card contact-info">
                    <h2>Contact Information</h2>
                    <p>
                        <strong>Location:</strong> 
                        <c:choose>
                            <c:when test="${not empty personalInfo and not empty personalInfo.location}">
                                <c:out value="${personalInfo.location}" />
                            </c:when>
                            <c:otherwise>
                                <span class="not-provided">Information not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p>
                        <strong>Email:</strong> 
                        <c:choose>
                            <c:when test="${not empty personalInfo and not empty personalInfo.email}">
                                <c:out value="${personalInfo.email}" />
                            </c:when>
                            <c:otherwise>
                                <span class="not-provided">Information not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p>
                        <strong>Phone:</strong> 
                        <c:choose>
                            <c:when test="${not empty personalInfo and not empty personalInfo.phone}">
                                <c:out value="${personalInfo.phone}" />
                            </c:when>
                            <c:otherwise>
                                <span class="not-provided">Information not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </section>

            </div>

        </div>
    </main>

    <footer>
        <p>&copy; 2026 DevProfile. All rights reserved.</p>
    </footer>

</body>
</html>