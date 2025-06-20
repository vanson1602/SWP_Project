<%@ tag body-content="empty" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ attribute name="dateTime" required="true" type="java.time.LocalDateTime" %>
<%
    java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    String formattedDateTime = dateTime.format(formatter);
    jspContext.setAttribute("formattedDateTime", formattedDateTime);
%>
${formattedDateTime} 