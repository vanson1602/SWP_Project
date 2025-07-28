// Patient Statistics JavaScript
let appointmentChart = null;

// Hiển thị loading indicator khi fetch dữ liệu chart
function showLoading() {
    if (document.getElementById('loadingIndicator')) return;
    const chartCanvas = document.getElementById('appointmentChart');
    if (!chartCanvas) return;
    const chartContainer = chartCanvas.parentElement;
    if (!chartContainer) return;
    const loading = document.createElement('div');
    loading.id = 'loadingIndicator';
    loading.style.position = 'absolute';
    loading.style.top = '50%';
    loading.style.left = '50%';
    loading.style.transform = 'translate(-50%, -50%)';
    loading.style.zIndex = '10';
    loading.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>';
    chartContainer.style.position = 'relative';
    chartContainer.appendChild(loading);
}
function hideLoading() {
    document.querySelectorAll('#loadingIndicator').forEach(e => e.remove());
}

// Khởi tạo chart khi trang load
document.addEventListener('DOMContentLoaded', function () {
    updateSummaryCards();
});



function updateTables(data) {
    // Cập nhật bảng thống kê theo tháng
    updateMonthlyTable(data.monthlyStats);

    // Cập nhật bảng thống kê theo chuyên khoa
    updateSpecializationTable(data.specializationStats);
}

