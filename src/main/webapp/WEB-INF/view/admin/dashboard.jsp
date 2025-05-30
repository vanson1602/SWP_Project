<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

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
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
          :root {
            --sidebar-width: 250px;
          }

          .sidebar {
            width: var(--sidebar-width);
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            background: #2c3e50;
            padding: 20px;
            color: white;
            transition: all 0.3s;
          }

          .sidebar-header {
            padding: 20px 0;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
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
            padding: 10px;
            border-radius: 5px;
            transition: all 0.3s;
          }

          .sidebar-menu a:hover {
            background: rgba(255, 255, 255, 0.1);
          }

          .sidebar-menu a.active {
            background: #3498db;
          }

          .main-content {
            margin-left: var(--sidebar-width);
            padding: 20px;
          }

          .stat-card {
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
          }

          .stat-card i {
            font-size: 2rem;
            margin-bottom: 10px;
          }

          .chart-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            height: 400px;
            /* Fixed height for chart container */
            position: relative;
            /* Required for chart positioning */
          }

          .chart-container h4 {
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
          }

          .chart-wrapper {
            position: relative;
            height: calc(100% - 60px);
            /* Subtract header height */
            width: 100%;
          }

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
            <li><a href="#" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="/admin/user"><i class="fas fa-users"></i> Users</a></li>
            <li><a href="#"><i class="fas fa-calendar-check"></i> Appointment</a></li>

            <li><a href="#"><i class="fas fa-user-md"></i> Doctor Schedule</a></li>
            <li><a href="/"><i class="fas fa-sign-out-alt"></i> Home Page</a></li>
          </ul>
        </nav>

        <!-- Main Content -->
        <div class="main-content">
          <!-- Header -->
          <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Dashboard</h2>
            <div class="d-flex align-items-center">
              <div class="dropdown">
                <button class="btn btn-light dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown">
                  <i class="fas fa-user-circle"></i> Admin
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                  <li><a class="dropdown-item" href="#"><i class="fas fa-user"></i> Profile</a></li>
                  <li><a class="dropdown-item" href="#"><i class="fas fa-cog"></i> Settings</a></li>
                  <li>
                    <hr class="dropdown-divider">
                  </li>
                  <li><a class="dropdown-item" href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
              </div>
            </div>
          </div>

          <!-- Statistics Cards -->
          <div class="row">
            <div class="col-md-4">
              <div class="stat-card bg-primary text-white">
                <i class="fas fa-users"></i>
                <h3>1,234</h3>
                <p>Total Patients</p>
              </div>
            </div>
            <div class="col-md-4">
              <div class="stat-card bg-success text-white">
                <i class="fas fa-calendar-check"></i>
                <h3>567</h3>
                <p>Today's Appointments</p>
              </div>
            </div>
            <div class="col-md-4">
              <div class="stat-card bg-warning text-white">
                <i class="fas fa-dollar-sign"></i>
                <h3>$12,345</h3>
                <p>Total Revenue</p>
              </div>
            </div>
          </div>

          <!-- Charts -->
          <div class="row mt-4">
            <div class="col-md-8">
              <div class="chart-container">
                <h4>Appointment Overview</h4>
                <div class="chart-wrapper">
                  <canvas id="salesChart"></canvas>
                </div>
              </div>
            </div>
            <div class="col-md-4">
              <div class="chart-container">
                <h4>Appointment Status</h4>
                <div class="chart-wrapper">
                  <canvas id="revenueChart"></canvas>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Orders Table -->
          <div class="card mt-4">
            <div class="card-header">
              <h5 class="card-title mb-0">Recent Orders</h5>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-hover">
                  <thead>
                    <tr>
                      <th>Order ID</th>
                      <th>Customer</th>
                      <th>Product</th>
                      <th>Amount</th>
                      <th>Status</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>#12345</td>
                      <td>John Doe</td>
                      <td>Product A</td>
                      <td>$100</td>
                      <td><span class="badge bg-success">Completed</span></td>
                      <td>
                        <button class="btn btn-sm btn-primary">View</button>
                      </td>
                    </tr>
                    <tr>
                      <td>#12346</td>
                      <td>Jane Smith</td>
                      <td>Product B</td>
                      <td>$150</td>
                      <td><span class="badge bg-warning">Pending</span></td>
                      <td>
                        <button class="btn btn-sm btn-primary">View</button>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script>
          // Sales Chart
          const salesCtx = document.getElementById('salesChart').getContext('2d');
          new Chart(salesCtx, {
            type: 'line',
            data: {
              labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
              datasets: [{
                label: 'Appointments',
                data: [12, 19, 3, 5, 2, 3],
                borderColor: '#3498db',
                backgroundColor: 'rgba(52, 152, 219, 0.1)',
                borderWidth: 2,
                fill: true,
                tension: 0.4
              }]
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              plugins: {
                legend: {
                  position: 'top',
                },
                tooltip: {
                  mode: 'index',
                  intersect: false,
                }
              },
              scales: {
                y: {
                  beginAtZero: true,
                  grid: {
                    drawBorder: false
                  }
                },
                x: {
                  grid: {
                    display: false
                  }
                }
              }
            }
          });

          // Revenue Chart
          const revenueCtx = document.getElementById('revenueChart').getContext('2d');
          new Chart(revenueCtx, {
            type: 'doughnut',
            data: {
              labels: ['Completed', 'Pending', 'Cancelled'],
              datasets: [{
                data: [60, 30, 10],
                backgroundColor: ['#2ecc71', '#f1c40f', '#e74c3c'],
                borderWidth: 0,
                hoverOffset: 4
              }]
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              plugins: {
                legend: {
                  position: 'bottom',
                  labels: {
                    padding: 20,
                    usePointStyle: true
                  }
                }
              },
              cutout: '70%'
            }
          });

          // Toggle Sidebar on mobile
          $(document).ready(function () {
            $('.sidebar-toggle').click(function () {
              $('.sidebar').toggleClass('active');
            });
          });
        </script>
      </body>

      </html>