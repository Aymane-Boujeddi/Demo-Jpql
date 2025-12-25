package com.demov2.service.impl;

import com.demov2.repository.CommandeRepository;
import com.demov2.service.CommandeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CommandeServiceImpl implements CommandeService {

    private final CommandeRepository commandeRepository;



}
