package project.springBoot.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import project.springBoot.model.Avatar;
import project.springBoot.repository.AvatarRepository;

@Service
public class AvatarService {
    @Autowired
    private AvatarRepository avatarRepository;

    public Avatar save(Avatar avatar) {
        return avatarRepository.save(avatar);
    }

    public void delete(Avatar avatar) {
        avatarRepository.delete(avatar);
    }
}