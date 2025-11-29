package com.example.product_management.service;

import java.util.List;
import java.util.Optional;

import com.example.product_management.entity.Product;

public interface ProductService {
    
    List<Product> getAllProducts();
    
    Optional<Product> getProductById(Long id);
    
    Product saveProduct(Product product);
    
    void deleteProduct(Long id);
    
    List<Product> searchProducts(String keyword);
    
    List<Product> getProductsByCategory(String category);
}
