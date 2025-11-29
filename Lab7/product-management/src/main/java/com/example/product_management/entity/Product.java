package com.example.product_management.entity;

import jakarta.persistence.*;
import lombok.*; // Import Lombok
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "products")
@Data                 // Getters, Setters, toString, equals, and hashCode
@NoArgsConstructor    //  the empty constructor (Required by JPA)
@AllArgsConstructor   //  the constructor with all fields
public class Product {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "product_code", unique = true, nullable = false, length = 20)
    private String productCode;
    
    @Column(nullable = false, length = 100)
    private String name;
    
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;
    
    @Column(nullable = false)
    private Integer quantity;
    
    @Column(length = 50)
    private String category;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    // You still keep custom logic like this, Lombok doesn't replace it
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }
}