function updateMonthlyTable(monthlyStats) {
    const container = document.getElementById('monthlyStatsTable');
    if (!container) return;

    if (monthlyStats && monthlyStats.length > 0) {
        const monthNames = ['', 'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
            'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];

        let html = '<div class="table-responsive"><table class="table table-sm"><thead><tr><th>Tháng/Năm</th><th class="text-center">Số lần khám</th></tr></thead><tbody>';

        monthlyStats.forEach(stat => {
            html += `<tr><td>${monthNames[stat.month]} / ${stat.year}</td><td class="text-center"><span class="badge bg-primary">${stat.appointmentCount}</span></td></tr>`;
        });

        html += '</tbody></table></div>';
        container.innerHTML = html;
    } else {
        container.innerHTML = '<div class="text-center empty-state py-4"><i class="bi bi-inbox"></i><p class="mt-2 mb-0">Chưa có dữ liệu khám bệnh</p></div>';
    }
}

function updateSpecializationTable(specializationStats) {
    const container = document.getElementById('specializationStatsTable');
    if (!container) return;

    if (specializationStats && specializationStats.length > 0) {
        let html = '<div class="table-responsive"><table class="table table-sm"><thead><tr><th>Chuyên khoa</th><th class="text-center">Số lần khám</th></tr></thead><tbody>';

        specializationStats.forEach(stat => {
            html += `<tr><td>${stat.specializationName}</td><td class="text-center"><span class="badge bg-success">${stat.appointmentCount}</span></td></tr>`;
        });

        html += '</tbody></table></div>';
        container.innerHTML = html;
    } else {
        container.innerHTML = '<div class="text-center empty-state py-4"><i class="bi bi-inbox"></i><p class="mt-2 mb-0">Chưa có dữ liệu khám bệnh</p></div>';
    }
}

function updateSummaryCards() {
    const year = parseInt(document.getElementById('yearFilter').value);
    const month = parseInt(document.getElementById('monthFilter').value);

    $.ajax({
        url: '/api/patient/stats/filter',
        method: 'GET',
        data: {
            year: year,
            month: month
        },
        success: function (response) {
            // Tính tổng số lần khám
            let totalAppointments = 0;
            if (response.monthlyStats) {
                response.monthlyStats.forEach(stat => {
                    totalAppointments += stat.appointmentCount;
                });
            }
            document.getElementById('totalAppointments').textContent = totalAppointments;

            // Tìm chuyên khoa khám nhiều nhất
            let topSpecialization = '-';
            let maxCount = 0;
            if (response.specializationStats && response.specializationStats.length > 0) {
                response.specializationStats.forEach(stat => {
                    if (stat.appointmentCount > maxCount) {
                        maxCount = stat.appointmentCount;
                        topSpecialization = stat.specializationName;
                    }
                });
            }
            document.getElementById('topSpecialization').textContent = topSpecialization;

            // Hiển thị tuần khám nhiều nhất nếu có
            if (typeof response.topWeek !== 'undefined' && response.topWeek !== null) {
                document.getElementById('topMonth').textContent = 'Tuần ' + response.topWeek + (response.topWeekCount ? ` (${response.topWeekCount} lần)` : '');
            } else {
                document.getElementById('topMonth').textContent = '-';
            }

            // Cập nhật label
            const labels = document.querySelectorAll('.stats-summary .label');
            if (month > 0) {
                const monthNames = ['', 'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
                    'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
                labels.forEach(label => {
                    label.textContent = `trong ${monthNames[month]} năm ${year}`;
                });
            } else {
                labels.forEach(label => {
                    label.textContent = `trong năm ${year}`;
                });
            }
        },
        error: function (xhr, status, error) {
            console.error('Error updating summary cards:', error);
        }
    });
}




// Thêm hiệu ứng cho bảng thống kê
document.addEventListener('DOMContentLoaded', function () {
    // Thêm hiệu ứng hover cho các hàng trong bảng
    const tableRows = document.querySelectorAll('.table tbody tr');
    tableRows.forEach(row => {
        row.addEventListener('mouseenter', function () {
            this.style.backgroundColor = '#f8f9fa';
            this.style.transition = 'background-color 0.2s ease';
        });

        row.addEventListener('mouseleave', function () {
            this.style.backgroundColor = '';
        });
    });

    // Thêm hiệu ứng cho badges
    const badges = document.querySelectorAll('.badge');
    badges.forEach(badge => {
        badge.addEventListener('mouseenter', function () {
            this.style.transform = 'scale(1.1)';
            this.style.transition = 'transform 0.2s ease';
        });

        badge.addEventListener('mouseleave', function () {
            this.style.transform = 'scale(1)';
        });
    });

    // Thêm hiệu ứng cho stats cards
    const statsCards = document.querySelectorAll('.stats-card');
    statsCards.forEach(card => {
        card.addEventListener('mouseenter', function () {
            this.style.boxShadow = '0 8px 25px rgba(0, 0, 0, 0.15)';
            this.style.transition = 'box-shadow 0.3s ease';
        });

        card.addEventListener('mouseleave', function () {
            this.style.boxShadow = '0 0 20px rgba(0, 0, 0, 0.1)';
        });
    });
});

// Vẽ chart 3 cột (Tổng, Hoàn thành, Hủy)
function load3ColChart(year) {
    $.ajax({
        url: '/api/patient/stats/chart-3col',
        method: 'GET',
        data: { year: year },
        success: function (response) {
            update3ColChart(response);

        },
        error: function (xhr, status, error) {
            console.error('Error loading 3col chart data:', error);

        }
    });
}

function update3ColChart(data) {
    // DEBUG: log dữ liệu truyền vào
    console.log('Chart data:', data);
    let ctx = document.getElementById('appointmentChart');
    if (!ctx) return;
    // Đảm bảo canvas có chiều cao cụ thể
    ctx.style.height = '350px';
    // Nếu ctx là canvas, lấy context 2d
    if (ctx.getContext) ctx = ctx.getContext('2d');
    if (appointmentChart) appointmentChart.destroy();

    // Kiểm tra dữ liệu động: chỉ hiển thị 'Không có dữ liệu' nếu không có mảng nào hoặc mảng rỗng
    const hasData = data && Array.isArray(data.labels) && data.labels.length > 0 &&
        Array.isArray(data.total) && Array.isArray(data.completed) && Array.isArray(data.cancelled);
    if (!hasData) {
        appointmentChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: [''],
                datasets: [{
                    label: 'Không có dữ liệu',
                    data: [0],
                    backgroundColor: 'rgba(200,200,200,0.2)',
                    borderWidth: 0
                }]
            },
            options: {
                plugins: {
                    legend: { display: false },
                    tooltip: { enabled: false }
                },
                scales: {
                    x: { display: false },
                    y: { display: false }
                },
                animation: false
            },
            plugins: [{
                id: 'noData',
                afterDraw: function (chart) {
                    const ctx = chart.ctx;
                    ctx.save();
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';
                    ctx.font = '18px Arial';
                    ctx.fillStyle = '#888';
                    ctx.fillText('Không có dữ liệu', chart.width / 2, chart.height / 2);
                    ctx.restore();
                }
            }]
        });
        return;
    }

    appointmentChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: data.labels,
            datasets: [
                {
                    label: 'Tổng đặt lịch',
                    data: data.total,
                    backgroundColor: 'rgba(54, 162, 235, 0.7)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 2,
                    borderRadius: 5
                },
                {
                    label: 'Hoàn thành',
                    data: data.completed,
                    backgroundColor: 'rgba(40, 167, 69, 0.7)',
                    borderColor: 'rgba(40, 167, 69, 1)',
                    borderWidth: 2,
                    borderRadius: 5
                },
                {
                    label: 'Hủy (Rejected/Cancelled)',
                    data: data.cancelled,
                    backgroundColor: 'rgba(220, 53, 69, 0.7)',
                    borderColor: 'rgba(220, 53, 69, 1)',
                    borderWidth: 2,
                    borderRadius: 5
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            animation: false,
            plugins: {
                legend: { position: 'top' },
                tooltip: { mode: 'index', intersect: false }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { stepSize: 1, color: '#6c757d' },
                    grid: { color: '#e9ecef' }
                },
                x: {
                    ticks: { color: '#6c757d' },
                    grid: { color: '#e9ecef' }
                }
            }
        }
    });
}

