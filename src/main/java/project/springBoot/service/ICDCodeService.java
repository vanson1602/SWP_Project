package project.springBoot.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import project.springBoot.model.ICDCode;
import project.springBoot.repository.ICDCodeRepository;

@Service
public class ICDCodeService {

    @Autowired
    private ICDCodeRepository icdCodeRepository;

    public List<ICDCode> getAllActiveCodes() {
        return icdCodeRepository.findAll();
    }

    public ICDCode findById(String icdCode) {
        return icdCodeRepository.findById(icdCode).orElse(null);
    }
} 