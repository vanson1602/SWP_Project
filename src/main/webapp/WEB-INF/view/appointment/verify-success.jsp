<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="../shared/head.jsp" %>
        <%@ include file="../shared/header.jsp" %>
            <div class="container mt-5">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header bg-success text-white">
                                <h4>Xác thực thành công</h4>
                            </div>
                            <div class="card-body text-center">
                                <p class="fs-5">Lịch hẹn của bạn đã được xác thực thành công!</p>
                                <a href="/appointments/my-appointments" class="btn btn-primary mt-3">Quay lại lịch hẹn
                                    của tôi</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%@ include file="../shared/footer.jsp" %>