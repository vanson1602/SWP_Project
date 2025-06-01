package project.springBoot.service;

import java.util.List;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

import project.springBoot.model.User;
import project.springBoot.repository.UserRepository;

@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User handleSaveUser(User user) {
        System.out.println("Saving new user: " + user.getEmail());
        String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        System.out.println("Generated password hash: " + hashed);
        user.setPassword(hashed);
        return this.userRepository.save(user);
    }

    public List<User> getAllUser() {
        return this.userRepository.findAll();
    }

    public User getUserById(long id) {
        return this.userRepository.findById(id);
    }

    public User getUserByEmailOrUsername(String email, String username) {
        return this.userRepository.findByEmailOrUsername(email, username);
    }

    public User handleUpdateUser(User user) {
        if (!isPasswordEncoded(user.getPassword())) {
            String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            user.setPassword(hashed);
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
                return user;
            }
        }
        return null;
    }

    private boolean isPasswordEncoded(String password) {
        return password != null && (password.startsWith("$2a$") || password.startsWith("$2b$")
                || password.startsWith("$2y$"));
    }

    public User getUserByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }
}
