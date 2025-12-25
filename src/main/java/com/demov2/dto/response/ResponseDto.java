package com.demov2.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ResponseDto {

    private String produitNom;

    private int quantite;

    private double prix;

    private double totalHt;

    private int tva;

    private double totalTtc;
}
