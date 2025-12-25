package com.demov2.controller;

import com.demov2.entity.Commande;
import com.demov2.repository.CommandeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/commande")
public class CommandeController {

    private final CommandeRepository commandeRepository;


    @GetMapping("/quantite/{x}")
    public ResponseEntity<List<Commande>> getCommandeByQuantiteSup(@PathVariable int x){
        return ResponseEntity.ok(commandeRepository.findCommandeByQuantiteGreaterThan(x));
    }

    @GetMapping("/quantiteEq/{x}")
    public ResponseEntity<List<Commande>> getCommandeByQuantiteSupOrEqual(@PathVariable int x){
        return ResponseEntity.ok(commandeRepository.findCommandeByQuantiteGreaterThanEqual(x));

    }

    @GetMapping("/prix/{x}")
    public ResponseEntity<List<Commande>> getCommandeByPrixInf(@PathVariable Double x){
        return ResponseEntity.ok(commandeRepository.findCommandeByPrixIsLessThan(x));
    }

    @GetMapping("/prixEq/{x}")
    public ResponseEntity<List<Commande>> getCommandeByPrixInfOrEqual(@PathVariable Double x){
        return ResponseEntity.ok(commandeRepository.findCommandeByPrixIsLessThanEqual(x));
    }

    @GetMapping("/total")
    public ResponseEntity<List<Commande>> getCommandeByTotalBetween(@RequestParam Double first,@RequestParam Double second){
        return ResponseEntity.ok(commandeRepository.findCommandeByTotalTtcIsBetween(first,second));
    }

    @GetMapping("/quantPrix")
    public ResponseEntity<List<Commande>> getCommandeByQuantiteSupAndPrixInf(@RequestParam int quantite,@RequestParam Double prix){
        return ResponseEntity.ok(commandeRepository.findCommandeByQuantiteGreaterThanAndPrixLessThan(quantite,prix));
    }

    @GetMapping("/Tri")
    public ResponseEntity<List<Commande>> TriCommande(){
        PageRequest pageRequest =
                PageRequest.of(0, 4, Sort.by(Sort.Direction.DESC, "totalTtc"));

        List<Commande> commandes = commandeRepository
                .findAll(pageRequest)
                .getContent();
//        return ResponseEntity.ok(commandeRepository.findTop3ByOrderByTotalTtcDesc());
        return ResponseEntity.ok(commandes);
    }

    @GetMapping("/Tri/{top}")
    public ResponseEntity<List<Commande>> commandeTriTop(@PathVariable int top){
        PageRequest pageRequest =
                PageRequest.of(0, top, Sort.by(Sort.Direction.DESC, "totalTtc"));

        List<Commande> commandes = commandeRepository
                .findAll(pageRequest)
                .getContent();
        return ResponseEntity.ok(commandes);
    }



}
