<% @page contentType = "text/html" pageEncoding = "UTF-8" %>
<% @taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

    <c:choose>
        <c:when test="${hasError}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle me-2"></i>${errorMessage}
            </div>
        </c:when>
        <c:when test="${hasComorbidities}">
            <div class="comorbidity-items">
                <c:forEach items="${comorbidities}" var="comorbidity">
                    <div class="comorbidity-item mb-3 p-3 border rounded">
                        <h5 class="mb-2">${comorbidity.name}</h5>
                        <p class="mb-2"><strong>Mô tả:</strong> ${comorbidity.description}</p>
                        <p class="mb-1"><strong>Ngày phát hiện:</strong> ${comorbidity.diagnosisDate}</p>
                        <p class="mb-0"><strong>Ghi chú:</strong> ${comorbidity.notes}</p>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state text-center py-4">
                <i class="bi bi-clipboard-x fs-1 text-muted mb-3"></i>
                <p class="text-muted">Bệnh nhân không có bệnh nền nào được ghi nhận.</p>
            </div>
        </c:otherwise>
    </c:choose> 