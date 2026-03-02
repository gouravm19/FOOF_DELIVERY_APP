package com.gouravmishra.fooddelivery.eureka;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

/**
 * Eureka Server - Service Discovery
 * 
 * This service acts as a registry where all microservices register themselves.
 * It enables service-to-service communication without hardcoded URLs.
 * 
 * @author Gourav Mishra
 * @email gauravmishra19995@gmail.com
 */
@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {

    public static void main(String[] args) {
        SpringApplication.run(EurekaServerApplication.class, args);
    }

}