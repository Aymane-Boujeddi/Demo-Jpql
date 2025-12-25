# 🏗️ Architecture Overview - SonarQube Docker Setup

## 📊 System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Compose Environment                │
│                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │  SonarQube   │    │    MySQL     │    │   Your App   │  │
│  │              │    │              │    │              │  │
│  │  Port: 9000  │    │  Port: 3306  │◄───│  Port: 8080  │  │
│  │              │    │              │    │              │  │
│  │  admin/admin │    │ demo_jpql DB │    │ Spring Boot  │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│         ▲                                                    │
│         │                                                    │
│         └────────────────┐                                  │
│                          │                                  │
└──────────────────────────┼──────────────────────────────────┘
                           │
                    ┌──────▼───────┐
                    │ Maven Plugin │
                    │ sonar:sonar  │
                    └──────────────┘
```

---

## 🔄 CI/CD Pipeline Flow (GitHub Actions)

```
┌─────────────────────────────────────────────────────────────┐
│                    GitHub Actions Runner                     │
│                                                              │
│  Step 1: Checkout Code                                      │
│  ┌──────────────────────────────────────────┐              │
│  │ git clone your-repo                      │              │
│  └──────────────────────────────────────────┘              │
│                     ↓                                        │
│  Step 2: Setup Java 17                                      │
│  ┌──────────────────────────────────────────┐              │
│  │ Install JDK 17 (Temurin)                 │              │
│  └──────────────────────────────────────────┘              │
│                     ↓                                        │
│  Step 3: Start SonarQube Container ⭐                       │
│  ┌──────────────────────────────────────────┐              │
│  │ docker run -d sonarqube:latest           │              │
│  │ Wait for status: UP (max 5 min)          │              │
│  └──────────────────────────────────────────┘              │
│                     ↓                                        │
│  Step 4: Build Project                                      │
│  ┌──────────────────────────────────────────┐              │
│  │ mvn clean package                        │              │
│  └──────────────────────────────────────────┘              │
│                     ↓                                        │
│  Step 5: SonarQube Analysis ⭐                              │
│  ┌──────────────────────────────────────────┐              │
│  │ mvn sonar:sonar                          │              │
│  │ └─► Sends code to localhost:9000         │              │
│  │     Uses SONAR_TOKEN from secrets        │              │
│  └──────────────────────────────────────────┘              │
│                     ↓                                        │
│  Step 6: Build Docker Image                                 │
│  ┌──────────────────────────────────────────┐              │
│  │ docker build -t demov2:latest .          │              │
│  └──────────────────────────────────────────┘              │
│                     ↓                                        │
│  Step 7: Cleanup ⭐                                         │
│  ┌──────────────────────────────────────────┐              │
│  │ docker stop sonarqube                    │              │
│  │ docker rm sonarqube                      │              │
│  └──────────────────────────────────────────┘              │
│                     ↓                                        │
│              ✅ Complete!                                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔐 Security Flow

```
Developer                  GitHub                  Pipeline
    │                         │                        │
    │  1. Push Code          │                        │
    ├───────────────────────►│                        │
    │                         │  2. Trigger Pipeline  │
    │                         ├───────────────────────►│
    │                         │                        │
    │                         │  3. Request Secret     │
    │                         │  (SONAR_TOKEN)         │
    │                         │◄───────────────────────┤
    │                         │                        │
    │                         │  4. Return Secret      │
    │                         ├───────────────────────►│
    │                         │                        │
    │                         │  5. Use Token for      │
    │                         │     SonarQube Auth     │
    │                         │                        │
    │  6. View Results       │                        │
    │    in GitHub Actions   │                        │
    │◄───────────────────────┤                        │
```

**Key Points:**
- Token stored securely in GitHub Secrets
- Never exposed in code or logs
- Only accessible to GitHub Actions

---

## 💾 Data Flow (Local Development)

```
Developer Machine
─────────────────────────────────────────────────

1. Start Services
   $ docker-compose up -d
        │
        ├─► SonarQube (port 9000)
        ├─► MySQL (port 3306)
        └─► App (port 8080)

2. Build Project
   $ mvn clean install
        │
        └─► Creates target/demov2-0.0.1-SNAPSHOT.jar

3. Run Analysis
   $ mvn sonar:sonar -Dsonar.login=YOUR_TOKEN
        │
        ├─► Scans src/main/java
        ├─► Sends to http://localhost:9000
        └─► Results appear in SonarQube UI

4. View Results
   Browser → http://localhost:9000
        │
        └─► See code quality metrics
```

---

## 🐳 Docker Network Communication

```
┌────────────────────────────────────────────┐
│         Docker Network: demo-network       │
│                                            │
│  ┌──────────┐         ┌──────────┐        │
│  │SonarQube │         │  MySQL   │        │
│  │          │         │          │        │
│  │ Port     │         │ Port     │        │
│  │ 9000     │         │ 3306     │        │
│  └────┬─────┘         └────┬─────┘        │
│       │                    │               │
│       │    ┌──────────┐    │               │
│       └───►│   App    │◄───┘               │
│            │          │                    │
│            │ Connects │                    │
│            │ to MySQL │                    │
│            └──────────┘                    │
│                 │                          │
└─────────────────┼──────────────────────────┘
                  │
            Exposed Ports
          (accessible from host)
```

