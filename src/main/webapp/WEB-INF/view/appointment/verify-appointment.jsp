<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ include file="../shared/head.jsp" %>
            <%@ include file="../shared/header.jsp" %>
                <div class="container mt-5">
                    <div class="row justify-content-center">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <h4>Xác thực lịch hẹn</h4>
                                </div>
                                <div class="card-body">
                                    <form method="post" action="/appointments/verify">
                                        <div class="mb-3">
                                            <label for="verifyCode" class="form-label">Mã xác thực lịch hẹn</label>
                                            <input type="text" class="form-control" id="verifyCode" name="verifyCode"
                                                required placeholder="Nhập mã xác thực...">
                                        </div>
                                        <button type="submit" class="btn btn-primary">Xác nhận</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%@ include file="../shared/footer.jsp" %>