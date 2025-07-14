<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Add New Doctor Schedule</title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">

                <!-- Bootstrap & FullCalendar -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>

                <style>
                    body {
                        background: #f0f4f8;
                        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                        padding: 20px 0;
                        min-height: 100vh;
                    }

                    .container {
                        max-width: 1400px;
                        margin: 0 auto;
                        padding: 0 15px;
                    }

                    .page-title {
                        font-size: 24px;
                        font-weight: 600;
                        text-align: center;
                        margin-bottom: 20px;
                        color: #2c3e50;
                    }

                    .card {
                        border-radius: 8px;
                        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
                        background: white;
                        padding: 20px;
                    }

                    .form-label {
                        font-weight: 500;
                        color: #34495e;
                        font-size: 14px;
                        margin-bottom: 4px;
                    }

                    .form-control,
                    .form-select {
                        border-radius: 6px;
                        border: 1px solid #e2e8f0;
                        padding: 8px 12px;
                        font-size: 14px;
                        height: 38px;
                    }

                    .form-control:focus,
                    .form-select:focus {
                        border-color: #3498db;
                        box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
                    }

                    .btn {
                        border-radius: 6px;
                        font-size: 14px;
                        padding: 8px 16px;
                    }

                    .btn-save {
                        background-color: #3498db;
                        color: white;
                        border: none;
                    }

                    .btn-clear {
                        background-color: #e74c3c;
                        color: white;
                        border: none;
                        width: 100%;
                    }

                    .btn-back {
                        background-color: #95a5a6;
                        color: white;
                        border: none;
                    }

                    .two-column-layout {
                        display: grid;
                        grid-template-columns: 1fr 1.2fr;
                        gap: 20px;
                    }

                    #calendar {
                        background: white;
                        border-radius: 8px;
                        padding: 15px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                        height: auto;
                        min-height: 450px;
                    }

                    .fc-toolbar-title {
                        font-size: 16px !important;
                    }

                    .fc .fc-button {
                        padding: 6px 12px;
                        font-size: 14px;
                    }

                    .fc-day-today {
                        background: rgba(52, 152, 219, 0.1) !important;
                    }

                    .text-danger {
                        font-size: 12px;
                        margin-top: 4px;
                    }

                    #selected-dates-info {
                        font-size: 13px;
                        background: #f8fafc;
                        padding: 8px;
                        border-radius: 6px;
                        margin-top: 10px;
                        text-align: center;
                    }

                    .alert {
                        padding: 12px 16px;
                        border-radius: 6px;
                        margin-bottom: 20px;
                        font-size: 14px;
                    }

                    .form-group {
                        margin-bottom: 15px;
                    }

                    .row {
                        margin-bottom: 0;
                    }

                    .col-md-6 {
                        padding: 0 8px;
                    }

                    textarea.form-control {
                        height: auto;
                        min-height: 80px;
                    }

                    /* Compact form sections */
                    .form-section {
                        background: #f8fafc;
                        padding: 15px;
                        border-radius: 8px;
                        margin-bottom: 15px;
                    }

                    .form-section:last-child {
                        margin-bottom: 0;
                    }

                    /* Button group spacing */
                    .d-grid {
                        gap: 10px;
                    }

                    /* Calendar day cell size */
                    .fc-daygrid-day {
                        height: 50px !important;
                    }

                    /* Unavailable dates styling */
                    .fc-day-unavailable {
                        background-color: #fee2e2 !important;
                        cursor: not-allowed !important;
                    }

                    .fc-day-unavailable .fc-daygrid-day-number {
                        color: #dc2626;
                        text-decoration: line-through;
                    }

                    /* Responsive adjustments */
                    @media (max-width: 1200px) {
                        .container {
                            max-width: 100%;
                        }
                    }

                    @media (max-width: 992px) {
                        .two-column-layout {
                            grid-template-columns: 1fr;
                        }
                    }

                    .btn-back {
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        background-color: #6c757d;
                        color: white;
                        border: none;
                        padding: 8px 16px;
                        font-size: 14px;
                        border-radius: 6px;
                        text-decoration: none;
                        transition: all 0.2s ease;
                    }

                    .btn-back:hover {
                        background-color: #5a6268;
                        color: white;
                        transform: translateX(-2px);
                    }

                    .page-title {
                        font-size: 24px;
                        font-weight: 600;
                        color: #2c3e50;
                        margin: 0;
                        text-align: center;
                    }
                </style>

                <!-- Add Font Awesome if not already included -->
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
                    rel="stylesheet">
            </head>

            <body>
                <div class="container">
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <a href="${pageContext.request.contextPath}/admin/schedules/doctors" class="btn btn-back">
                            <i class="fas fa-arrow-left"></i> Back to List
                        </a>
                        <h1 class="page-title m-0">Add New Doctor Schedule</h1>
                        <div style="width: 100px;"><!-- Empty div for alignment --></div>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            ${error}
                        </div>
                    </c:if>
                    <div class="card">
                        <form:form id="scheduleForm" action="${pageContext.request.contextPath}/admin/schedules/save"
                            method="post" modelAttribute="schedule">
                            <div class="two-column-layout">
                                <!-- Left Column - Form Fields -->
                                <div>
                                    <!-- Doctor Selection -->
                                    <div class="form-section">
                                        <div class="form-group">
                                            <label class="form-label">Doctor <span class="text-danger">*</span></label>
                                            <form:select path="doctor" cssClass="form-select" required="true"
                                                id="doctorSelect">
                                                <form:option value="" label="-- Select Doctor --" />
                                                <c:forEach var="doc" items="${doctors}">
                                                    <form:option value="${doc.doctorID}">
                                                        Dr. ${doc.user.firstName} ${doc.user.lastName} (ID:
                                                        ${doc.doctorID})
                                                    </form:option>
                                                </c:forEach>
                                            </form:select>
                                            <form:errors path="doctor" cssClass="text-danger" />
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">Start Time <span
                                                            class="text-danger">*</span></label>
                                                    <form:input path="startTime" type="time" cssClass="form-control"
                                                        required="true" id="startTime" />
                                                    <form:errors path="startTime" cssClass="text-danger" />
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">End Time <span
                                                            class="text-danger">*</span></label>
                                                    <form:input path="endTime" type="time" cssClass="form-control"
                                                        required="true" id="endTime" />
                                                    <form:errors path="endTime" cssClass="text-danger" />
                                                    <div id="time-validation-error"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Additional Details -->
                                    <div class="form-section">
                                        <div class="form-group">
                                            <label class="form-label">Status</label>
                                            <form:select path="status" cssClass="form-select">
                                                <form:option value="" label="-- Select Status --" />
                                                <form:option value="Available">Available</form:option>
                                                <form:option value="Busy">Busy</form:option>
                                            </form:select>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">Max Patients</label>
                                                    <form:input path="maxPatients" type="number"
                                                        cssClass="form-control" />
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">Clinic Room</label>
                                                    <form:input path="clinicRoom" cssClass="form-control" />
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group mb-3">
                                            <label class="form-label">Notes</label>
                                            <form:textarea path="notes" cssClass="form-control" rows="3" />
                                        </div>

                                        <div class="d-grid">
                                            <button type="submit" class="btn btn-save">Save Schedule</button>
                                        </div>
                                    </div>
                                </div>

                                <!-- Right Column - Calendar -->
                                <div>
                                    <div class="form-section">
                                        <label class="form-label">Select Work Dates <span
                                                class="text-danger">*</span></label>
                                        <div id="calendar"></div>
                                        <button type="button" id="clear-dates" class="btn btn-clear mt-3">Clear
                                            Dates</button>
                                        <input type="hidden" name="selectedDates" id="selectedDates" required />
                                        <form:hidden path="workDate" id="workDate" />
                                        <form:errors path="workDate" cssClass="text-danger" />
                                        <div id="selected-dates-info" aria-live="polite"></div>
                                        <div id="date-validation-error" class="text-danger mt-2"></div>
                                    </div>
                                </div>
                            </div>
                        </form:form>
                    </div>
                </div>

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const calendarEl = document.getElementById('calendar');
                        const selectedDatesInfo = document.getElementById('selected-dates-info');
                        const selectedDatesInput = document.getElementById('selectedDates');
                        const workDateInput = document.getElementById('workDate');
                        const startTimeInput = document.getElementById('startTime');
                        const endTimeInput = document.getElementById('endTime');
                        const timeValidationError = document.getElementById('time-validation-error');
                        const dateValidationError = document.getElementById('date-validation-error');
                        const clearDatesButton = document.getElementById('clear-dates');
                        const doctorSelect = document.getElementById('doctorSelect');

                        let selectedDates = new Set();
                        let existingSchedules = new Set();

                        // Function to fetch existing schedules for a doctor
                        async function fetchExistingSchedules(doctorId) {
                            try {
                                const response = await fetch(`${pageContext.request.contextPath}/admin/schedules/doctor/${doctorId}/schedules`);
                                if (!response.ok) {
                                    throw new Error('Failed to fetch schedules');
                                }
                                const data = await response.json();
                                existingSchedules.clear();
                                data.forEach(schedule => {
                                    existingSchedules.add(schedule.workDate);
                                });

                                // Update calendar to show existing schedules
                                calendar.getEvents().forEach(e => e.remove());
                                existingSchedules.forEach(date => {
                                    calendar.addEvent({
                                        start: date,
                                        allDay: true,
                                        display: 'background',
                                        backgroundColor: '#e74c3c',
                                        classNames: ['fc-existing-date']
                                    });
                                });
                                selectedDates.forEach(date => {
                                    calendar.addEvent({
                                        start: date,
                                        allDay: true,
                                        display: 'background',
                                        classNames: ['fc-selected-date']
                                    });
                                });
                            } catch (error) {
                                console.error('Error fetching schedules:', error);
                                dateValidationError.textContent = 'Error loading existing schedules';
                            }
                        }

                        // Update when doctor is selected
                        doctorSelect.addEventListener('change', function () {
                            const doctorId = this.value;
                            if (doctorId) {
                                fetchExistingSchedules(doctorId);
                            }
                        });

                        const calendar = new FullCalendar.Calendar(calendarEl, {
                            initialView: 'dayGridMonth',
                            selectable: true,
                            unselectAuto: false,
                            selectAllow: function (info) {
                                // Check if date is in the past
                                const today = new Date();
                                today.setHours(0, 0, 0, 0);

                                // Get the selected date and set time to midnight for comparison
                                const selectedDate = new Date(info.start);
                                selectedDate.setHours(0, 0, 0, 0);

                                // Check if date is in the past
                                if (selectedDate < today) {
                                    return false;
                                }

                                // Check if date already has a schedule
                                const dateStr = selectedDate.toISOString().split('T')[0];
                                return !existingSchedules.has(dateStr);
                            },
                            select: function (info) {
                                let currentDate = new Date(info.startStr);
                                let endDate = new Date(info.endStr);

                                while (currentDate < endDate) {
                                    const dateStr = currentDate.toISOString().split('T')[0];
                                    if (selectedDates.has(dateStr)) {
                                        selectedDates.delete(dateStr);
                                    } else {
                                        selectedDates.add(dateStr);
                                    }
                                    currentDate.setDate(currentDate.getDate() + 1);
                                }

                                dateValidationError.textContent = ''; // Clear error message
                                updateSelectedDatesDisplay();
                                updateCalendarHighlights();
                            },
                            height: 450,
                            headerToolbar: {
                                left: 'prev,next today',
                                center: 'title',
                                right: ''
                            },
                            dayCellDidMount: function (arg) {
                                // Check if date has existing schedule
                                const dateStr = arg.date.toISOString().split('T')[0];
                                if (existingSchedules.has(dateStr)) {
                                    // Add a class to style unavailable dates
                                    arg.el.classList.add('fc-day-unavailable');
                                }
                            }
                        });

                        // Add CSS for unavailable dates
                        const style = document.createElement('style');
                        style.textContent = `
                            .fc-day-unavailable {
                                background-color: #ffebee !important;
                                cursor: not-allowed !important;
                            }
                            .fc-day-unavailable .fc-daygrid-day-number {
                                color: #d32f2f;
                                text-decoration: line-through;
                            }
                        `;
                        document.head.appendChild(style);

                        calendar.render();

                        function updateSelectedDatesDisplay() {
                            const dateArray = Array.from(selectedDates).sort();
                            selectedDatesInput.value = dateArray.join(',');
                            workDateInput.value = dateArray[0] || '';
                            selectedDatesInfo.textContent = dateArray.length > 0
                                ? `Selected ${dateArray.length} date(s): ${dateArray.join(', ')}`
                                : 'No dates selected';
                        }

                        function updateCalendarHighlights() {
                            calendar.getEvents().forEach(e => e.remove());
                            selectedDates.forEach(date => {
                                calendar.addEvent({
                                    start: date,
                                    allDay: true,
                                    display: 'background',
                                    classNames: ['fc-selected-date']
                                });
                            });
                        }

                        clearDatesButton.addEventListener('click', function () {
                            selectedDates.clear();
                            dateValidationError.textContent = ''; // Clear error message
                            updateSelectedDatesDisplay();
                            updateCalendarHighlights();
                        });

                        function validateTimes() {
                            const startTime = startTimeInput.value;
                            const endTime = endTimeInput.value;
                            if (startTime && endTime && startTime >= endTime) {
                                timeValidationError.textContent = 'End time must be after start time';
                                startTimeInput.classList.add('is-invalid');
                                endTimeInput.classList.add('is-invalid');
                            } else {
                                timeValidationError.textContent = '';
                                startTimeInput.classList.remove('is-invalid');
                                endTimeInput.classList.remove('is-invalid');
                            }
                        }

                        startTimeInput.addEventListener('change', validateTimes);
                        endTimeInput.addEventListener('change', validateTimes);
                    });
                </script>
            </body>

            </html>