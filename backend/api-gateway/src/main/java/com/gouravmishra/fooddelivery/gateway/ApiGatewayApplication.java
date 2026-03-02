package com.gouravmishra.fooddelivery.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

/**
 * API Gateway - Central entry point for all microservices
 * 
 * Responsibilities:
 * - Route requests to appropriate microservices
 * - JWT validation
 * - Rate limiting
 * - CORS handling
 * - Load balancing
 * 
 * @author Gourav Mishra
 * @email gauravmishra19995@gmail.com
 */
@SpringBootApplication
@EnableEurekaClient
public class ApiGatewayApplication {

    public static void main(String[] args) {
        SpringApplication.run(ApiGatewayApplication.class, args);
    }

}