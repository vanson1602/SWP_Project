<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Doctor ${doctor.user.username}'s Schedules</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <style>
                body {
                    background: #f8f9fa;
                    font-family: 'Segoe UI', sans-serif;
                }

                .page-title {
                    font-size: 32px;
                    font-weight: 600;
                    text-align: center;
                    margin: 40px 0 20px;
                    color: #343a40;
                }

                .card {
                    border: none;
                    border-radius: 12px;
                    box-shadow: 0 0 15px rgba(0, 0, 0, 0.05);
                }

                .table thead {
                    background-color: #4e54c8;
                    color: #fff;
                }

                .table th,
                .table td {
                    vertical-align: middle;
                    text-align: center;
                }

                .btn-edit {
                    background-color: #00b894;
                    color: white;
                    border-radius: 6px;
                    padding: 4px 10px;
                }

                .btn-danger {
                    background-color: #d63031;
                    color: white;
                    border-radius: 6px;
                    padding: 4px 10px;
                }

                .btn-back {
                    border-radius: 8px;
                    padding: 8px 24px;
                    font-weight: 500;
                }
            </style>
        </head>

        <body>
            <div class="container my-4">
                <div class="page-title">Schedules for Dr. ${doctor.user.username}</div>
                <div class="card p-4 bg-white">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID Schedule</th>
                                    <th>Work Date</th>
                                    <th>Start Time</th>
                                    <th>End Time</th>
                                    <th>Status</th>
                                    <th>Max Patients</th>
                                    <th>Clinic Room</th>
                                    <th>Notes</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="schedule" items="${schedules}">
                                    <tr>
                                        <td>${schedule.scheduleID}</td>
                                        <td>${schedule.workDate}</td>
                                        <td>${schedule.startTime}</td>
                                        <td>${schedule.endTime}</td>
                                        <td>${schedule.status}</td>
                                        <td>${schedule.maxPatients}</td>
                                        <td>${schedule.clinicRoom}</td>
                                        <td>${schedule.notes}</td>
                                        <td>
                                            <a href="/admin/schedules/edit/${schedule.scheduleID}"
                                                class="btn btn-edit btn-sm">Edit</a>
                                            <a href="/admin/schedules/delete/${schedule.scheduleID}"
                                                class="btn btn-danger btn-sm"
                                                onclick="return confirm('Delete this schedule?');">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="d-flex justify-content-center mt-4">
                    <a href="/admin/schedules/doctors" class="btn btn-secondary btn-back">← Back to Doctors List</a>
                </div>
            </div>
        </body>

        </html>