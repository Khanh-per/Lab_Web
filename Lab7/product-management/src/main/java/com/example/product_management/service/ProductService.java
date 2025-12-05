package com.example.product_management.service;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.example.product_management.entity.Product;

public interface ProductService {
    
    List<Product> getAllProducts();

    List<Product> getAllProducts(Sort sort);

    Optional<Product> getProductById(Long id);
    
    Product saveProduct(Product product);
    
    void deleteProduct(Long id);
    
    List<Product> searchProducts(String keyword);
    
    List<Product> getProductsByCategory(String category);

    List<Product> advancedSearch(String name, String category, java.math.BigDecimal minPrice, java.math.BigDecimal maxPrice);
    
    List<String> getAllCategories();

    Page<Product> searchProductsPaginated(String keyword, Pageable pageable);

    List<Product> getProducts(String category, String sortBy, String sortDir);
}
