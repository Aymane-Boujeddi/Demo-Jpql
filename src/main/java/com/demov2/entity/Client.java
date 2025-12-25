package com.demov2.entity;



import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Client {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Id;


    private String nom;

    private String prenom;

    private String adresse;


    @OneToMany(mappedBy = "client")
    private List<Commande> commandes;
}
