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
            --glass-bg: rgba(255, 255, 255, 0.65);
            --glass-bg-hover: rgba(255, 255, 255, 0.82);
            --glass-border: rgba(255, 255, 255, 0.7);
            --glass-header: rgba(255, 255, 255, 0.75);
            
            --text-dark: #0f172a;
            --text-muted: #475569;
            --accent-color: #2563eb;
            --accent-gradient: linear-gradient(135deg, #1d4ed8 0%, #6d28d9 100%);
            --accent-light: rgba(37, 99, 235, 0.12);
            
            --glass-shadow: 0 10px 32px 0 rgba(0, 0, 0, 0.12);
            --glass-blur: blur(18px);
            
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
            background: linear-gradient(rgba(15, 23, 42, 0.25), rgba(15, 23, 42, 0.25)), url('${pageContext.request.contextPath}/background.jpg') no-repeat center center fixed;
            background-size: cover;
            color: var(--text-dark);
            line-height: 1.6;
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
        }

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

        nav ul {
            display: flex;
            list-style: none;
            gap: 1.5rem;
            align-items: center;
        }

        nav a, nav button {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.2s ease;
            background: none;
            border: none;
            cursor: pointer;
        }

        nav a:hover, nav button:hover {
            color: var(--accent-color);
        }

        nav .btn-print {
            background: #0f172a;
            color: #ffffff;
            padding: 0.55rem 1.25rem;
            border-radius: var(--radius-pill);
            font-weight: 700;
            box-shadow: 0 4px 15px rgba(15, 23, 42, 0.2);
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        nav .btn-print:hover {
            color: #ffffff;
            opacity: 0.9;
            transform: translateY(-1px);
        }

        nav a.btn-back {
            background: var(--accent-gradient);
            color: #ffffff;
            padding: 0.55rem 1.25rem;
            border-radius: var(--radius-pill);
            font-weight: 700;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
        }

        nav a.btn-back:hover {
            opacity: 0.95;
            transform: translateY(-1px);
        }

        main {
            max-width: 1280px;
            margin: 0 auto;
            padding: 2.5rem 2rem;
        }

        .hero {
            display: flex;
            align-items: center;
            gap: 2.5rem;
            padding: 2.5rem;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            box-shadow: var(--glass-shadow);
            margin-bottom: 2.5rem;
        }

        .avatar {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #ffffff;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            flex-shrink: 0;
        }

        .hero-text h1 {
            font-size: 2.5rem;
            font-weight: 800;
            line-height: 1.15;
            letter-spacing: -0.5px;
            color: var(--text-dark);
        }

        .hero-text .title {
            font-size: 1.15rem;
            font-weight: 700;
            background: var(--accent-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.75rem;
        }

        .hero-text p {
            color: var(--text-muted);
            font-size: 1rem;
            max-width: 720px;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2.5rem;
        }

        @media (max-width: 992px) {
            .dashboard-grid { grid-template-columns: 1fr; }
            .hero { flex-direction: column; text-align: center; }
        }

        .main-content, .sidebar {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 2rem;
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            box-shadow: var(--glass-shadow);
        }

        .card h2 {
            font-size: 1.25rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
            color: var(--text-dark);
            letter-spacing: -0.3px;
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
            color: var(--text-dark);
        }

        .item-box .subtitle {
            color: var(--accent-color);
            font-size: 0.9rem;
            font-weight: 600;
        }

        .item-box .meta {
            color: var(--text-muted);
            font-size: 0.85rem;
            margin-bottom: 0.5rem;
        }

        .skills-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
        }

        .skill-badge {
            background: rgba(255, 255, 255, 0.85);
            border: 1px solid var(--glass-border);
            padding: 0.5rem 1rem;
            border-radius: var(--radius-pill);
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-dark);
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .skill-level {
            font-size: 0.75rem;
            color: var(--accent-color);
            font-weight: 700;
        }

        .contact-info p {
            margin-bottom: 0.75rem;
            font-size: 0.95rem;
            color: var(--text-muted);
        }

        .contact-info strong {
            color: var(--text-dark);
        }

        .not-provided {
            color: var(--text-muted);
            font-style: italic;
        }

        footer {
            text-align: center;
            padding: 2.5rem;
            color: rgba(255, 255, 255, 0.85);
            font-size: 0.875rem;
        }

        /* PRINT STYLESHEET (Formats layout to match PDF output) */
        @media print {
            @page {
                size: A4;
                margin: 0;
            }

            body {
                background: #ffffff !important;
                color: #1a1a1a !important;
                font-family: Arial, sans-serif !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

            header, footer, .avatar, .btn-back, .btn-print {
                display: none !important;
            }

            main {
                max-width: 100% !important;
                padding: 0 !important;
                margin: 0 !important;
            }

            /* Dark Header Banner */
            .hero {
                background: #0e1e38 !important;
                color: #ffffff !important;
                border: none !important;
                border-radius: 0 !important;
                padding: 40px 50px !important;
                margin-bottom: 0 !important;
                display: flex !important;
                justify-content: space-between !important;
                align-items: flex-start !important;
                box-shadow: none !important;
            }

            .hero-text h1 {
                color: #ffffff !important;
                font-size: 32px !important;
                font-weight: bold !important;
                margin-bottom: 5px !important;
            }

            .hero-text .title {
                color: #38bdf8 !important;
                font-size: 18px !important;
                background: none !important;
                -webkit-text-fill-color: #38bdf8 !important;
            }

            .hero-text p:not(.title) {
                display: none !important; /* Move summary to main grid body */
            }

            /* Contact section inside Dark Header */
            .sidebar .contact-info {
                background: transparent !important;
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
                color: #ffffff !important;
                text-align: right !important;
                font-size: 13px !important;
            }

            .sidebar .contact-info h2 {
                display: none !important;
            }

            .sidebar .contact-info p {
                color: #e2e8f0 !important;
                margin-bottom: 4px !important;
            }

            .sidebar .contact-info strong {
                color: #ffffff !important;
            }

            /* 2-Column Layout */
            .dashboard-grid {
                display: flex !important;
                flex-direction: row-reverse !important; /* Left: Sidebar info, Right: Main body */
                padding: 40px 50px !important;
                gap: 40px !important;
            }

            .sidebar {
                width: 30% !important;
                border-right: 1px solid #e2e8f0 !important;
                padding-right: 20px !important;
            }

            .main-content {
                width: 70% !important;
            }

            .card {
                background: transparent !important;
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
                backdrop-filter: none !important;
                margin-bottom: 30px !important;
            }

            .card h2 {
                font-size: 16px !important;
                text-transform: uppercase !important;
                letter-spacing: 1px !important;
                color: #0f172a !important;
                border-bottom: 2px solid #0284c7 !important;
                padding-bottom: 5px !important;
                margin-bottom: 15px !important;
            }

            .skills-grid {
                display: block !important;
            }

            .skill-badge {
                display: block !important;
                background: transparent !important;
                border: none !important;
                padding: 2px 0 !important;
                box-shadow: none !important;
                font-size: 13px !important;
            }

            /* Dynamically add Professional Summary section on print */
            .main-content::before {
                content: "PROFESSIONAL SUMMARY";
                display: block;
                font-size: 16px;
                font-weight: bold;
                text-transform: uppercase;
                letter-spacing: 1px;
                color: #0f172a;
                border-bottom: 2px solid #0284c7;
                padding-bottom: 5px;
                margin-bottom: 15px;
            }
        }
    </style>
</head>
<body>

    <header>
        <nav>
            <a href="${pageContext.request.contextPath}/DisplayConnections.jsp" class="logo">DevProfile</a>
            <ul>
                <li><a href="#experience">Experience</a></li>
                <li><a href="#education">Education</a></li>
                <li><a href="#skills">Skills</a></li>
                <li><a href="#certifications">Certifications</a></li>
                <li>
                    <button onclick="window.print()" class="btn-print">🖨️ Print CV</button>
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
                    <h2>💼 Work Experience</h2>
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
                    <h2>🎓 Education</h2>
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
                    <h2>💬 References</h2>
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
                                        <blockquote style="font-style: italic; color: var(--text-muted); margin-top: 0.5rem;">
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
                    <h2>⚡ Skills</h2>
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
                    <h2>📜 Certifications</h2>
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
                                        <a href="<c:out value='${cert.credentialUrl}' />" target="_blank" style="color: var(--accent-color); font-size: 0.85rem; font-weight: 600; text-decoration: none;">View Credential ↗</a>
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
                    <h2>📬 Contact Information</h2>
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
