<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <style>
        :root {
            --sidebar-width: 250px;
            --primary-blue: #6366f1;
            --primary-pink: #ec4899;
            --primary-cyan: #06b6d4;
            --primary-green: #10b981;
            --success: #22c55e;
            --warning: #f59e0b;
            --danger: #ef4444;
            --info: #3b82f6;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        .sidebar {
            width: var(--sidebar-width);
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            background: linear-gradient(180deg, #1e293b 0%, #334155 100%);
            padding: 20px;
            color: white;
            transition: all 0.3s ease;
            box-shadow: 4px 0 15px rgba(0,0,0,0.1);
        }

        .sidebar-header {
            padding: 20px 0;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-header h3 {
            background: linear-gradient(45deg, #06b6d4, #3b82f6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 700;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin-top: 20px;
        }

        .sidebar-menu li {
            margin-bottom: 10px;
        }

        .sidebar-menu a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 12px 15px;
            border-radius: 12px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .sidebar-menu a:hover {
            background: linear-gradient(45deg, rgba(59, 130, 246, 0.2), rgba(6, 182, 212, 0.2));
            transform: translateX(5px);
        }

        .sidebar-menu a.active {
            background: linear-gradient(45deg, #3b82f6, #06b6d4);
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.4);
        }

        .main-content {
            margin-left: var(--sidebar-width);
            padding: 20px;
            min-height: 100vh;
        }

        .dashboard-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 20px 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .dashboard-header h2 {
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 700;
            margin: 0;
        }

        .filter-group {
            margin-top: 20px;
        }

        .filter-group .btn {
            border-radius: 25px;
            padding: 10px 25px;
            font-weight: 600;
            margin-right: 10px;
            border: none;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .filter-group .btn-primary {
            background: linear-gradient(45deg, var(--primary-blue), var(--primary-cyan));
            color: white;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
            transform: translateY(-2px);
        }

        .filter-group .btn-outline-primary {
            background: rgba(255, 255, 255, 0.8);
            color: var(--primary-blue);
            border: 2px solid var(--primary-blue);
        }

        .filter-group .btn-outline-primary:hover {
            background: linear-gradient(45deg, var(--primary-blue), var(--primary-cyan));
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
        }

        /* Animation for loading */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                margin-left: calc(-1 * var(--sidebar-width));
            }

            .sidebar.active {
                margin-left: 0;
            }

            .main-content {
                margin-left: 0;
            }

            .filter-group .btn {
                margin-bottom: 10px;
                width: 100%;
            }
        }
    </style>
</head>

<body>
    <!-- Sidebar -->
    <nav class="sidebar">
        <div class="sidebar-header">
            <h3>Admin Panel</h3>
        </div>
        <ul class="sidebar-menu">
            <li><a href="/admin" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="/admin/user"><i class="fas fa-users"></i> Users</a></li>
            <li><a href="/appointments"><i class="fas fa-calendar-check"></i> Appointment</a></li>
            <li><a href="#"><i class="fas fa-user-md"></i> Doctor Schedule</a></li>
            <li><a href="/"><i class="fas fa-sign-out-alt"></i> Home Page</a></li>
        </ul>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Dashboard</h2>
            <div class="dropdown">
                <button class="btn btn-light dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown">
                    <i class="fas fa-user-circle"></i> Admin
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="#"><i class="fas fa-user"></i> Profile</a></li>
                    <li><a class="dropdown-item" href="#"><i class="fas fa-cog"></i> Settings</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </div>
        </div>

        <!-- Dashboard Header -->
        <div class="dashboard-header">
            <h2>Thống Kê Y Tế</h2>
            <div class="filter-group">
                <div class="d-flex gap-2">
                    <a href="/admin/dashboard-day" class="btn btn-outline-primary">Theo Ngày</a>
                    <a href="/admin/dashboard-week" class="btn btn-outline-primary">Theo Tuần</a>
                    <a href="/admin/dashboard-month" class="btn btn-outline-primary">Theo Tháng</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</body>
</html>