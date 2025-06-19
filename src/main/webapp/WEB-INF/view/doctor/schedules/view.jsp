<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>My Schedule</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <style>
                body {
                    background: #f8f9fa;
                    font-family: 'Segoe UI', sans-serif;
                    padding-top: 60px;
                }

                .page-title {
                    font-size: 32px;
                    font-weight: 600;
                    text-align: center;
                    margin-bottom: 30px;
                    color: #343a40;
                }

                .btn-back {
                    background-color: #6c757d;
                    color: white;
                    border-radius: 10px;
                    font-weight: 500;
                }

                .btn-back:hover {
                    background-color: #5c636a;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <h2 class="page-title">My Schedule (Doctor ID: ${doctorID})</h2>
                <div class="row justify-content-center">
                    <div class="col-md-10">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Work Date</th>
                                    <th>Start Time</th>
                                    <th>End Time</th>
                                    <th>Status</th>
                                    <th>Max Patients</th>
                                    <th>Clinic Room</th>
                                    <th>Notes</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="schedule" items="${schedules}">
                                    <tr>
                                        <td>${schedule.workDate}</td>
                                        <td>${schedule.startTime}</td>
                                        <td>${schedule.endTime}</td>
                                        <td>${schedule.status}</td>
                                        <td>${schedule.maxPatients}</td>
                                        <td>${schedule.clinicRoom}</td>
                                        <td>${schedule.notes}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div class="d-grid">
                            <a href="/doctor/dashboard" class="btn btn-back">← Back to Dashboard</a>
                        </div>
                    </div>
                </div>
            </div>
        </body>

        </html>