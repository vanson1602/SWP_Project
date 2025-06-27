package project.springBoot.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import project.springBoot.model.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User save(User user);

    List<User> findAll();

    User findById(long id);

    User findByEmailOrUsername(String email, String username);

    Optional<User> findByUsername(String username);

    User findByEmail(String email);

    User findByEmailAndPassword(String email, String password);

    User findByUsernameAndPassword(String username, String password);

    void deleteById(Long id);

    User findByVerificationToken(String token);

    Optional<User> findUserByEmail(String email);

}