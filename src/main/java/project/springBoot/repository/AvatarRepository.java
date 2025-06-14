package project.springBoot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import project.springBoot.model.Avatar;

@Repository
public interface AvatarRepository extends JpaRepository<Avatar, Long> {
}