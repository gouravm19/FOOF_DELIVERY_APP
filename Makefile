# ════════════════════════════════════════════════════════════
# FOOD DELIVERY PLATFORM - MAKEFILE
# ════════════════════════════════════════════════════════════

.PHONY: help start stop restart logs clean build test seed db-shell mongo-shell redis-cli kafka-ui api-docs status

# Colors for output
GREEN=\033[0;32m
YELLOW=\033[1;33m
RED=\033[0;31m
NC=\033[0m # No Color

help: ## Show this help message
	@echo "$(GREEN)════════════════════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)  FOOD DELIVERY PLATFORM - AVAILABLE COMMANDS$(NC)"
	@echo "$(GREEN)════════════════════════════════════════════════════════════$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'

start: ## Start all services (builds if needed)
	@echo "$(GREEN)🚀 Starting all services...$(NC)"
	@cp -n .env.example .env 2>/dev/null || true
	docker-compose up --build -d
	@echo "$(GREEN)✅ All services started!$(NC)"
	@echo "$(YELLOW)Customer App:        http://localhost:3000$(NC)"
	@echo "$(YELLOW)Restaurant Portal:   http://localhost:3001$(NC)"
	@echo "$(YELLOW)Delivery App:        http://localhost:3002$(NC)"
	@echo "$(YELLOW)Admin Console:       http://localhost:3003$(NC)"
	@echo "$(YELLOW)API Gateway:         http://localhost:8080$(NC)"
	@echo "$(YELLOW)Eureka Dashboard:    http://localhost:8761$(NC)"
	@echo "$(YELLOW)Kafka UI:            http://localhost:8090$(NC)"
	@echo "$(YELLOW)MailHog:             http://localhost:8025$(NC)"
	@echo "$(YELLOW)MinIO Console:       http://localhost:9001$(NC)"
	@echo "$(YELLOW)Zipkin:              http://localhost:9411$(NC)"
	@echo "$(YELLOW)Kibana:              http://localhost:5601$(NC)"
	@echo "$(YELLOW)Grafana:             http://localhost:3004$(NC)"

stop: ## Stop all services
	@echo "$(RED)🛑 Stopping all services...$(NC)"
	docker-compose down
	@echo "$(GREEN)✅ All services stopped$(NC)"

restart: ## Restart all services
	@echo "$(YELLOW)🔄 Restarting all services...$(NC)"
	$(MAKE) stop
	$(MAKE) start

logs: ## Show logs from all services (follow mode)
	docker-compose logs -f

logs-backend: ## Show logs from all backend services
	docker-compose logs -f user-service restaurant-service order-service payment-service delivery-service notification-service

logs-user: ## Show logs from user-service
	docker-compose logs -f user-service

logs-restaurant: ## Show logs from restaurant-service
	docker-compose logs -f restaurant-service

logs-order: ## Show logs from order-service
	docker-compose logs -f order-service

clean: ## Stop and remove all containers, volumes, and networks (NUCLEAR OPTION)
	@echo "$(RED)💣 Cleaning everything (containers, volumes, networks)...$(NC)"
	@read -p "Are you sure? This will DELETE ALL DATA [y/N]: " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker-compose down -v --remove-orphans; \
		echo "$(GREEN)✅ Everything cleaned$(NC)"; \
	else \
		echo "$(YELLOW)Cancelled$(NC)"; \
	fi

build: ## Build all services without starting
	@echo "$(GREEN)🔨 Building all services...$(NC)"
	docker-compose build
	@echo "$(GREEN)✅ Build complete$(NC)"

test: ## Run all backend tests
	@echo "$(GREEN)🧪 Running all tests...$(NC)"
	mvn clean test

test-coverage: ## Run tests with coverage report
	@echo "$(GREEN)🧪 Running tests with coverage...$(NC)"
	mvn clean test jacoco:report

seed: ## Seed databases with demo data
	@echo "$(GREEN)🌱 Seeding databases...$(NC)"
	@sleep 5
	@docker-compose exec user-service curl -X POST http://localhost:8081/api/v1/seed || echo "Seed will run on startup"
	@echo "$(GREEN)✅ Seed complete$(NC)"

db-shell: ## Connect to PostgreSQL shell
	@echo "$(GREEN)🐘 Connecting to PostgreSQL...$(NC)"
	docker-compose exec postgres psql -U fooddelivery -d fooddelivery

mongo-shell: ## Connect to MongoDB shell
	@echo "$(GREEN)🍃 Connecting to MongoDB...$(NC)"
	docker-compose exec mongodb mongosh -u admin -p mongo_secure_password_2024 --authenticationDatabase admin fooddelivery

redis-cli: ## Connect to Redis CLI
	@echo "$(GREEN)🔴 Connecting to Redis...$(NC)"
	docker-compose exec redis redis-cli -a redis_secure_password_2024

kafka-ui: ## Open Kafka UI in browser
	@echo "$(GREEN)📊 Opening Kafka UI...$(NC)"
	@open http://localhost:8090 || xdg-open http://localhost:8090 || echo "Open http://localhost:8090 in your browser"

api-docs: ## Open API documentation (Swagger)
	@echo "$(GREEN)📚 Opening API Documentation...$(NC)"
	@open http://localhost:8080/swagger-ui.html || xdg-open http://localhost:8080/swagger-ui.html || echo "Open http://localhost:8080/swagger-ui.html in your browser"

status: ## Check status of all services
	@echo "$(GREEN)📊 Service Status:$(NC)"
	@docker-compose ps

ps: status ## Alias for status

prune: ## Remove unused Docker resources
	@echo "$(YELLOW)🧹 Pruning unused Docker resources...$(NC)"
	docker system prune -f
	@echo "$(GREEN)✅ Prune complete$(NC)"

# Default target
.DEFAULT_GOAL := help