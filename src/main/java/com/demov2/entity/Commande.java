package com.demov2.entity;


import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Commande {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String produitNom;

    private int quantite;

    private double prix;

    private double totalHt;

    private int tva;

    private double totalTtc;


    @ManyToOne
    @JoinColumn(name = "client_id")
    @JsonIgnore
    private Client client;


}