**Communication:**
- App → MySQL: `jdbc:mysql://mysql:3306/demo_jpql`
- Maven → SonarQube: `http://localhost:9000`
- Host → SonarQube: `http://localhost:9000`
- Host → App: `http://localhost:8080/demo`

---

## 📂 File Structure & Purpose

```
Demo-Jpql/
│
├── src/                           # Source code
│   ├── main/java/                # Application code
│   └── test/java/                # Test code
│
├── target/                        # Build output
│   └── demov2-0.0.1-SNAPSHOT.jar # Built application
│
├── .github/
│   └── workflows/
│       └── ci-cd.yml             # ⭐ Pipeline with Docker SonarQube
│
├── docker-compose.yml            # ⭐ Run all services locally
├── Dockerfile                    # ⭐ Build app container
├── pom.xml                       # Maven config
├── sonar-project.properties      # ⭐ SonarQube settings
│
└── Documentation/
    ├── SONARQUBE_DOCKER_GUIDE.md # ⭐ NEW! Complete Docker guide
    ├── SONARQUBE_SETUP_GUIDE.md  # Original setup guide
    ├── QUICK_REFERENCE.md        # Command cheat sheet
    └── README.md                 # Updated overview
```

---

## ⚙️ Configuration Chain

```
pom.xml
  │
  ├─ Defines: SonarQube plugin
  ├─ Sets: Project key (demov2)
  └─ Points to: http://localhost:9000
      │
      ↓
sonar-project.properties
  │
  ├─ Defines: Source paths (src/main/java)
  ├─ Sets: Project metadata
  └─ References: SonarQube server
      │
      ↓
.github/workflows/ci-cd.yml
  │
  ├─ Starts: SonarQube container
  ├─ Runs: mvn sonar:sonar
  ├─ Uses: secrets.SONAR_TOKEN
  └─ Cleanup: Stops container
      │
      ↓
docker-compose.yml (Local Dev)
  │
  ├─ Service: SonarQube (port 9000)
  ├─ Service: MySQL (port 3306)
  └─ Service: App (port 8080)
```

---

## 🎯 Workflow Comparison

### Before (Manual SonarQube)
```
1. Install SonarQube locally
2. Start SonarQube server
3. Configure project
4. Run analysis manually
5. Keep server running
```

### After (Docker + CI/CD)
```
1. docker-compose up -d     # One command
   OR
   git push origin main     # Automatic in pipeline

2. Everything else is automated! ✨
```

---

## 🔄 Development Workflow

```
┌──────────────────────────────────────────────┐
│          Daily Development Cycle              │
│                                              │
│  1. Write Code in IntelliJ                   │
│     └─► SonarLint gives instant feedback    │
│                                              │
│  2. Local Testing                            │
│     $ mvn clean install                      │
│     $ mvn spring-boot:run                    │
│                                              │
│  3. Weekly Analysis (Optional)               │
│     $ docker-compose up -d sonarqube        │
│     $ mvn sonar:sonar -Dsonar.login=...     │
│                                              │
│  4. Commit & Push                            │
│     $ git commit -m "Feature X"             │
│     $ git push origin main                   │
│                                              │
│  5. Automatic CI/CD                          │
│     └─► GitHub Actions runs full pipeline  │
│         ├─ Builds project                   │
│         ├─ Runs SonarQube in Docker         │
│         └─ Creates Docker image             │
│                                              │
│  6. Review Results                           │
│     └─► Check GitHub Actions logs          │
│                                              │
└──────────────────────────────────────────────┘
```

---

## 📊 Monitoring & Logs

### Check SonarQube Status
```powershell
# Local
docker logs demo-sonarqube
curl http://localhost:9000/api/system/status

# CI/CD
Check GitHub Actions logs → "Start SonarQube" step
```

### Check Application
```powershell
# Local
docker logs demo-app
curl http://localhost:8080/demo

# Docker Compose
docker-compose logs -f app
```

### Check MySQL
```powershell
docker logs demo-mysql
docker-compose logs -f mysql
```

---

## 🎓 Key Concepts

### 1. **Containerization**
Each service runs in isolation with its own:
- File system
- Network interface
- Environment variables
- Dependencies

### 2. **Docker Compose**
Orchestrates multiple containers:
- Starts them in order
- Connects them via network
- Manages volumes
- One-command deployment

### 3. **CI/CD Integration**
Automated pipeline that:
- Runs on every push
- Uses ephemeral containers
- Cleans up after itself
- Reports results

### 4. **Security**
- Tokens in GitHub Secrets
- No credentials in code
- Isolated containers
- Secure communication

---

## ✅ Summary

**You now have:**

✨ **Local Development**
- Docker Compose with SonarQube, MySQL, App
- One command starts everything
- Easy testing and debugging

✨ **CI/CD Pipeline**
- SonarQube runs in GitHub Actions
- Automated code analysis
- No external dependencies

✨ **Security**
- Tokens in GitHub Secrets
- No credentials exposed
- Secure by design

✨ **Simplicity**
- Minimal configuration
- Beginner-friendly
- Well-documented

---

**Ready to start! 🚀**

See [SONARQUBE_DOCKER_GUIDE.md](SONARQUBE_DOCKER_GUIDE.md) for detailed instructions.

