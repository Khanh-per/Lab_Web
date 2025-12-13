package com.example.customer_api.config;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class RateLimitInterceptor implements HandlerInterceptor {
    
    private final Map<String, Bucket> cache = new ConcurrentHashMap<>();
    
    @Override
    public boolean preHandle(HttpServletRequest request, 
                             HttpServletResponse response, 
                             Object handler) throws Exception {
        
        String key = request.getRemoteAddr();// Identify user by IP address

        // Get or create a bucket for this IP
        Bucket bucket = cache.computeIfAbsent(key, k -> createNewBucket());
        
        // Try to consume 1 token
        if (bucket.tryConsume(1)) {
            return true; //Success, proceed to Controller
        }
        
        response.setStatus(429);
        response.getWriter().write("Too many requests");
        return false;
    }
    
    private Bucket createNewBucket() {
        
    // Rule: 100 requests allowed per 1 minute
    return Bucket.builder()
        .addLimit(Bandwidth.simple(2, Duration.ofMinutes(1)))
        .build();
    }

}