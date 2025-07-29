<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ include file="../shared/head.jsp" %>
                <%@ include file="../shared/header.jsp" %>

                    <div class="container mt-5">
                        <div class="card">
                            <div class="card-header bg-danger text-white">
                                <h4>Xác nhận hủy lịch hẹn</h4>
                            </div>
                            <div class="card-body">
                                <form method="post" action="/appointments/${appointment.appointmentID}/cancel">
                                    <div class="mb-3">
                                        <label for="reason" class="form-label">Lý do hủy lịch <span
                                                class="text-danger">*</span></label>
                                        <textarea class="form-control" id="reason" name="reason" rows="3" required
                                            placeholder="Nhập lý do hủy..."></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <strong>Bác sĩ:</strong> ${appointment.doctor.user.fullName}<br />
                                        <strong>Thời gian:</strong>
                                        <fmt:formatDate value="${appointment.appointmentDate}"
                                            pattern="HH:mm dd/MM/yyyy" />
                                    </div>
                                    <button type="submit" class="btn btn-danger">Xác nhận hủy</button>
                                    <a href="/appointments/my-appointments" class="btn btn-secondary ms-2">Quay lại</a>
                                </form>
                            </div>
                        </div>
                    </div>

                    <%@ include file="../shared/footer.jsp" %>