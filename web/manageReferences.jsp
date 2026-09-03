<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Security Gatekeeper: Check if user is logged in --%>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login.jsp?error=unauthorized" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage References — DevProfile</title>
    <style>
        :root {
            /* Standard Neutral Dark Grey Color Palette */
            --bg-canvas-tint: rgba(30, 30, 30, 0.75);        /* Semi-transparent dark overlay */
            --bg-main: #1e1e1e;                             /* Standard dark grey background */
            --bg-light-gray: rgba(45, 45, 45, 0.45);        /* Main container: highly transparent dark grey */
            --card-bg: rgba(55, 55, 55, 0.35);                /* Cards/Divs: increased transparency */
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

        .user-nav {
            display: flex;
            align-items: center;
            gap: 0.85rem;
        }

        .badge {
            background-color: var(--badge-bg);
            color: var(--text-heading);
            border: 1px solid var(--glass-border);
            padding: 0.35rem 0.85rem;
            border-radius: var(--radius-pill);
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Light Grey Action Buttons */
        .btn-action-sm {
            background-color: var(--btn-dark);
            color: var(--btn-dark-text);
            padding: 0.5rem 1.1rem;
            border-radius: var(--radius-pill);
            font-size: 0.85rem;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s ease;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            box-shadow: 0 4px 12px rgba(255, 255, 255, 0.1);
        }

        .btn-action-sm:hover {
            background-color: var(--btn-hover);
            color: #000000;
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(255, 255, 255, 0.25);
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

        .not-provided {
            color: #888888;
            font-style: italic;
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
            color: #aaaaaa;
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
            padding: 2rem;
        }

        /* Card Panels */
        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 1.75rem;
            margin-bottom: 1.75rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            transition: transform 0.25s cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 0.25s ease, border-color 0.25s ease;
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

        /* Form Controls */
        .form-group {
            margin-bottom: 1.15rem;
        }

        .form-group label {
            display: block;
            font-size: 0.75rem;
            color: #aaaaaa;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 0.4rem;
            font-weight: 700;
        }

        .form-control {
            width: 100%;
            padding: 0.7rem 0.9rem;
            background: rgba(30, 30, 30, 0.6);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            color: var(--text-heading);
            font-size: 0.92rem;
            outline: none;
            transition: all 0.2s ease;
            font-family: inherit;
        }

        .form-control:focus {
            background: rgba(30, 30, 30, 0.9);
            border-color: var(--btn-dark);
            box-shadow: 0 0 0 3px rgba(224, 224, 224, 0.15);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .btn-submit {
            background-color: var(--btn-dark);
            color: var(--btn-dark-text);
            border: none;
            padding: 0.7rem 1.5rem;
            border-radius: var(--radius-pill);
            font-weight: 700;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(255, 255, 255, 0.1);
        }

        .btn-submit:hover {
            background-color: var(--btn-hover);
            color: #000000;
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(255, 255, 255, 0.25);
        }

        /* Item List & Cards */
        .item-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .item-card {
            background: rgba(30, 30, 30, 0.4);
            border: 1px solid var(--card-border);
            padding: 1.25rem;
            border-radius: var(--radius-md);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .item-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            border-color: rgba(255, 255, 255, 0.25);
        }

        .item-card h3 {
            font-size: 1.05rem;
            color: var(--text-heading);
            margin-bottom: 0.25rem;
            font-weight: 700;
        }

        .item-card blockquote {
            margin-top: 0.75rem;
            padding: 0.75rem 1rem;
            background: rgba(255, 255, 255, 0.05);
            border-left: 3px solid var(--btn-dark);
            border-radius: 0 8px 8px 0;
            font-style: italic;
            color: var(--text-body);
            font-size: 0.9rem;
        }

        .empty-text {
            color: var(--text-body);
            font-style: italic;
        }

        /* Footer Container */
        footer {
            text-align: center;
            padding: 1.75rem 1.5rem;
            border-top: 1px solid var(--glass-border);
            background: rgba(30, 30, 30, 0.8);
            color: #aaaaaa;
            font-size: 0.85rem;
            margin-top: auto;
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            position: relative;
            z-index: 10;
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

    <canvas id="techCanvas"></canvas>

    <header>
        <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="logo">⚡ DevProfile Management</a>
        <div class="user-nav">
            <span class="badge">Manage References</span>
            <a href="${pageContext.request.contextPath}/LogoutServlet.do" class="btn-logout">Log Out</a>
        </div>
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
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/SkillServlet.do">Skills</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/CertificationServlet.do">Certifications</a></li>
                    <li class="nav-item active"><a href="${pageContext.request.contextPath}/ReferenceServlet.do">References</a></li>
                </ul>
            </div>
        </aside>

        <main>
            <div class="card">
                <h2>Add Reference / Testimonial</h2>
                <form action="${pageContext.request.contextPath}/ReferenceServlet.do" method="post">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Referee Name</label>
                            <input type="text" name="name" class="form-control" required placeholder="e.g. Dr. Jane Smith">
                        </div>
                        <div class="form-group">
                            <label>Job Title</label>
                            <input type="text" name="jobTitle" class="form-control" placeholder="e.g. Senior Lecturer">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Company / Institution</label>
                            <input type="text" name="company" class="form-control" placeholder="e.g. TUT">
                        </div>
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" name="email" class="form-control" placeholder="referee@example.com">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Testimonial / Endorsement</label>
                        <textarea name="testimonial" class="form-control" rows="3" placeholder="Add optional reference text or quote..."></textarea>
                    </div>
                    <button type="submit" class="btn-submit">Add Reference</button>
                </form>
            </div>

            <div class="card">
                <h2>Existing References</h2>
                <c:choose>
                    <c:when test="${not empty requestScope.referenceList}">
                        <div class="item-list">
                            <c:forEach var="item" items="${requestScope.referenceList}">
                                <div class="item-card">
                                    <h3><c:out value="${item.name}" /></h3>
                                    <p style="color: var(--text-heading); font-size: 0.85rem; font-weight: 600; margin-top: 0.25rem;">
                                        <c:out value="${item.jobTitle}" /> — <c:out value="${item.company}" />
                                    </p>
                                    <p style="color: var(--text-body); font-size: 0.85rem; margin-top: 0.25rem;">
                                        <c:out value="${item.email}" />
                                    </p>
                                    <c:if test="${not empty item.testimonial}">
                                        <blockquote>"<c:out value="${item.testimonial}" />"</blockquote>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="empty-text">No references added yet.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <footer>
        <p>&copy; 2026 DevProfile Management. All rights reserved.</p>
    </footer>

    <script>
        // Tech background particle/nodes canvas animation
        const canvas = document.getElementById('techCanvas');
        const ctx = canvas.getContext('2d');

        function resizeCanvas() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        }
        resizeCanvas();
        window.addEventListener('resize', resizeCanvas);

        let particles = [];
        const particleCount = Math.floor(window.innerWidth / 35);

        class Particle {
            constructor() {
                this.reset();
            }
            reset() {
                this.x = Math.random() * canvas.width;
                this.y = Math.random() * canvas.height;
                this.vx = (Math.random() - 0.5) * 0.4;
                this.vy = (Math.random() - 0.5) * 0.4;
                this.radius = Math.random() * 1.5 + 0.5;
            }
            update() {
                this.x += this.vx;
                this.y += this.vy;
                if (this.x < 0 || this.x > canvas.width || this.y < 0 || this.y > canvas.height) {
                    this.reset();
                }
            }
            draw() {
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
                ctx.fillStyle = 'rgba(224, 224, 224, 0.25)';
                ctx.fill();
            }
        }

        for (let i = 0; i < particleCount; i++) {
            particles.push(new Particle());
        }

        function animate() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            particles.forEach(p => {
                p.update();
                p.draw();
            });
            requestAnimationFrame(animate);
        }
        animate();
    </script>
</body>
</html>