package com.demov2.repository;

import com.demov2.entity.Client;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface ClientRepository extends JpaRepository<Client,Long> {

    List<Client> findClientByNom(String nom);

    List<Client> findClientByNomAndPrenom(String nom, String prenom);

    List<Client> findClientByNomOrPrenom(String nom, String prenom);

    List<Client> findClientByAdresseContaining(String adresse);

    List<Client> findClientByAdresseLikeIgnoreCase(String adresse);


    List<Client> findClientByNomStartingWith(String nom);

    List<Client> findClientByNomEndingWith(String nom);

    List<Client> findClientByAdresseLike(String adresse);


    List<Client> findByNomOrderByPrenomAsc(String nom);

    Long countClientByNom(String nom);

    long countClientByNomIgnoreCase(String nom);

    long countClientByAdresseContainsIgnoreCase(String adresse);

    long countClientByAdresseLike(String adresse);

    boolean existsByNom(String nom);

    boolean existsByNomAndPrenom(String nom, String prenom);

    @Query("SELECT c FROM  Client c WHERE c.nom=:nom")
    List<Client> findClientsByNom(@Param("nom")String nom);

    @Query("SELECT c FROM Client c WHERE c.nom=?1 AND c.prenom=?2")
    List<Client> findClientByNomEtPrenom(String nom,String prenom);

    @Query("SELECT c FROM Client c WHERE c.adresse like concat('%',:ville ,'%')")
    List<Client> findClientByVilleLike(@Param("ville") String ville);
}