// Vẽ chart 3 cột theo ngày trong tháng
function load3ColChartDaily(year, month) {
    $.ajax({
        url: '/api/patient/stats/chart-3col-daily',
        method: 'GET',
        data: { year: year, month: month },
        success: function (response) {
            update3ColChart(response);

        },
        error: function (xhr, status, error) {
            console.error('Error loading 3col daily chart data:', error);

        }
    });
}

// Vẽ chart 3 cột theo tuần trong tháng
function load3ColChartWeekly(year, month) {
    $.ajax({
        url: '/api/patient/stats/chart-3col-daily',
        method: 'GET',
        data: { year: year, month: month },
        success: function (response) {
            // Gom nhóm theo tuần
            const days = response.labels;
            const total = response.total;
            const completed = response.completed;
            const cancelled = response.cancelled;
            const weeks = [];
            const weekLabels = [];
            let weekTotal = 0, weekCompleted = 0, weekCancelled = 0, weekNum = 1;
            for (let i = 0; i < days.length; i++) {
                weekTotal += total[i];
                weekCompleted += completed[i];
                weekCancelled += cancelled[i];

                if ((i + 1) % 7 === 0 || i === days.length - 1) {
                    weeks.push({
                        total: weekTotal,
                        completed: weekCompleted,
                        cancelled: weekCancelled
                    });
                    weekLabels.push('Tuần ' + weekNum);
                    weekNum++;
                    weekTotal = 0; weekCompleted = 0; weekCancelled = 0;
                }
            }
            update3ColChart({
                labels: weekLabels,
                total: weeks.map(w => w.total),
                completed: weeks.map(w => w.completed),
                cancelled: weeks.map(w => w.cancelled)
            });

        },
        error: function (xhr, status, error) {
            console.error('Error loading 3col weekly chart data:', error);

        }
    });
}


// Cập nhật label chart và summary khi filter
function updateChartLabels() {
    const chartModeSelect = document.getElementById('chartMode');
    const month = parseInt(document.getElementById('monthFilter').value);
    const year = parseInt(document.getElementById('yearFilter').value);
    let label = '';
    if (month > 0) {
        const mode = chartModeSelect ? chartModeSelect.value : 'day';
        label = (mode === 'week') ? 'tuần' : 'ngày';
        document.getElementById('chartTypeLabel').textContent = label;
        const timeStr = `Tháng ${month} năm ${year}`;
        var el1 = document.getElementById('summaryTime');
        var el2 = document.getElementById('summaryTime2');
        var el3 = document.getElementById('summaryTime3');
        if (el1) el1.textContent = timeStr;
        if (el2) el2.textContent = timeStr;
        if (el3) el3.textContent = timeStr;
    } else {
        // Khi chọn tất cả tháng, label là 'tháng'
        document.getElementById('chartTypeLabel').textContent = 'tháng';
        var el1 = document.getElementById('summaryTime');
        var el2 = document.getElementById('summaryTime2');
        var el3 = document.getElementById('summaryTime3');
        if (el1) el1.textContent = '';
        if (el2) el2.textContent = '';
        if (el3) el3.textContent = '';
    }
}

window.filterStats = function () {
    const year = parseInt(document.getElementById('yearFilter').value);
    const month = parseInt(document.getElementById('monthFilter').value);
    const chartModeSelect = document.getElementById('chartMode');
    updateChartLabels();
    if (month === 0) {
        if (chartModeSelect) chartModeSelect.disabled = true;

        load3ColChart(year); // Chỉ gọi chart theo tháng
        updateSummaryCards();
        return;
    } else {
        if (chartModeSelect) chartModeSelect.disabled = false;
    }
    const mode = chartModeSelect ? chartModeSelect.value : 'day';

    if (mode === 'week') {
        load3ColChartWeekly(year, month);
    } else {
        load3ColChartDaily(year, month);
    }
    updateSummaryCards();
}

$(document).ready(function () {
    const year = parseInt(document.getElementById('yearFilter').value);
    const month = parseInt(document.getElementById('monthFilter').value);
    const chartModeSelect = document.getElementById('chartMode');
    updateChartLabels();
    $.ajax({
        url: '/api/patient/stats/filter',
        method: 'GET',
        data: { year: year, month: month },
        success: function (response) {
            updateTables(response);
        }
    });

    if (month === 0) {
        if (chartModeSelect) chartModeSelect.disabled = true;
        load3ColChart(year);
    } else {
        if (chartModeSelect) chartModeSelect.disabled = false;
        const mode = chartModeSelect ? chartModeSelect.value : 'day';
        if (mode === 'week') {
            load3ColChartWeekly(year, month);
        } else {
            load3ColChartDaily(year, month);
        }
    }
}); 