package project.springBoot.service;

import java.util.List;
import java.util.Optional;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import project.springBoot.model.Doctor;
import project.springBoot.model.User;
import project.springBoot.repository.DoctorRepository;
import project.springBoot.repository.UserRepository;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private DoctorRepository doctorRepository;

    public User handleSaveUser(User user) {
        if (user.getUserID() == 0) {
            // This is a new user
            System.out.println("Saving new user: " + user.getEmail());
            String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            System.out.println("Generated password hash: " + hashed);
            user.setPassword(hashed);
        }
        return this.userRepository.save(user);
    }

    public List<User> getAllUser() {
        return this.userRepository.findAll();
    }

    public User getUserById(Long id) {
        return this.userRepository.findById(id).orElse(null);
    }

    public User getUserByEmailOrUsername(String email, String username) {
        return this.userRepository.findByEmailOrUsername(email, username);
    }

    public User handleUpdateUser(User user) {
        User existingUser = userRepository.findById(user.getUserID());
        if (existingUser != null) {
            // Only hash the password if it's different from the existing one
            if (!user.getPassword().equals(existingUser.getPassword()) && !isPasswordEncoded(user.getPassword())) {
                String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
                user.setPassword(hashed);
            }
        }
        return this.userRepository.save(user);
    }

    public void deleteUserById(Long id) {
        userRepository.deleteById(id);
    }

    public User login(String emailorusername, String password) {
        System.out.println("Login attempt with: " + emailorusername);
        User user = userRepository.findByEmailOrUsername(emailorusername, emailorusername);
        System.out.println("Found user: " + user);

        if (user != null) {
            System.out.println("User verified status: " + user.isVerified());
            System.out.println("Stored password hash: " + user.getPassword());
            System.out.println("Input password: " + password);

            if (!user.isVerified()) {
                System.out.println("User is not verified");
                return null;
            }

            boolean passwordMatch = BCrypt.checkpw(password, user.getPassword());
            System.out.println("Password match: " + passwordMatch);

            if (passwordMatch) {
                // If this is a doctor, ensure they have a doctor record
                if ("doctor".equalsIgnoreCase(user.getRole())) {
                    Long doctorId = getDoctorIdByUserId(user.getUserID());
                    if (doctorId == null) {
                        System.out.println("Doctor record not found for user: " + user.getUserID());
                        return null;
                    }
                }
                return user;
            }
        }
        return null;
    }

    private boolean isPasswordEncoded(String password) {
        return password != null && password.startsWith("$2a$");
    }

    public User getUserByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public User save(User user) {
        return userRepository.save(user);
    }

    public Long getDoctorIdByUserId(long userId) {
        return doctorRepository.findByUserUserID(userId)
                .map(Doctor::getDoctorID)
                .orElse(null);
    }
}
