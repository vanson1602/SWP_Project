package project.springBoot.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import project.springBoot.model.Feedback;

@Repository
public interface FeedbackRepository extends JpaRepository<Feedback, Long> {
    List<Feedback> findByExamination_ExaminationID(long examinationID);

    List<Feedback> findByDoctor_DoctorIDAndIsApprovedTrue(long doctorID);

    boolean existsByExamination_ExaminationID(long examinationID);

    @Query("SELECT f FROM Feedback f WHERE f.doctor.doctorID = :doctorId")
    List<Feedback> findByDoctorId(@Param("doctorId") Long doctorId);

    @Query("SELECT f FROM Feedback f WHERE "
            + "(:doctorName IS NULL OR CONCAT(f.doctor.user.firstName, ' ', f.doctor.user.lastName) LIKE %:doctorName%) "
            + "AND (:rating IS NULL OR f.rating = :rating)")
    Page<Feedback> findByAdminFilters(@Param("doctorName") String doctorName,
            @Param("rating") Integer rating,
            Pageable pageable);

    @Query("SELECT f FROM Feedback f WHERE "
            + "f.doctor.doctorID = :doctorId AND (:rating IS NULL OR f.rating = :rating)")
    Page<Feedback> findByDoctorFilters(@Param("doctorId") Long doctorId,
            @Param("rating") Integer rating,
            Pageable pageable);

}
