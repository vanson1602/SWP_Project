<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5 text-center">
        <h1 class="text-danger mb-4">Đã xảy ra lỗi</h1>
        <p class="lead mb-4">${message}</p>
        <a href="/appointments" class="btn btn-primary">Quay lại trang lịch hẹn</a>
    </div>
</body>
</html>