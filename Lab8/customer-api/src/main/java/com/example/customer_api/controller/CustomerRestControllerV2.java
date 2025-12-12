package com.example.customer_api.controller;

import com.example.customer_api.dto.CustomerResponseDTO;
import com.example.customer_api.service.CustomerService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v2/customers") 
public class CustomerRestControllerV2 {

    private final CustomerService customerService;

    public CustomerRestControllerV2(CustomerService customerService) {
        this.customerService = customerService;
    }

    // In V2, we improved the API for retrieving lists.
    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllCustomersV2(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String sortBy,
            @RequestParam(defaultValue = "asc") String sortDir) {

        Sort sort = sortDir.equalsIgnoreCase("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page, size, sort);
        
        Page<CustomerResponseDTO> customerPage = customerService.getAllCustomers(pageable);

        // --- DIFFERENCES OF V2 ---
        // New logic: Capitalize the customer's full name before returning the item.
        customerPage.getContent().forEach(customer -> {
            if (customer.getFullName() != null) {
                customer.setFullName(customer.getFullName().toUpperCase());
            }
        });
        // -----------------------------

        Map<String, Object> response = new HashMap<>();
        response.put("customers", customerPage.getContent());
        response.put("currentPage", customerPage.getNumber());
        response.put("totalItems", customerPage.getTotalElements());
        response.put("totalPages", customerPage.getTotalPages());
        response.put("apiVersion", "v2.0 (Enhanced)"); 

        return ResponseEntity.ok(response);
    }
    
    // ....
}