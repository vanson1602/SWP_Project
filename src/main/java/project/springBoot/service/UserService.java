package project.springBoot.service;

import java.util.List;

import org.springframework.stereotype.Service;

import project.springBoot.model.User;
import project.springBoot.repository.UserRepository;

@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
    
    public User handleSaveUser(User user){
        User newUser = this.userRepository.save(user);
        return newUser;
    }

    public List<User> getAllUser(){
        return this.userRepository.findAll();
    }

    public User getUserById(long id){
        return this.userRepository.findById(id);
    }
}
