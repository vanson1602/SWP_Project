<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Admin Schedules</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

            <style>
                .btn-back {
                    background-color: #6c757d;
                    color: #fff;
                    border-radius: 6px;
                    padding: 8px 20px;
                }

                .btn-back:hover {
                    background-color: #5c636a;
                }
            </style>

        </head>

        <body class="bg-light">
            <div class="container my-5">
                <h2 class="text-center mb-4">Danh sách lịch bận đang xử lý</h2>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <c:out value="${error}" />
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${empty pendingSchedules}">
                        <div class="alert alert-info text-center">Không có lịch bận nào đang xử lý.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle">
                                <thead class="table-primary text-center">
                                    <tr>
                                        <th>Bác sĩ</th>
                                        <th>Ngày làm việc</th>
                                        <th>Thời gian bắt đầu</th>
                                        <th>Thời gian kết thúc</th>
                                        <th>Slots</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="schedule" items="${pendingSchedules}">
                                        <tr>
                                            <td>
                                                <c:out value="${schedule.doctor.user.fullName}"
                                                    default="Không xác định" />
                                            </td>
                                            <td>
                                                <c:out value="${schedule.workDate}" />
                                            </td>
                                            <td>
                                                <c:out value="${schedule.startTime}" />
                                            </td>
                                            <td>
                                                <c:out value="${schedule.endTime}" />
                                            </td>
                                            <td>
                                                <c:if test="${not empty schedule.bookingSlots}">
                                                    <c:forEach var="slot" items="${schedule.bookingSlots}">
                                                        <div class="slot-row">
                                                            ${slot.startTime.hour}:${String.format("%02d",
                                                            slot.startTime.minute)} -
                                                            ${slot.endTime.hour}:${String.format("%02d",
                                                            slot.endTime.minute)}
                                                            (${slot.status})
                                                        </div>
                                                    </c:forEach>
                                                </c:if>
                                                <c:if test="${empty schedule.bookingSlots}">
                                                    <div class="slot-row">No slots available</div>
                                                </c:if>
                                            </td>
                                            <td class="text-center">
                                                <button class="btn btn-success btn-sm me-2"
                                                    onclick="approveSchedule('${schedule.scheduleID}')">Phê
                                                    duyệt</button>
                                                <button class="btn btn-danger btn-sm"
                                                    onclick="rejectSchedule('${schedule.scheduleID}')">Từ chối</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div id="responseMessage" class="mt-3 fw-bold"></div>
            </div>

            <script>
                function approveSchedule(scheduleId) {
                    $.ajax({
                        url: '/admin/schedules/approve-schedule',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({ scheduleId: scheduleId }),
                        success: function (response) {
                            if (response.success) {
                                $('#responseMessage').text(response.message).removeClass().addClass('text-success');
                                setTimeout(() => location.reload(), 2000);
                            } else {
                                $('#responseMessage').text(response.message).removeClass().addClass('text-danger');
                            }
                        },
                        error: function (xhr, status, error) {
                            $('#responseMessage').text('Lỗi khi phê duyệt: ' + error).removeClass().addClass('text-danger');
                            console.error('AJAX Error: ', status, error, xhr.responseText);
                        }
                    });
                }

                function rejectSchedule(scheduleId) {
                    $.ajax({
                        url: '/admin/schedules/reject-schedule',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({ scheduleId: scheduleId }),
                        success: function (response) {
                            if (response.success) {
                                $('#responseMessage').text(response.message).removeClass().addClass('text-success');
                                setTimeout(() => location.reload(), 2000);
                            } else {
                                $('#responseMessage').text(response.message).removeClass().addClass('text-danger');
                            }
                        },
                        error: function (xhr, status, error) {
                            $('#responseMessage').text('Lỗi khi từ chối: ' + error).removeClass().addClass('text-danger');
                            console.error('AJAX Error: ', status, error, xhr.responseText);
                        }
                    });
                }
            </script>
            <div class="d-flex justify-content-center mt-4" style="margin-bottom: 2%;">
                <a href="/admin" class="btn btn-back">← Back to Dashboard</a>
            </div>
        </body>

        </html>