# 🧪 Pipeline Testing Walkthrough

## 📋 Overview

This guide will walk you through testing your entire CI/CD pipeline configuration step by step.

**Time needed**: 10-15 minutes  
**Difficulty**: Beginner  
**What you'll test**: Docker Compose, Dockerfile, Maven build, SonarQube analysis, Full deployment

---

## 🚀 Quick Start

### Automated Walkthrough (Recommended)
```cmd
test-pipeline-walkthrough.bat
```
This script will guide you through every step with explanations.

### Manual Testing
Follow the steps below if you want to understand each part.

---

## 📝 Step-by-Step Manual Testing

### Step 1: Check Prerequisites ✅

**What to do:**
```cmd
docker --version
mvn --version
java -version
```

**Expected output:**
- Docker version 20.x or higher
- Maven 3.x
- Java 17

**If something is missing:**
- Docker: Install Docker Desktop for Windows
- Maven: Install from https://maven.apache.org
- Java: Install Java 17 JDK

---

### Step 2: Clean Previous Setup 🧹

**What to do:**
```cmd
docker-compose down
```

**Expected output:**
```
Removing demo-sonarqube ... done
Removing demo-mysql ... done
Removing demo-app ... done
```

**Why:** Start with a clean slate to avoid conflicts.

---

### Step 3: Start Services 🐳

**What to do:**
```cmd
docker-compose up -d mysql sonarqube
```

**Expected output:**
```
Creating demo-mysql ... done
Creating demo-sonarqube ... done
```

**What's happening:**
- MySQL database is starting
- SonarQube server is starting

**Wait time:** 60 seconds minimum

**Verify:**
```cmd
docker-compose ps
```

You should see both services with status "Up"

---

### Step 4: Verify SonarQube is Ready 🔍

**What to do:**
1. Open browser: http://localhost:9000
2. Wait for the login page to appear

**Login:**
- Username: `admin`
- Password: `admin`
- Change password when prompted (e.g., to `admin123`)

**Expected:**
- Login page loads
- Can login successfully
- Dashboard appears

**If it doesn't work:**
- Wait another 60 seconds
- Check logs: `docker logs demo-sonarqube`
- Look for "SonarQube is operational" in logs

---

### Step 5: Generate SonarQube Token 🔑

**What to do:**

1. **Click** your profile icon (top right, looks like "A")
2. **Click** "My Account"
3. **Click** "Security" tab
4. **Scroll** to "Generate Tokens" section
5. **Fill in:**
   - Name: `demo-token`
   - Type: `Global Analysis Token`
   - Expires in: `No expiration`
6. **Click** "Generate"
7. **COPY** the token (starts with `squ_`)

**Save the token:**
Open `sonar-project.properties` and update:
```properties
sonar.token=YOUR_TOKEN_HERE
```

**Or use the helper:**
```cmd
generate-token.bat
```

---

### Step 6: Build Application 🔨

**What to do:**
```cmd
mvn clean install -DskipTests
```

**Expected output:**
```
[INFO] BUILD SUCCESS
[INFO] Total time: XX.XXX s
```

**What's happening:**
- Cleaning previous builds
- Downloading dependencies (first time only)
- Compiling Java code
- Creating JAR file

**Expected result:**
- File created: `target\demov2-0.0.1-SNAPSHOT.jar`

**If it fails:**
- Check Java version: `java -version` (must be 17)
- Check error message
- Run with more info: `mvn clean install -DskipTests -X`

---

### Step 7: Run Tests 🧪

**What to do:**
```cmd
mvn test
```

