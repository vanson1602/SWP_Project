<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %> <%@ taglib
prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
  </head>
  <body>
    <div class="container my-5">
      <div class="row justify-content-center">
        <div class="col-lg-8">
          <div class="card shadow rounded-4 p-4">
            <h3 class="text-center text-primary mb-4">
              <i class="bi bi-calendar-check me-2"></i>Tạo lịch hẹn
            </h3>

            <!-- Hiển thị thông báo -->
            <c:if test="${not empty error}">
              <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
              <div class="alert alert-success">${success}</div>
            </c:if>

            <!-- Bước 1: Nhập email và chọn bác sĩ -->
            <form method="get" action="/booking-receptionist" id="step1Form">
              <div class="mb-3">
                <label class="form-label">Email bệnh nhân:</label>
                <input
                  type="email"
                  name="email"
                  class="form-control"
                  required
                  value="${param.email}"
                />
              </div>

              <label class="form-label mt-3">Chọn bác sĩ:</label>
              <div class="row row-cols-1 row-cols-md-2 g-3">
                <c:forEach var="doc" items="${doctors}">
                  <div class="col">
                    <div
                      class="card card-option ${selectedDoctorID eq doc.doctorID ? 'selected' : ''}"
                      data-doctor-id="${doc.doctorID}"
                    >
                      <div class="card-body">
                        <h6 class="card-title">
                          ${doc.user.firstName} ${doc.user.lastName}
                        </h6>
                        <p class="card-text text-muted">
                          <i class="bi bi-person-badge me-1"></i>
                          ${doc.qualification}
                        </p>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </div>

              <input
                type="hidden"
                name="doctorID"
                id="selectedDoctorIDInput"
                value="${selectedDoctorID}"
              />
            </form>

            <script>
              document.querySelectorAll(".card-option").forEach((card) => {
                card.addEventListener("click", function () {
                  const doctorID = this.getAttribute("data-doctor-id");
                  document.getElementById("selectedDoctorIDInput").value =
                    doctorID;
                  document.getElementById("step1Form").submit();
                });
              });
            </script>

            <!-- Bước 2: Chọn loại lịch hẹn và khung giờ -->
            <c:if
              test="${not empty param.email and not empty selectedDoctorID}"
            >
              <form method="post" action="/booking-receptionist" class="mt-4">
                <input type="hidden" name="email" value="${param.email}" />
                <input
                  type="hidden"
                  name="doctorID"
                  value="${selectedDoctorID}"
                />

                <label class="form-label">Loại lịch hẹn:</label>
                <div class="row row-cols-1 row-cols-md-2 g-3 mb-3">
                  <c:forEach var="type" items="${appointmentTypes}">
                    <div class="col">
                      <label class="card card-option">
                        <input
                          type="radio"
                          name="appointmentTypeID"
                          value="${type.appointmentTypeID}"
                          required
                        />
                        <div class="card-body">
                          <h6 class="card-title">${type.typeName}</h6>
                          <p class="card-text text-muted">
                            ${type.description}
                          </p>
                        </div>
                      </label>
                    </div>
                  </c:forEach>
                </div>

                <label class="form-label">Khung giờ:</label>
                <div class="row row-cols-1 row-cols-md-2 g-3 mb-3">
                  <c:forEach var="slot" items="${availableSlots}">
                    <div class="col">
                      <label class="card card-option">
                        <input
                          type="radio"
                          name="slotID"
                          value="${slot.slotID}"
                          required
                        />
                        <div class="card-body">
                          <h6 class="card-title">
                            <i class="bi bi-clock"></i> ${slot.startTime} -
                            ${slot.endTime}
                          </h6>
                        </div>
                      </label>
                    </div>
                  </c:forEach>
                </div>

                <div class="mb-3">
                  <label class="form-label">Ghi chú thêm:</label>
                  <textarea
                    name="patientNote"
                    class="form-control"
                    rows="3"
                    placeholder="Ghi chú thêm (nếu có)..."
                  ></textarea>
                </div>

                <div class="text-end">
                  <button type="submit" class="btn btn-success px-4">
                    <i class="bi bi-check-circle me-1"></i>Đặt lịch
                  </button>
                </div>
              </form>

              <script>
                // Highlight selected radio card
                document
                  .querySelectorAll('.card-option input[type="radio"]')
                  .forEach((radio) => {
                    radio.addEventListener("change", () => {
                      document
                        .querySelectorAll(".card-option")
                        .forEach((card) => card.classList.remove("selected"));
                      if (radio.checked) {
                        radio.closest(".card-option").classList.add("selected");
                      }
                    });
                  });
              </script>
            </c:if>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
