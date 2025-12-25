package com.demov2.controller;

import com.demov2.entity.Client;
import com.demov2.repository.ClientRepository;
import com.demov2.service.ClientService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequiredArgsConstructor
@RequestMapping("/client")
public class ClientController {

    private final ClientService clientService;

    private final ClientRepository clientRepository;


    @GetMapping("/nom/{nom}")
    public ResponseEntity<List<Client>> getClientsByName(@PathVariable String nom){
        return ResponseEntity.ok(clientService.getClientByName(nom));
    }
    @GetMapping("/nomTri/{nom}")
    public ResponseEntity<List<Client>> getClientsByNameSort(@PathVariable String nom){
        return ResponseEntity.ok(clientService.getClientByNomSortAsc(nom));
    }

    @GetMapping("/nomPrenom")
    public ResponseEntity<List<Client>> getClientByNameAndSurname(@RequestParam String nom , @RequestParam String prenom ){
        return ResponseEntity.ok(clientService.getClientByNameAndSurname(nom,prenom));
    }

    @GetMapping("/nomOrPrenom")
    public ResponseEntity<List<Client>> getClientByNameOrSurname(@RequestParam(required = false) String nom,@RequestParam(required = false) String prenom) {
        return ResponseEntity.ok(clientService.getClientByNameOrSurname(nom,prenom));
    }

    @GetMapping("/adresse/{adresse}")
    public ResponseEntity<List<Client>> getClientByAdresseLike(@PathVariable String adresse){
        return ResponseEntity.ok(clientService.getClientByAdresseLike(adresse));
    }

    @GetMapping("/adresseCase/{adresse}")
    public ResponseEntity<List<Client>> getClientByAdresseLikeIgnoreCase(@PathVariable String adresse){
        return ResponseEntity.ok(clientService.getClientByAdresseLikeIgnoreCase(adresse));
    }

    @GetMapping("/nomEnd/{nom}")
    public ResponseEntity<List<Client>> getClientByNomEndsWith(@PathVariable String nom){
        return ResponseEntity.ok(clientService.getClientByNomEndsWith(nom));
    }

    @GetMapping("/nomStart/{nom}")
    public ResponseEntity<List<Client>> getClientByNomStartsWith(@PathVariable String nom){
        return ResponseEntity.ok(clientService.getClientByNomStartsWith(nom));
    }

    @GetMapping("/countNom")
    public ResponseEntity<Long> countByNom(@RequestParam String nom){
        return ResponseEntity.ok(clientRepository.countClientByAdresseLike("%" + nom + "%"));
    }

    @GetMapping("/existByNom")
    public ResponseEntity<Boolean> exiistBYName(@RequestParam String nom){
        return ResponseEntity.ok(clientRepository.existsByNomAndPrenom(nom,"Prenom1"));
    }



}
