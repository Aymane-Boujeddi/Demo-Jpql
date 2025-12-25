# Demo JPQL Project

A simple Spring Boot application with MySQL, Docker, and SonarQube integration.

## 🚀 Quick Start

### 1. Run with Docker Compose (Easiest - Everything Together!)
```powershell
# Start all services (SonarQube, MySQL, Your App)
docker-compose up -d

# View at:
# - Your App: http://localhost:8080/demo
# - SonarQube: http://localhost:9000
# - MySQL: localhost:3306

# Stop all services
docker-compose down
```

### 2. Run Locally (Development)
```powershell
mvn clean install
mvn spring-boot:run
```

### 3. Run with Docker (App Only)
```powershell
mvn clean package
docker build -t demov2:latest .
docker run -p 8080:8080 demov2:latest
```

### 4. Run SonarQube Analysis
```powershell
# Start SonarQube first
docker-compose up -d sonarqube

# Then run analysis
mvn sonar:sonar -Dsonar.login=squ_600fb4326fecbfe2fb7b96ff589210d37d94945f
```

## 📖 Documentation

- **[SONARQUBE_DOCKER_GUIDE.md](SONARQUBE_DOCKER_GUIDE.md)** - NEW! Docker-based CI/CD setup
- **[SONARQUBE_SETUP_GUIDE.md](SONARQUBE_SETUP_GUIDE.md)** - Complete setup guide
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Command cheat sheet

## 📁 Project Structure

- **docker-compose.yml**: Run SonarQube, MySQL, and your app together
- **Dockerfile**: Simple 12-line Docker configuration
- **.github/workflows/ci-cd.yml**: Automated CI/CD with SonarQube in Docker
- **sonar-project.properties**: Minimal SonarQube config
- **pom.xml**: Maven configuration with SonarQube plugin

## 🛠️ Technology Stack

- Java 17
- Spring Boot 3.5.9
- MySQL 8.0
- Maven
- Docker & Docker Compose
- SonarQube (in Docker)
- GitHub Actions

## 🐳 Docker Services

The `docker-compose.yml` includes:

1. **SonarQube** (port 9000) - Code quality analysis
2. **MySQL** (port 3306) - Database
3. **Your App** (port 8080) - Spring Boot application

All connected through Docker network!

## 🔄 CI/CD Pipeline (GitHub Actions)

The pipeline automatically:
1. Starts SonarQube in Docker
2. Builds your project
3. Runs code analysis
4. Builds Docker image
5. Cleans up

Just push to `main` branch and it runs!

## 📝 Configuration Files Explained

### docker-compose.yml (NEW!)
- Runs SonarQube, MySQL, and your app
- One command starts everything
- Containers communicate automatically

### Dockerfile (Minimal - 12 lines)
- Uses Java 17 image
- Copies JAR file
- Exposes port 8080
- Runs the application

### CI/CD Pipeline (7 steps)
1. Download code
2. Setup Java 17
3. Start SonarQube in Docker
4. Build with Maven
5. Run SonarQube analysis
6. Build Docker image
7. Stop SonarQube (cleanup)

### SonarQube Config (8 lines)
- Project key and name
- Source code location
- Server URL (localhost:9000)

## 🎯 What's Different (Beginner-Friendly)

I've simplified everything and added Docker integration:

✅ **docker-compose.yml** - NEW! Run everything with one command  
✅ **CI/CD with Docker** - SonarQube runs automatically in pipeline  
✅ **Dockerfile** - Minimal 12-line configuration  
✅ **SonarQube** - No external server needed  
✅ **Token Security** - Stored in GitHub secrets  

## 📚 Next Steps

1. Read [SONARQUBE_DOCKER_GUIDE.md](SONARQUBE_DOCKER_GUIDE.md) for Docker setup
2. Run `docker-compose up -d` to start everything
3. Setup GitHub Actions with your `SONAR_TOKEN`
4. Push to GitHub and watch the pipeline run
5. Fix code quality issues found by SonarQube

## 🆘 Need Help?

Check the troubleshooting section in [SONARQUBE_DOCKER_GUIDE.md](SONARQUBE_DOCKER_GUIDE.md)

