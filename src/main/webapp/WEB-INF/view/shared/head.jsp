<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Required meta tags -->
        <meta name="_csrf" content="${_csrf.token}" />
        <meta name="_csrf_header" content="${_csrf.headerName}" />

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="/resources/css/style.css">

        <!-- Bootstrap JavaScript -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Moment.js for date formatting -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/vi.js"></script>

        <style>
            /* Layout fixes for patient pages */
            body {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                font-family: "Segoe UI", sans-serif;
                background-color: #f1f4f9;
                margin: 0;
                padding: 0;
            }

            .container {
                flex: 1;
                padding: 20px;
            }

            /* Patient history specific styles */
            h2 {
                text-align: center;
                color: #34495e;
                margin-bottom: 30px;
            }

            .card-container {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                justify-content: center;
            }

            .card {
                background-color: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                padding: 20px;
                width: 320px;
                transition: transform 0.2s ease;
            }

            .card:hover {
                transform: translateY(-5px);
            }

            .card h3 {
                margin: 0 0 10px;
                color: #2980b9;
                font-size: 18px;
            }

            .card p {
                margin: 6px 0;
                color: #555;
            }

            .label {
                font-weight: bold;
                color: #2c3e50;
            }

            .no-data {
                text-align: center;
                color: #888;
                font-style: italic;
                margin-top: 40px;
            }

            .back-button {
                display: inline-block;
                margin-top: 24px;
                padding: 10px 20px;
                background-color: #3b82f6;
                color: white;
                border-radius: 8px;
                text-decoration: none;
                transition: background-color 0.3s ease;
            }

            .back-button:hover {
                background-color: #2563eb;
                color: white;
                text-decoration: none;
            }

            @media (max-width: 600px) {
                .card {
                    width: 90%;
                }
            }

            /* Medical record specific styles */
            .section-title {
                font-size: 20px;
                font-weight: 600;
                color: #0ea5e9;
                margin-top: 24px;
                margin-bottom: 12px;
                border-bottom: 2px solid #bae6fd;
                padding-bottom: 6px;
                letter-spacing: 0.5px;
            }

            .info {
                font-size: 16px;
                color: #374151;
                margin: 10px 0;
                line-height: 1.6;
                padding-left: 8px;
                border-left: 3px solid #93c5fd;
                background-color: #f8fafc;
                padding: 10px 12px;
                border-radius: 6px;
            }

            .info span {
                font-weight: 600;
                color: #111827;
            }

            .error-message {
                color: red;
                margin-top: 10px;
            }

            /* Footer styles */
            footer {
                margin-top: auto;
            }
        </style>