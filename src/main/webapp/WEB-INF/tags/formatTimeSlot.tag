<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="startTime" required="true" type="java.time.LocalDateTime" %>

<fmt:formatDate value="${startTime.toLocalDate().toDate()}" pattern="dd/MM/yyyy"/> 
<c:set var="endHour" value="${startTime.hour + 1}"/>
${String.format("%02d:00", startTime.hour)} - ${String.format("%02d:00", endHour)} 