**Expected output:**
```
[INFO] Tests run: X, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

**What's happening:**
- Running unit tests
- Testing your code

**If tests fail:**
- Check the test output
- Tests might need database connection
- For now, you can skip this: `mvn install -DskipTests`

---

### Step 8: Run SonarQube Analysis 📊

**What to do:**
```cmd
mvn sonar:sonar
```

**Expected output:**
```
[INFO] ANALYSIS SUCCESSFUL
[INFO] BUILD SUCCESS
```

**What's happening:**
- Analyzing code quality
- Finding bugs and code smells
- Checking security issues
- Uploading results to SonarQube

**If it fails:**
- Error "Not authorized": Generate new token (Step 5)
- Error "Connection refused": SonarQube not ready, wait longer
- Check `sonar-project.properties` has correct token

**View results:**
1. Go to http://localhost:9000
2. Click on "demo-Jpql" project
3. See bugs, code smells, coverage, etc.

---

### Step 9: Build Docker Image 🐋

**What to do:**
```cmd
docker-compose build app
```

**Expected output:**
```
Building app
Successfully built xxxxxxxxx
Successfully tagged demo-jpql-app:latest
```

**What's happening:**
- Building Docker image from Dockerfile
- Copying JAR file into image
- Creating containerized application

**Verify:**
```cmd
docker images | findstr demo-jpql-app
```

You should see your image listed.

---

### Step 10: Start Full Stack 🚀

**What to do:**
```cmd
docker-compose up -d
```

**Expected output:**
```
demo-mysql is up-to-date
demo-sonarqube is up-to-date
Starting demo-app ... done
```

**What's happening:**
- Starting application container
- Connecting to MySQL
- Full stack is now running

**Verify:**
```cmd
docker-compose ps
```

All 3 services should show "Up"

---

### Step 11: Verify Application ✅

**What to do:**
1. Wait 15 seconds for app to start
2. Check logs: `docker logs demo-app`
3. Open browser: http://localhost:8080

**Expected:**
- Application loads
- No errors in logs
- Database connection successful

**Check logs for:**
```
Started Demov2Application in X.XXX seconds
```

**If app doesn't work:**
- Check logs: `docker logs demo-app`
- MySQL might not be ready: `docker logs demo-mysql`
- Wait a bit longer and restart: `docker-compose restart app`

---

## 📊 Test Results Summary

After completing all steps, you should have:

✅ **Docker Compose**: 3 services running (MySQL, SonarQube, App)  
✅ **Build**: JAR file created successfully  
✅ **Tests**: Unit tests passed  
✅ **SonarQube**: Code analyzed, results visible  
✅ **Docker Image**: Application containerized  
✅ **Full Stack**: All services running and accessible  

---

## 🌐 Access Your Services

| Service | URL | Credentials |
|---------|-----|-------------|
| Application | http://localhost:8080 | N/A |
| SonarQube | http://localhost:9000 | admin/admin123 |
| MySQL | localhost:3307 | root/097680 |

---

## 🐛 Common Issues & Solutions

### Issue 1: "Port already in use"
**Solution:**
```cmd
docker-compose down
netstat -ano | findstr :9000
```
Change port in `docker-compose.yml` if needed.

### Issue 2: "SonarQube not ready"
**Solution:**
Wait 2-3 minutes after starting. Check:
```cmd
docker logs demo-sonarqube
```
Look for "SonarQube is operational"

### Issue 3: "Build failed"
**Solution:**
Check Java version:
```cmd
java -version
```
Must be Java 17.

### Issue 4: "Not authorized"
**Solution:**
Generate new token in SonarQube and update `sonar-project.properties`

### Issue 5: "Application won't start"
**Solution:**
Check if MySQL is ready:
```cmd
docker logs demo-mysql
```
Look for "ready for connections"

Then restart app:
```cmd
docker-compose restart app
```

### Issue 6: "Tests failing"
**Solution:**
Skip tests for now:
```cmd
mvn clean install -DskipTests
```

---

## 📋 Testing Checklist

Use this checklist when testing:

- [ ] Docker Desktop is running
- [ ] All prerequisites installed (Docker, Maven, Java 17)
- [ ] Previous containers stopped
- [ ] MySQL started and ready
- [ ] SonarQube started and accessible
- [ ] SonarQube token generated
- [ ] Token added to sonar-project.properties
- [ ] Maven build successful
- [ ] JAR file created
- [ ] Tests run (pass or skipped)
- [ ] SonarQube analysis successful
- [ ] Results visible in SonarQube dashboard
- [ ] Docker image built
- [ ] Application container running
- [ ] Application accessible at localhost:8080
- [ ] No errors in application logs

---

## 🎯 What Each Test Validates

### Build Test
- ✅ Maven configuration correct
- ✅ Dependencies available
- ✅ Code compiles without errors
- ✅ JAR packaging works

### SonarQube Test
- ✅ SonarQube connection works
- ✅ Token authentication successful
- ✅ Code analysis runs
- ✅ Results uploaded

### Docker Test
- ✅ Dockerfile syntax correct
- ✅ Base image available
- ✅ JAR file copied successfully
- ✅ Container can be built

### Integration Test
- ✅ MySQL connection works
- ✅ Application starts in container
- ✅ Services can communicate
- ✅ Ports are correctly exposed

---

## 🔄 Testing Different Scenarios

### Scenario 1: Fresh Start
```cmd
docker-compose down -v
test-pipeline-walkthrough.bat
```
Tests everything from scratch, including volume cleanup.

### Scenario 2: Quick Rebuild
```cmd
mvn clean install -DskipTests
docker-compose build app
docker-compose up -d
```
Tests code changes without full pipeline.

### Scenario 3: Analysis Only
```cmd
mvn sonar:sonar
```
Tests only SonarQube integration.

### Scenario 4: Container Only
```cmd
docker-compose down
docker-compose up -d
```
Tests Docker configuration only.

---

## 📈 Next Steps After Testing

Once all tests pass:

1. **Fix Issues Found**
   - Review SonarQube results
   - Fix critical bugs
   - Improve code quality

2. **Set Up GitHub Actions**
   - Follow PIPELINE_SETUP.md
   - Configure SonarCloud
   - Add GitHub Secrets

3. **Commit Changes**
   ```cmd
   git add .
   git commit -m "Pipeline tested and working"
   git push
   ```

4. **Monitor GitHub Actions**
   - Go to GitHub repository
   - Click "Actions" tab
   - Watch pipeline run

---

## 🆘 Getting Help

If you're stuck:

1. **Check Logs**
   ```cmd
   docker logs demo-app
   docker logs demo-mysql
   docker logs demo-sonarqube
   ```

2. **Check Service Status**
   ```cmd
   docker-compose ps
   ```

3. **Restart Services**
   ```cmd
   docker-compose restart
   ```

4. **Clean Start**
   ```cmd
   docker-compose down -v
   docker-compose up -d
   ```

5. **Read Documentation**
   - PIPELINE_QUICK_REF.md
   - PIPELINE_SETUP.md

---

## ✨ Success Indicators

You'll know testing is successful when:

1. ✅ All services show "Up" in `docker-compose ps`
2. ✅ Can login to SonarQube at localhost:9000
3. ✅ See project "demo-Jpql" in SonarQube
4. ✅ Application loads at localhost:8080
5. ✅ No error messages in any logs
6. ✅ All pipeline steps complete without errors

---

**Good luck with your testing! 🚀**

Remember: Testing is iterative. If something fails, fix it and test again. That's how you learn!

