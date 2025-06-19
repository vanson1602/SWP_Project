<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Doctors Management</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
            <style>
                body {
                    background: #f0f2f5;
                    font-family: 'Segoe UI', sans-serif;
                    min-height: 100vh;
                }

                .page-header {
                    font-size: 32px;
                    font-weight: 600;
                    text-align: center;
                    margin: 40px 0 20px;
                    color: #343a40;
                }

                .page-title {
                    font-size: 28px;
                    font-weight: 600;
                    margin: 0;
                }

                .card {
                    border: none;
                    border-radius: 8px;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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

                .btn-action {
                    margin: 0 5px;
                    padding: 6px 12px;
                    border-radius: 6px;
                    font-weight: 500;
                }

                .btn-details {
                    background-color: #00b894;
                    color: #fff;
                }

                .btn-details:hover {
                    background-color: #00e0a3;
                }

                .btn-all-schedules {
                    background-color: #ff9f43;
                    color: #fff;
                }

                .btn-all-schedules:hover {
                    background-color: #ffad5c;
                }

                .btn-create {
                    background-color: #4e54c8;
                    color: #fff;
                }

                .btn-create:hover {
                    background-color: #5a5fd3;
                }

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

        <body>
            <div class="container mt-4">
                <div class="page-header">
                    <h1 class="page-title">Doctor Schedules</h1>
                </div>
                <div class="card p-4">
                    <div class="d-flex justify-content-between mb-3">
                        <a href="/admin/schedules/list" class="btn btn-all-schedules btn-action">View All Schedules</a>
                        <a href="/admin/schedules/add" class="btn btn-create btn-action">+ Add Schedule</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name Doctor</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="doctor" items="${doctors}">
                                    <tr>
                                        <td>${doctor.doctorID}</td>
                                        <td>${doctor.user.username}</td>
                                        <td>
                                            <a href="/admin/schedules/doctor/${doctor.doctorID}"
                                                class="btn btn-details btn-action">View Schedules</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="d-flex justify-content-center mt-4">
                    <a href="/admin" class="btn btn-back">← Back to Dashboard</a>
                </div>
            </div>
        </body>

        </html>