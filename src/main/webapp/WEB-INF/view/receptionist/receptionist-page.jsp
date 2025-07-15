<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %> <%@ taglib
prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Receptionist Portal</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        padding: 40px;
        background-color: #f5f5f5;
      }

      h1 {
        color: #333;
        margin-bottom: 30px;
      }

      .btn {
        display: inline-block;
        padding: 12px 24px;
        margin-right: 15px;
        background-color: #3498db;
        color: white;
        text-decoration: none;
        border-radius: 6px;
        font-weight: bold;
        transition: background-color 0.3s ease;
      }

      .btn:hover {
        background-color: #2980b9;
      }
    </style>
  </head>
  <body>
    <h1>Receptionist Portal</h1>

    <a href="/booking-receptionist/step-1" class="btn">➕ Booking Here</a>
    <a href="/booking-receptionist/patientInfor" class="btn"
      >👥 View Patients</a
    >
  </body>
</html>
