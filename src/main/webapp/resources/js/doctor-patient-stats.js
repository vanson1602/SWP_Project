// doctor-patient-stats.js
let doctorPatientChart = null;

function getCurrentYear() {
    return new Date().getFullYear();
}

function populateDoctorYearFilter() {
    const yearSelect = document.getElementById('doctorYearFilter');
    const currentYear = getCurrentYear();
    for (let y = currentYear; y >= currentYear - 10; y--) {
        const opt = document.createElement('option');
        opt.value = y;
        opt.textContent = y;
        yearSelect.appendChild(opt);
    }
    yearSelect.value = currentYear;
}

document.addEventListener('DOMContentLoaded', function () {
    populateDoctorYearFilter();
    loadDoctorPatientChart();
});

function filterDoctorStats() {
    loadDoctorPatientChart();
}

function loadDoctorPatientChart() {
    const year = parseInt(document.getElementById('doctorYearFilter').value);
    const month = parseInt(document.getElementById('doctorMonthFilter').value);
    const chartModeSelect = document.getElementById('doctorChartMode');
    let mode = chartModeSelect.value;
    if (month === 0) {
       
        if (chartModeSelect) chartModeSelect.disabled = true;
        mode = 'month';
    } else {
        if (chartModeSelect) chartModeSelect.disabled = false;
    }
    $.ajax({
        url: '/api/doctor/stats/patients',
        method: 'GET',
        data: { year: year, month: month, mode: mode },
        success: function (response) {
            updateDoctorPatientChart(response);
        },
        error: function (xhr, status, error) {
            console.error('Error loading doctor patient stats:', error);
        }
    });
}

function updateDoctorPatientChart(data) {
    let ctx = document.getElementById('doctorPatientChart');
    if (!ctx) return;
    if (ctx.getContext) ctx = ctx.getContext('2d');
    if (doctorPatientChart) doctorPatientChart.destroy();

    let labels = [];
    let values = [];
    if (data.stats && data.stats.length > 0) {
        if (data.mode === 'day') {
            const daysInMonth = new Date(data.year, data.month, 0).getDate();
            labels = Array.from({ length: daysInMonth }, (_, i) => (i + 1).toString());
            let dayMap = {};
            data.stats.forEach(s => { dayMap[s.day] = s.patientCount; });
            values = labels.map(day => dayMap[day] ? dayMap[day] : 0);
        } else if (data.mode === 'week') {
           
            const daysInMonth = new Date(data.year, data.month, 0).getDate();
            const weekCount = Math.ceil(daysInMonth / 7);
            labels = Array.from({ length: weekCount }, (_, i) => 'Tuần ' + (i + 1));
            let weekMap = {};
            data.stats.forEach(s => { weekMap[s.weekInMonth] = s.patientCount; });
            values = labels.map((_, i) => weekMap[i + 1] ? weekMap[i + 1] : 0);
        } else if (data.mode === 'month' || data.month === 0) {
            labels = Array.from({ length: 12 }, (_, i) => 'Tháng ' + (i + 1));
            let monthMap = {};
            data.stats.forEach(s => { monthMap[s.month] = s.patientCount; });
            values = labels.map((_, i) => monthMap[i + 1] ? monthMap[i + 1] : 0);
        }
    }

    doctorPatientChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Số bệnh nhân đã khám',
                data: values,
                fill: false,
                borderColor: 'rgba(54, 162, 235, 1)',
                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                tension: 0.3,
                pointRadius: 5,
                pointHoverRadius: 7
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: true },
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