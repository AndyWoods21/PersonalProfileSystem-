<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - DevProfile Hub</title>
    <style>
        :root {
            --bg-color: #0f172a;
            --card-bg: rgba(30, 41, 59, 0.7);
            --border-color: rgba(255, 255, 255, 0.1);
            --accent-gradient: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            --accent-hover: linear-gradient(135deg, #4f46e5 0%, #9333ea 100%);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --error-red: #ef4444;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }

        body {
            background-color: var(--bg-color);
            background-image: 
                radial-gradient(at 0% 0%, rgba(99, 102, 241, 0.15) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(168, 85, 247, 0.15) 0px, transparent 50%);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        .error-card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--border-color);
            border-radius: 1rem;
            padding: 2.5rem;
            max-width: 520px;
            width: 100%;
            text-align: center;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 8px 10px -6px rgba(0, 0, 0, 0.3);
        }

        .error-icon {
            width: 64px;
            height: 64px;
            background: rgba(239, 68, 68, 0.1);
            color: var(--error-red);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem auto;
            font-size: 2rem;
            font-weight: bold;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        h1 {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
            letter-spacing: -0.025em;
        }

        .error-message {
            color: var(--text-muted);
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 2rem;
        }

        .actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
            font-size: 0.95rem;
            cursor: pointer;
        }

        .btn-primary {
            background: var(--accent-gradient);
            color: #ffffff;
            border: none;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.25);
        }

        .btn-primary:hover {
            background: var(--accent-hover);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-main);
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-1px);
        }
    </style>
</head>
<body>

    <div class="error-card">
        <div class="error-icon">!</div>
        
        <h1>Something Went Wrong</h1>
        
        <p class="error-message">
            <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null && !errorMessage.trim().isEmpty()) {
                    out.print(errorMessage);
                } else if (exception != null && exception.getMessage() != null) {
                    out.print(exception.getMessage());
                } else {
                    out.print("An unexpected error occurred while processing your request.");
                }
            %>
        </p>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/Dashboard.jsp" class="btn btn-primary">Go to Dashboard</a>
            <a href="javascript:history.back()" class="btn btn-secondary">Go Back</a>
        </div>
    </div>

</body>
</html>