<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login.jsp?error=unauthorized" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Education — DevProfile</title>
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
        z-index: -1;
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

    /* Main Content Area */
    main {
        flex: 1;
        padding: 2.5rem;
        max-width: 1000px;
    }

    /* Card Panels */
    .card {
        background-color: var(--card-bg);
        border: 1px solid var(--glass-border);
        border-radius: var(--radius-md);
        padding: 1.75rem;
        margin-bottom: 2rem;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        transition: transform 0.25s cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 0.25s ease, border-color 0.25s ease;
    }

    .card:hover {
        background-color: rgba(65, 65, 65, 0.45);
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

    /* Form Elements */
    .form-group {
        margin-bottom: 1.15rem;
    }

    .form-group label {
        display: block;
        font-size: 0.72rem;
        color: var(--text-muted);
        text-transform: uppercase;
        letter-spacing: 0.8px;
        font-weight: 700;
        margin-bottom: 0.25rem;
    }

    .form-control {
        width: 100%;
        padding: 0.7rem 0.85rem;
        background: rgba(30, 30, 30, 0.6);
        border: 1px solid var(--glass-border);
        border-radius: var(--radius-md);
        color: var(--text-heading);
        font-size: 0.9rem;
        outline: none;
        transition: all 0.2s ease;
    }

    .form-control::placeholder {
        color: #777777;
    }

    .form-control:focus {
        background: rgba(40, 40, 40, 0.9);
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
        padding: 0.7rem 1.4rem;
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

    /* Existing Items List */
    .item-list {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .item-card {
        background: rgba(35, 35, 35, 0.4);
        border: 1px solid var(--glass-border);
        padding: 1.25rem;
        border-radius: var(--radius-md);
        backdrop-filter: blur(8px);
        -webkit-backdrop-filter: blur(8px);
        transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
    }

    .item-card:hover {
        transform: translateY(-2px);
        background: rgba(50, 50, 50, 0.5);
        border-color: rgba(255, 255, 255, 0.25);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
    }

    .item-card h3 {
        font-size: 1.05rem;
        color: var(--text-heading);
        margin-bottom: 0.25rem;
        font-weight: 700;
    }

    .empty-text {
        color: var(--text-muted);
        font-style: italic;
        font-size: 0.9rem;
    }

    /* Responsive Breakpoints */
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

    /* Footer Container */
    footer {
        text-align: center;
        padding: 1.75rem 1.5rem;
        border-top: 1px solid var(--glass-border);
        background: rgba(30, 30, 30, 0.8);
        color: var(--text-muted);
        font-size: 0.85rem;
        margin-top: auto;
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        position: relative;
        z-index: 10;
    }
</style>
</head>
<body>
    <canvas id="techCanvas"></canvas>

    <header>
        <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="logo">DevProfile Management</a>
        <div class="user-nav">
            <span class="badge">Education Manager</span>
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
                    <li class="nav-item active"><a href="${pageContext.request.contextPath}/EducationServlet.do">Education</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/SkillServlet.do">Skills</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/CertificationServlet.do">Certifications</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ReferenceServlet.do">References</a></li>
                </ul>
            </div>
        </aside>

        <main>
            <div class="card">
                <h2>Add Education Qualification</h2>
                <form action="${pageContext.request.contextPath}/EducationServlet.do" method="post">
                    <div class="form-group">
                        <label>Institution Name</label>
                        <input type="text" name="institutionName" class="form-control" required placeholder="e.g. Tshwane University of Technology">
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Degree / Qualification</label>
                            <input type="text" name="degree" class="form-control" required placeholder="e.g. Diploma">
                        </div>
                        <div class="form-group">
                            <label>Field of Study</label>
                            <input type="text" name="fieldOfStudy" class="form-control" required placeholder="e.g. Computer Science">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Start Date</label>
                            <input type="text" name="startDate" class="form-control" placeholder="e.g. 2023">
                        </div>
                        <div class="form-group">
                            <label>End Date</label>
                            <input type="text" name="endDate" class="form-control" placeholder="e.g. 2026">
                        </div>
                    </div>
                    <button type="submit" class="btn-submit">Add Qualification</button>
                </form>
            </div>

            <div class="card">
                <h2>Existing Education</h2>
                <c:choose>
                    <c:when test="${not empty requestScope.educationList}">
                        <div class="item-list">
                            <c:forEach var="item" items="${requestScope.educationList}">
                                <div class="item-card">
                                    <h3><c:out value="${item.degree}" /> in <c:out value="${item.fieldOfStudy}" /></h3>
                                    <p style="color: var(--text-heading); font-size: 0.9rem; font-weight: 600; margin-top: 0.25rem;"><c:out value="${item.institutionName}" /></p>
                                    <p style="color: var(--text-body); font-size: 0.85rem; margin-top: 0.25rem;"><c:out value="${item.startDate}" /> - <c:out value="${item.endDate}" /></p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="empty-text">No education entries found. Add your education details above.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <footer>
        <p>&copy; 2026 DevProfile Management. All rights reserved.</p>
    </footer>

    <script>
        const canvas = document.getElementById('techCanvas');
        const ctx = canvas.getContext('2d');

        function resizeCanvas() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        }
        resizeCanvas();

        const words = ['JAVA', 'JSP', 'SERVLETS', 'SQL', 'HTML5', 'CSS3', 'MVC', 'JDBC', 'TOMCAT', 'GIT'];
        const activeWords = [];
        const maxWordsOnScreen = 15;

        class PopUpWord {
            constructor() {
                this.reset();
            }

            reset() {
                this.text = words[Math.floor(Math.random() * words.length)];
                this.x = Math.random() * canvas.width;
                this.y = Math.random() * canvas.height;
                this.fontSize = Math.floor(Math.random() * 6) + 12;
                this.opacity = 0;
                this.maxOpacity = Math.random() * 0.15 + 0.05;
                this.fadeIn = true;
                this.holdTimer = 0;
                this.holdDuration = Math.floor(Math.random() * 120) + 60;
                this.fadeSpeed = 0.005;
                this.color = '220, 220, 220';
                this.state = 'fadeIn';
            }

            update() {
                if (this.state === 'fadeIn') {
                    this.opacity += this.fadeSpeed;
                    if (this.opacity >= this.maxOpacity) {
                        this.opacity = this.maxOpacity;
                        this.state = 'hold';
                        this.holdTimer = 0;
                    }
                } else if (this.state === 'hold') {
                    this.holdTimer++;
                    if (this.holdTimer >= this.holdDuration) {
                        this.state = 'fadeOut';
                    }
                } else if (this.state === 'fadeOut') {
                    this.opacity -= this.fadeSpeed;
                    if (this.opacity <= 0) {
                        this.reset();
                    }
                }
            }

            draw() {
                ctx.font = `600 ${this.fontSize}px 'Courier New', monospace`;
                ctx.fillStyle = `rgba(${this.color}, ${this.opacity})`;
                ctx.shadowColor = `rgba(${this.color}, ${this.opacity})`;
                ctx.shadowBlur = 8;
                ctx.fillText(this.text, this.x, this.y);
                ctx.shadowBlur = 0;
            }
        }

        for (let i = 0; i < maxWordsOnScreen; i++) {
            const word = new PopUpWord();
            word.holdTimer = Math.floor(Math.random() * 100); 
            activeWords.push(word);
        }

        function animate() {
            // Replaced fillRect with clearRect to prevent covering up the CSS body background image and gradient tint
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            activeWords.forEach(word => {
                word.update();
                word.draw();
            });

            requestAnimationFrame(animate);
        }

        window.addEventListener('resize', () => {
            resizeCanvas();
        });

        animate();
    </script>
</body>
</html>