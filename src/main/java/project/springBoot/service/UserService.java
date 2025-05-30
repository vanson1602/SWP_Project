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

    // public User handleSaveUser(User user){
    // String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
    // user.setPassword(hashed);
    // User newUser = this.userRepository.save(user);
    // return newUser;
    // }

    public List<User> getAllUser() {
        return this.userRepository.findAll();
    }

    public User getUserById(long id) {
        return this.userRepository.findById(id);
    }

    public User getUserByEmailOrUsername(String email, String username) {
        return this.userRepository.findByEmailOrUsername(email, username);
    }

    // public User handleUpdateUser(User user){
    // String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
    // user.setPassword(hashed);
    // return this.userRepository.save(user);
    // }

    public void deleteUserById(Long id) {
        userRepository.deleteById(id);
    }

    public User login(String emailorusername, String Password) {
        User user = userRepository.findByEmailOrUsername(emailorusername, emailorusername);
        if (user != null) {
            if (BCrypt.checkpw(Password, user.getPassword())) {
                return user;
            }
        }
        return null;
    }

    private boolean isPasswordEncoded(String password) {
        return password != null && password.startsWith("$2a$") || password.startsWith("$2b$")
                || password.startsWith("$2y$");
    }

    public User handleSaveUser(User user) {
        if (!isPasswordEncoded(user.getPassword())) {
            String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            user.setPassword(hashed);
        }
        return this.userRepository.save(user);
    }

    public User handleUpdateUser(User user) {
        if (!isPasswordEncoded(user.getPassword())) {
            String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            user.setPassword(hashed);
        }
        return this.userRepository.save(user);
    }

    public User getUserByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }
}
