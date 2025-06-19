<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Add New Schedule</title>
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

                    .card {
                        border: none;
                        border-radius: 12px;
                        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
                    }

                    .form-label {
                        font-weight: 500;
                        color: #495057;
                    }

                    .form-control,
                    .form-select {
                        border-radius: 10px;
                    }

                    .btn-save {
                        background-color: #4e54c8;
                        color: white;
                        font-weight: 500;
                        border-radius: 10px;
                        border: none;
                    }

                    .btn-save:hover {
                        background-color: #5e64d8;
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
                    <div class="page-title">Add New Doctor Schedule</div>
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="card p-4 bg-white">
                                <div class="card-body">
                                    <form:form action="/admin/schedules/save" method="post" modelAttribute="schedule">
                                        <div class="mb-3">
                                            <label class="form-label">Doctor</label>
                                            <form:select path="doctor" cssClass="form-select">
                                                <form:option value="" label="-- Select Doctor --" />
                                                <c:forEach var="doc" items="${doctors}">
                                                    <form:option value="${doc.doctorID}">
                                                        Dr. ${doc.user.firstName} ${doc.user.lastName} (ID:
                                                        ${doc.doctorID})
                                                    </form:option>
                                                </c:forEach>
                                            </form:select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Work Date</label>
                                            <form:input path="workDate" type="date" cssClass="form-control"
                                                required="true" />
                                            <form:errors path="workDate" cssClass="text-danger" />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Start Time</label>
                                            <form:input path="startTime" type="time" cssClass="form-control"
                                                required="true" />
                                            <form:errors path="startTime" cssClass="text-danger" />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">End Time</label>
                                            <form:input path="endTime" type="time" cssClass="form-control"
                                                required="true" />
                                            <form:errors path="endTime" cssClass="text-danger" />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Status</label>
                                            <form:select path="status" cssClass="form-select">
                                                <form:option value="" label="-- Select Status --" />
                                                <form:option value="Available">Available</form:option>
                                                <form:option value="Busy">not Available</form:option>
                                            </form:select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Max Patients</label>
                                            <form:input path="maxPatients" type="number" cssClass="form-control" />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Clinic Room</label>
                                            <form:input path="clinicRoom" cssClass="form-control" />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Notes</label>
                                            <form:textarea path="notes" cssClass="form-control" rows="3" />
                                        </div>
                                        <div class="d-grid mb-3">
                                            <button type="submit" class="btn btn-save">Save Schedule</button>
                                        </div>
                                    </form:form>
                                    <div class="d-grid">
                                        <a href="/admin/schedules/doctors" class="btn btn-back">← Back to List</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </body>

            </html>