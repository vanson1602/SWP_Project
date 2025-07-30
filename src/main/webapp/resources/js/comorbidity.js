function loadPatientComorbidities() {
    // Lấy patientId từ hidden input
    const patientIdInput = document.getElementById("currentPatientId");
    const patientId = patientIdInput ? patientIdInput.value : null;
    console.log("Loading comorbidities for patient:", patientId);

    if (!patientId || patientId.trim() === "") {
        console.error("Patient ID is invalid:", patientId);
        showError("ID bệnh nhân không hợp lệ");
        return;
    }

    loadComorbidities(patientId);
}

function showError(message) {
    const content = document.getElementById("comorbidityContent");
    if (content) {
        content.innerHTML = `
            <div class="empty-state">
                <i class="bi bi-exclamation-triangle text-danger"></i>
                <p>${message}</p>
            </div>
        `;
    }
}

async function loadComorbidities(patientId) {
    if (!patientId || patientId.trim() === "") {
        console.error("Invalid patient ID:", patientId);
        showError("ID bệnh nhân không hợp lệ");
        return;
    }

    const loadingSpinner = document.getElementById("comorbidityLoadingSpinner");
    const comorbidityList = document.querySelector(".comorbidity-list");
    const content = document.getElementById("comorbidityContent");

    try {
        console.log("Fetching comorbidities for patient ID:", patientId);
        loadingSpinner.style.display = "flex";
        comorbidityList.style.display = "none";

        const response = await fetch(`/patients/${patientId}/comorbidities`);
        console.log("Response status:", response.status);

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const html = await response.text();
        console.log("Received HTML response");

        loadingSpinner.style.display = "none";
        comorbidityList.style.display = "block";
        content.innerHTML = html;
    } catch (error) {
        console.error("Error loading comorbidities:", error);
        loadingSpinner.style.display = "none";
        comorbidityList.style.display = "block";
        showError("Có lỗi xảy ra khi tải thông tin bệnh nền");
    }
}

// Thêm event listener khi document ready
document.addEventListener("DOMContentLoaded", function () {
    // Thêm event listener cho tab bệnh nền
    const comorbidityTab = document.getElementById("comorbidity-tab");
    if (comorbidityTab) {
        comorbidityTab.addEventListener("click", function () {
            loadPatientComorbidities();
        });
    }

    // Kiểm tra nếu đang ở tab bệnh nền thì load dữ liệu
    if (window.location.hash === "#comorbidity") {
        loadPatientComorbidities();
    }
});
