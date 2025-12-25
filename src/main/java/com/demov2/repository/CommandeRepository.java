package com.demov2.repository;

import com.demov2.entity.Commande;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommandeRepository extends JpaRepository<Commande , Long> {


    List<Commande> findCommandeByQuantiteGreaterThan(int quantiteIsGreaterThan);

    List<Commande> findCommandeByQuantiteGreaterThanEqual(int quantiteIsGreaterThan);

    List<Commande> findCommandeByPrixIsLessThan(double prixIsGreaterThan);

    List<Commande> findCommandeByPrixIsLessThanEqual(double prixIsGreaterThan);

    List<Commande> findCommandeByTotalTtcIsBetween(double totalTtcAfter, double totalTtcBefore);

    List<Commande> findCommandeByQuantiteGreaterThanAndPrixLessThan(int quantiteIsGreaterThan, double prixIsLessThan);

    List<Commande> findAllByOrderByTotalTtcDesc();

    List<Commande> findTop3ByOrderByTotalTtcDesc();


    @Query("Select c FROM Commande c WHERE c.prix=:prixMax AND c.quantite=:qte")
    List<Commande> findByQuantiteAndPrix(
            @Param("qte") Integer quantite,
            @Param("prixMax") Double prixMax);


    @Query("SELECT c FROM Commande c JOIN FETCH Produit p WHERE p.nom In :produits")
    List<Commande> findByProduitsIn(@Param("produits") List<String> produits);
}
