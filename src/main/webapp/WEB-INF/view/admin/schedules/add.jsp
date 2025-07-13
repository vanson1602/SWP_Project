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
                        background: linear-gradient(135deg, #f0f4f8 0%, #d9e2ec 100%);
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        padding-top: 30px;
                        min-height: 100vh;
                    }

                    .container {
                        max-width: 1140px;
                        margin: 0 auto;
                    }

                    .page-title {
                        font-size: 26px;
                        font-weight: 700;
                        text-align: center;
                        margin-bottom: 20px;
                        color: #2c3e50;
                    }

                    .card {
                        border-radius: 15px;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                        background: white;
                        padding: 20px;
                    }

                    .form-label {
                        font-weight: 600;
                        color: #34495e;
                    }

                    .form-control,
                    .form-select {
                        border-radius: 10px;
                    }

                    .btn-save {
                        background-color: #3498db;
                        color: white;
                        font-weight: 600;
                        border-radius: 10px;
                    }

                    .btn-clear {
                        background-color: #e74c3c;
                        color: white;
                        border-radius: 10px;
                        width: 100%;
                    }

                    .btn-back {
                        background-color: #7f8c8d;
                        color: white;
                        border-radius: 10px;
                    }

                    .two-column-layout {
                        display: grid;
                        grid-template-columns: 1.3fr 1fr;
                        gap: 30px;
                    }

                    #calendar {
                        background: white;
                        border-radius: 10px;
                        padding: 10px;
                        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
                        height: 450px;
                    }

                    .fc-selected-date {
                        background-color: #3498db !important;
                        opacity: 0.3;
                    }

                    .text-danger {
                        font-size: 0.85rem;
                    }

                    #selected-dates-info {
                        font-size: 0.85rem;
                        background: #f9fbfd;
                        padding: 5px;
                        border-radius: 5px;
                        margin-top: 5px;
                        text-align: center;
                    }

                    #time-validation-error {
                        font-size: 0.8rem;
                        color: #e74c3c;
                        margin-top: 4px;
                    }

                    @media (max-width: 768px) {
                        .two-column-layout {
                            grid-template-columns: 1fr;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <div class="page-title">Add New Doctor Schedule</div>
                    <div class="card">
                        <form:form id="scheduleForm" action="${pageContext.request.contextPath}/admin/schedules/save"
                            method="post" modelAttribute="schedule">
                            <div class="two-column-layout">
                                <!-- Left Column -->
                                <div>
                                    <div class="mb-3">
                                        <label class="form-label">Doctor <span class="text-danger">*</span></label>
                                        <form:select path="doctor" cssClass="form-select" required="true">
                                            <form:option value="" label="-- Select Doctor --" />
                                            <c:forEach var="doc" items="${doctors}">
                                                <form:option value="${doc.doctorID}">
                                                    Dr. ${doc.user.firstName} ${doc.user.lastName} (ID: ${doc.doctorID})
                                                </form:option>
                                            </c:forEach>
                                        </form:select>
                                        <form:errors path="doctor" cssClass="text-danger" />
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label">Start Time <span
                                                    class="text-danger">*</span></label>
                                            <form:input path="startTime" type="time" cssClass="form-control"
                                                required="true" id="startTime" />
                                            <form:errors path="startTime" cssClass="text-danger" />
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">End Time <span
                                                    class="text-danger">*</span></label>
                                            <form:input path="endTime" type="time" cssClass="form-control"
                                                required="true" id="endTime" />
                                            <form:errors path="endTime" cssClass="text-danger" />
                                            <div id="time-validation-error"></div>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Status</label>
                                        <form:select path="status" cssClass="form-select">
                                            <form:option value="" label="-- Select Status --" />
                                            <form:option value="Available">Available</form:option>
                                            <form:option value="Busy">Busy</form:option>
                                        </form:select>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label">Max Patients</label>
                                            <form:input path="maxPatients" type="number" cssClass="form-control" />
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">Clinic Room</label>
                                            <form:input path="clinicRoom" cssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Notes</label>
                                        <form:textarea path="notes" cssClass="form-control" rows="3" />
                                    </div>

                                    <div class="d-grid mb-3">
                                        <button type="submit" class="btn btn-save">Save Schedule</button>
                                    </div>
                                    <div class="d-grid">
                                        <a href="${pageContext.request.contextPath}/admin/schedules/doctors"
                                            class="btn btn-back">← Back to List</a>
                                    </div>
                                </div>

                                <!-- Right Column -->
                                <div>
                                    <div class="mb-3">
                                        <label class="form-label">Select Work Dates <span
                                                class="text-danger">*</span></label>
                                        <div id="calendar"></div>
                                        <button type="button" id="clear-dates" class="btn btn-clear mt-2">Clear
                                            Dates</button>
                                        <input type="hidden" name="selectedDates" id="selectedDates" required />
                                        <form:hidden path="workDate" id="workDate" />
                                        <form:errors path="workDate" cssClass="text-danger" />
                                        <div id="selected-dates-info" aria-live="polite"></div>
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
                        const clearDatesButton = document.getElementById('clear-dates');

                        let selectedDates = new Set();

                        const calendar = new FullCalendar.Calendar(calendarEl, {
                            initialView: 'dayGridMonth',
                            selectable: true,
                            unselectAuto: false,
                            selectAllow: function (info) {
                                return info.start >= new Date();
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

                                updateSelectedDatesDisplay();
                                updateCalendarHighlights();
                            },
                            height: 450,
                            headerToolbar: {
                                left: 'prev,next today',
                                center: 'title',
                                right: ''
                            }
                        });
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