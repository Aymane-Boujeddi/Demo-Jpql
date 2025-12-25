package com.demov2.service.impl;

import com.demov2.entity.Client;
import com.demov2.repository.ClientRepository;
import com.demov2.service.ClientService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ClientServiceImpl implements ClientService {

    private final ClientRepository clientRepository;


    public List<Client> getClientByName(String nom){
        return clientRepository.findClientByNom(nom);
    }

    public List<Client> getClientByNameAndSurname(String nom,String prenom){
        return clientRepository.findClientByNomAndPrenom(nom,prenom);
    }

    public List<Client> getClientByNameOrSurname(String nom,String prenom){
        return clientRepository.findClientByNomOrPrenom(nom,prenom);
    }

    public List<Client> getClientByAdresseLike(String adresse){
        return clientRepository.findClientByAdresseLike(adresse);
    }

    @Override
    public List<Client> getClientByAdresseLikeIgnoreCase(String adresse) {
        return clientRepository.findClientByAdresseContaining(adresse);
    }

    @Override
    public List<Client> getClientByNomEndsWith(String nom) {
        return clientRepository.findClientByNomEndingWith(nom);
    }

    @Override
    public List<Client> getClientByNomStartsWith(String nom) {
        return clientRepository.findClientByNomStartingWith(nom);
    }

    @Override
    public List<Client> getClientByNomSortAsc(String nom) {
        return clientRepository.findByNomOrderByPrenomAsc(nom);
    }


}
