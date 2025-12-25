package com.demov2.service;


import com.demov2.entity.Client;

import java.util.List;

public interface ClientService {
    public List<Client> getClientByName(String nom);
    public List<Client> getClientByNameAndSurname(String nom,String prenom);
    public List<Client> getClientByNameOrSurname(String nom,String prenom);
    public List<Client> getClientByAdresseLike(String adresse);
    public List<Client> getClientByAdresseLikeIgnoreCase(String adresse);
    public List<Client> getClientByNomEndsWith(String nom);
    public List<Client> getClientByNomStartsWith(String nom);
    public List<Client> getClientByNomSortAsc(String nom);

}
