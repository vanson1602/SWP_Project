<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Thống Kê Theo Ngày</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .dashboard-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.06);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            color: #4a5568;
            border: 1px solid rgba(226, 232, 240, 0.5);
        }
        
        .dashboard-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        
        .chart-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.04);
            background: white;
            overflow: hidden;
            border: 1px solid rgba(226, 232, 240, 0.3);
        }
        
        .chart-card .card-header {
            background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
            color: #4a5568;
            border: none;
            padding: 20px;
            font-weight: 600;
            font-size: 1.1rem;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
        }
        
        .chart-container {
            position: relative;
            height: 400px;
            padding: 20px;
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin: 0;
        }
        
        .stats-label {
            font-size: 1rem;
            opacity: 0.9;
            margin: 0;
        }
        
        .revenue-card {
            background: linear-gradient(135deg, #fef7ff 0%, #f3e8ff 100%);
            border-left: 4px solid #c084fc;
        }
        
        .revenue-card .fas {
            color: #c084fc;
        }
        
        .appointment-card {
            background: linear-gradient(135deg, #fef2f2 0%, #fecaca 100%);
            border-left: 4px solid #f87171;
        }
        
        .appointment-card .fas {
            color: #f87171;
        }
        
        .patient-card {
            background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
            border-left: 4px solid #60a5fa;
        }
        
        .patient-card .fas {
            color: #60a5fa;
        }
        
        .page-title {
            color: #2d3748;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .status-legend {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 15px;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            background: #f8fafc;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
            border: 1px solid rgba(226, 232, 240, 0.6);
        }
        
        .legend-color {
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }
    </style>
</head>
<body style="background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%); min-height: 100vh;">
    <div class="container mt-4">
        <h2 class="page-title">
            <i class="fas fa-chart-line me-3"></i>
            Thống Kê Theo Ngày
        </h2>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                ${error}
            </div>
        </c:if>

        <!-- Thống kê tổng quan -->
        <div class="row mb-5">
            <div class="col-md-4 mb-4">
                <div class="card dashboard-card patient-card">
                    <div class="card-body text-center">
                        <i class="fas fa-users fa-2x mb-3"></i>
                        <h5 class="stats-label">Tổng số bệnh nhân</h5>
                        <p class="stats-number"><fmt:formatNumber value="${totalPatients}" type="number"/></p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card dashboard-card appointment-card">
                    <div class="card-body text-center">
                        <i class="fas fa-calendar-check fa-2x mb-3"></i>
                        <h5 class="stats-label">Tổng số cuộc hẹn</h5>
                        <p class="stats-number"><fmt:formatNumber value="${totalAppointments}" type="number"/></p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card dashboard-card revenue-card">
                    <div class="card-body text-center">
                        <i class="fas fa-money-bill-wave fa-2x mb-3"></i>
                        <h5 class="stats-label">Tổng doanh thu</h5>
                        <p class="stats-number">
                            <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="VNĐ"/>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Biểu đồ -->
        <div class="row">
            <div class="col-lg-8 mb-4">
                <div class="card chart-card">
                    <div class="card-header">
                        <i class="fas fa-chart-bar me-2"></i>
                        Thống Kê Doanh Thu & Lượt Khám (7 ngày gần nhất)
                    </div>
                    <div class="chart-container">
                        <canvas id="combinedChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 mb-4">
                <div class="card chart-card" style="height: 460px;">
                    <div class="card-header">
                        <i class="fas fa-chart-pie me-2"></i>
                        Tỷ Lệ Trạng Thái Cuộc Hẹn
                    </div>
                    <div class="chart-container" style="height: 320px;">
                        <canvas id="statusChart"></canvas>
                    </div>
                    <div class="status-legend" id="dynamicLegend" style="padding: 0 20px 20px 20px;">
                        <!-- Legend sẽ được tạo động bằng JavaScript -->
                    </div>
                </div>
            </div>
        </div>

        <!-- Debug Info -->
        <c:if test="${pageContext.request.isUserInRole('ADMIN')}">
            <div class="card chart-card mt-4">
                <div class="card-header">
                    <i class="fas fa-bug me-2"></i>
                    Debug Information
                </div>
                <div class="card-body">
                    <p>Current Date: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm:ss"/></p>
                    <p>dailyInvoices is null: ${dailyInvoices == null}</p>
                    <p>dailyInvoices size: ${fn:length(dailyInvoices)}</p>
                    <c:if test="${not empty dailyInvoices}">
                        <div>First Invoice Details:</div>
                        <pre>
ID: ${dailyInvoices[0].invoiceID}
Number: ${dailyInvoices[0].invoiceNumber}
Date: <fmt:formatDate value="${dailyInvoices[0].invoiceDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
Amount: ${dailyInvoices[0].finalAmount}
Status: ${dailyInvoices[0].paymentStatus}
Patient: ${dailyInvoices[0].patient != null ? dailyInvoices[0].patient.user.fullName : 'N/A'}
                        </pre>
                    </c:if>
                </div>
            </div>
        </c:if>

        
        <!-- Doanh Thu Bác Sĩ Hôm Nay -->
        <div class="row mt-4">
            <div class="col-lg-12">
                <div class="card chart-card doctor-revenue-card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <i class="fas fa-money-bill-wave me-2"></i>
                        <span class="fw-bold">Doanh Thu Bác Sĩ Hôm Nay</span>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped align-middle">
                                <thead class="table-light">
                                    <tr class="text-center">
                                        <th width="5%">STT</th>
                                        <th width="30%">Bác Sĩ</th>
                                        <th width="25%">Số Lượt Khám</th>
                                        <th width="40%">Doanh Thu</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty doctorRevenue}">
                                            <c:forEach var="revenue" items="${doctorRevenue}" varStatus="status">
                                                <tr class="text-center">
                                                    <td>${status.index + 1}</td>
                                                    <td class="text-start">
                                                        <div class="d-flex align-items-center">
                                                            <div class="doctor-avatar me-2">
                                                                <i class="fas fa-user-md text-primary"></i>
                                                            </div>
                                                            <div class="doctor-name">
                                                                <c:choose>
                                                                    <c:when test="${revenue.doctor != null && revenue.doctor.user != null}">
                                                                        ${revenue.doctor.user.fullName}
                                                                    </c:when>
                                                                    <c:when test="${revenue.firstName != null && revenue.lastName != null}">
                                                                        ${revenue.firstName} ${revenue.lastName}
                                                                    </c:when>
                                                                    <c:when test="${revenue.doctorName != null}">
                                                                        ${revenue.doctorName}
                                                                    </c:when>
                                                                    <c:otherwise>N/A</c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-info rounded-pill">
                                                            <i class="fas fa-clipboard-list me-1"></i>
                                                            ${revenue.totalExaminations != null ? revenue.totalExaminations : 0}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="text-success fw-bold">
                                                            <i class="fas fa-coins me-1"></i>
                                                            <fmt:formatNumber value="${revenue.totalRevenue != null ? revenue.totalRevenue : 0}" type="number" pattern="#,##0"/> VNĐ
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="text-center py-4">
                                                    <div class="alert alert-info mb-0">
                                                        <i class="fas fa-info-circle me-2"></i>
                                                        Không có dữ liệu doanh thu hôm nay.
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    <style>
        .chart-card {
            border: none;
            border-radius: 10px;
            overflow: hidden;
        }
        .chart-card .card-header {
            border-bottom: none;
            padding: 15px 20px;
        }
        .chart-card .card-header span {
            font-size: 1.2rem;
            font-weight: 600;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
            letter-spacing: 0.5px;
        }
        .chart-card .card-header i {
            font-size: 1.3rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        /* CSS riêng cho phần Doanh Thu Bác Sĩ */
        .doctor-revenue-card .card-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%) !important;
            box-shadow: 0 2px 4px rgba(40,167,69,0.3);
        }
        .doctor-avatar {
            width: 35px;
            height: 35px;
            background: #e8f3ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .doctor-avatar i {
            font-size: 18px;
        }
        .doctor-name {
            font-weight: 500;
            color: #2c3e50;
        }
        .table > :not(caption) > * > * {
            padding: 15px 10px;
        }
        .badge {
            padding: 8px 15px;
            font-size: 0.9rem;
        }
    </style>
    </div>

    <script>
        // Lấy dữ liệu từ model với kiểm tra lỗi chi tiết
        let dailyStats = [];
        try {
            const dailyStatsRaw = '${dailyStatsJson}'.replace(/&quot;/g, '"');
            dailyStats = dailyStatsRaw && dailyStatsRaw.trim() !== '' ? JSON.parse(dailyStatsRaw) : [];
            console.log('Parsed dailyStats:', dailyStats);
        } catch (e) {
            console.error('Error parsing dailyStatsJson:', e);
            dailyStats = [];
        }

        let statusDistribution = {};
        try {
            const statusDistRaw = '${statusDistributionJson}'.replace(/&quot;/g, '"');
            statusDistribution = statusDistRaw && statusDistRaw.trim() !== '' ? JSON.parse(statusDistRaw) : {};
            console.log('Parsed statusDistribution:', statusDistribution);
        } catch (e) {
            console.error('Error parsing statusDistributionJson:', e);
            statusDistribution = {};
        }
        
        // Xử lý dữ liệu cho biểu đồ với kiểm tra lỗi
        const dates = dailyStats.map((item, index) => {
            try {
                if (item && item.date) {
                    const date = new Date(item.date);
                    return isNaN(date.getTime()) ? `Ngày ${index + 1}` : date.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit' });
                }
                return `Ngày ${index + 1}`;
            } catch (e) {
                console.warn(`Error processing date at index ${index}:`, e);
                return `Ngày ${index + 1}`;
            }
        });

        const appointments = dailyStats.map((item, index) => {
            try {
                return item && typeof item.appointmentCount === 'number' ? item.appointmentCount : 0;
            } catch (e) {
                console.warn(`Error processing appointmentCount at index ${index}:`, e);
                return 0;
            }
        });

        const revenues = dailyStats.map((item, index) => {
            try {
                return item && typeof item.totalRevenue === 'number' ? item.totalRevenue : 0;
            } catch (e) {
                console.warn(`Error processing totalRevenue at index ${index}:`, e);
                return 0;
            }
        });

        // Biểu đồ kết hợp doanh thu và lượt khám
        const combinedCtx = document.getElementById('combinedChart')?.getContext('2d');
        if (combinedCtx) {
            new Chart(combinedCtx, {
                type: 'line',
                data: {
                    labels: dates.length > 0 ? dates : ['Không có dữ liệu'],
                    datasets: [{
                        label: 'Doanh Thu (Triệu VNĐ)',
                        data: revenues.map(r => r / 1000000),
                        backgroundColor: 'rgba(96, 165, 250, 0.3)',
                        borderColor: 'rgba(96, 165, 250, 1)',
                        borderWidth: 3,
                        tension: 0.4,
                        fill: true,
                        pointBackgroundColor: 'rgba(96, 165, 250, 1)',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2,
                        pointRadius: 5,
                        yAxisID: 'y'
                    }, {
                        label: 'Lượt Khám',
                        data: appointments,
                        backgroundColor: 'rgba(192, 132, 252, 0.3)',
                        borderColor: 'rgba(192, 132, 252, 1)',
                        borderWidth: 3,
                        tension: 0.4,
                        fill: true,
                        pointBackgroundColor: 'rgba(192, 132, 252, 1)',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2,
                        pointRadius: 5,
                        yAxisID: 'y1'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: {
                        mode: 'index',
                        intersect: false,
                    },
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                usePointStyle: true,
                                padding: 20,
                                font: {
                                    size: 12,
                                    weight: '500'
                                }
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            titleColor: '#fff',
                            bodyColor: '#fff',
                            borderColor: 'rgba(96, 165, 250, 1)',
                            borderWidth: 1,
                            cornerRadius: 8,
                            displayColors: true,
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.datasetIndex === 0) {
                                        label += new Intl.NumberFormat('vi-VN').format(context.parsed.y) + ' triệu VNĐ';
                                    } else {
                                        label += context.parsed.y + ' lượt';
                                    }
                                    return label;
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            grid: {
                                display: true,
                                color: 'rgba(0, 0, 0, 0.05)',
                                lineWidth: 1
                            },
                            ticks: {
                                font: {
                                    size: 11,
                                    weight: '500'
                                }
                            }
                        },
                        y: {
                            type: 'linear',
                            display: true,
                            position: 'left',
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return new Intl.NumberFormat('vi-VN').format(value);
                                },
                                font: {
                                    size: 11
                                }
                            },
                            grid: {
                                display: true,
                                color: 'rgba(0, 0, 0, 0.08)',
                                lineWidth: 1
                            },
                            title: { 
                                display: true, 
                                text: 'Doanh Thu (Triệu VNĐ)',
                                font: {
                                    size: 12,
                                    weight: '600'
                                },
                                color: 'rgba(96, 165, 250, 1)'
                            }
                        },
                        y1: {
                            type: 'linear',
                            display: true,
                            position: 'right',
                            beginAtZero: true,
                            grid: {
                                display: false
                            },
                            ticks: {
                                stepSize: 1,
                                font: {
                                    size: 11
                                }
                            },
                            title: {
                                display: true,
                                text: 'Lượt Khám',
                                font: {
                                    size: 12,
                                    weight: '600'
                                },
                                color: 'rgba(192, 132, 252, 1)'
                            }
                        }
                    }
                }
            });
        } else {
            console.error('combinedChart canvas context not found');
        }

        // Biểu đồ tròn trạng thái cuộc hẹn
        const statusCtx = document.getElementById('statusChart')?.getContext('2d');
        if (statusCtx) {
            const filteredStatusData = {};
            Object.keys(statusDistribution).forEach(key => {
                const value = parseInt(statusDistribution[key]);
                if (value > 0) {
                    filteredStatusData[key] = value;
                }
            });
            
            const statusLabels = Object.keys(filteredStatusData);
            const statusData = Object.values(filteredStatusData);
            
            const totalForTooltip = Object.values(statusDistribution).reduce((sum, value) => sum + (parseInt(value) || 0), 0);
            const totalAppointments = statusData.reduce((sum, value) => sum + (parseInt(value) || 0), 0);
            console.log('Original Status Distribution:', statusDistribution);
            console.log('Filtered Status Distribution:', filteredStatusData);
            console.log('Total Appointments:', totalAppointments);
            
            const hasData = statusData.length > 0 && statusData.some(value => value > 0);
            
            new Chart(statusCtx, {
                type: 'doughnut',
                data: {
                    labels: hasData ? statusLabels : ['Không có dữ liệu'],
                    datasets: [{
                        data: hasData ? statusData : [1],
                        backgroundColor: hasData ? statusLabels.map(label => {
                            switch(label) {
                                case 'Completed': return '#22c55e';
                                case 'Pending': return '#f59e0b';
                                case 'Cancelled': return '#ef4444';
                                case 'Confirmed': return '#3b82f6';
                                case 'Rejected': return '#9ca3af';
                                default: return '#6b7280';
                            }
                        }) : ['#e5e7eb'],
                        borderColor: '#ffffff',
                        borderWidth: 3,
                        hoverOffset: 8,
                        cutout: '65%'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            enabled: false
                        }
                    },
                    animation: {
                        animateRotate: true,
                        duration: 2000
                    }
                }
            });
        } else {
            console.error('statusChart canvas context not found');
        }

        const legendContainer = document.getElementById('dynamicLegend');
        if (legendContainer) {
            const statusNameMap = {
                'Completed': 'Hoàn thành',
                'Pending': 'Chờ xử lý',
                'Cancelled': 'Đã hủy'
            };
            
            const colorMap = {
                'Completed': '#22c55e',
                'Pending': '#f59e0b',
                'Cancelled': '#ef4444'
            };

            const mainStatuses = ['Completed', 'Pending', 'Cancelled'];
            
            mainStatuses.forEach(status => {
                const count = parseInt(statusDistribution[status]) || 0;
                const legendItem = document.createElement('div');
                legendItem.className = 'legend-item';
                legendItem.style.opacity = count > 0 ? '1' : '0.5';
                
                const colorDiv = document.createElement('div');
                colorDiv.className = 'legend-color';
                colorDiv.style.background = colorMap[status];
                
                const textSpan = document.createElement('span');
                textSpan.textContent = statusNameMap[status];
                
                legendItem.appendChild(colorDiv);
                legendItem.appendChild(textSpan);
                legendContainer.appendChild(legendItem);
            });
        } else {
            console.error('dynamicLegend container not found');
        }

        function viewInvoiceDetails(invoiceId) {
            if (!invoiceId) {
                alert('ID hóa đơn không hợp lệ!');
                return;
            }
            try {
                window.location.href = '${pageContext.request.contextPath}/admin/invoices/details/' + invoiceId;
            } catch (error) {
                console.error('Error navigating to invoice details:', error);
                alert('Có lỗi xảy ra khi xem chi tiết hóa đơn. Vui lòng thử lại sau.');
            }
        }

        function sendInvoiceNotification(invoiceId) {
            if (!invoiceId) {
                alert('ID hóa đơn không hợp lệ!');
                return;
            }
            try {
                const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
                // Gửi request đến endpoint xử lý gửi thông báo
                fetch('${pageContext.request.contextPath}/admin/invoices/notify/' + invoiceId, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken
                    }
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    alert('Đã gửi thông báo thành công!');
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi gửi thông báo. Vui lòng thử lại sau.');
                });
            } catch (error) {
                console.error('Error sending notification:', error);
                alert('Có lỗi xảy ra khi gửi thông báo. Vui lòng thử lại sau.');
            }
        }
    </script>
</body>
</html>