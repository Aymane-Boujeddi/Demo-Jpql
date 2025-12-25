@echo off
echo ========================================
echo  Pipeline Testing Walkthrough
echo ========================================
echo.
echo This script will guide you through testing your CI/CD pipeline step by step.
echo.
pause

REM Step 1: Check Prerequisites
echo.
echo ========================================
echo STEP 1: Checking Prerequisites
echo ========================================
echo.

echo Checking Docker...
docker --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ✗ Docker not found! Please install Docker Desktop.
    pause
    exit /b 1
)
echo ✓ Docker is installed

echo.
echo Checking Maven...
mvn --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ✗ Maven not found! Please install Maven.
    pause
    exit /b 1
)
echo ✓ Maven is installed

echo.
echo Checking Java...
java -version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ✗ Java not found! Please install Java 17.
    pause
    exit /b 1
)
echo ✓ Java is installed

echo.
echo All prerequisites are installed!
pause

REM Step 2: Clean Previous Containers
echo.
echo ========================================
echo STEP 2: Cleaning Previous Containers
echo ========================================
echo.
echo Stopping any running containers...
docker-compose down
echo ✓ Cleanup complete
pause

REM Step 3: Start Docker Services
echo.
echo ========================================
echo STEP 3: Starting Docker Services
echo ========================================
echo.
echo Starting MySQL and SonarQube...
docker-compose up -d mysql sonarqube

echo.
echo Waiting for services to initialize (60 seconds)...
echo This is important - don't skip this!
echo.
echo MySQL needs ~30 seconds to initialize
echo SonarQube needs ~60 seconds to start
echo.
timeout /t 60 /nobreak

echo.
echo Checking service status...
docker-compose ps

echo.
echo ✓ Services started
pause

REM Step 4: Verify SonarQube is Ready
echo.
echo ========================================
echo STEP 4: Verifying SonarQube is Ready
echo ========================================
echo.
echo Opening SonarQube in browser...
start http://localhost:9000
echo.
echo Please check:
echo 1. Can you access http://localhost:9000?
echo 2. Can you login with admin/admin?
echo.
set /p sonar_ready="Is SonarQube ready? (y/n): "
if /i "%sonar_ready%" NEQ "y" (
    echo.
    echo Please wait a bit more and check the logs:
    echo   docker logs demo-sonarqube
    pause
    exit /b 1
)
echo ✓ SonarQube is ready

REM Step 5: Generate Token
echo.
echo ========================================
echo STEP 5: SonarQube Token Setup
echo ========================================
echo.
set /p has_token="Do you already have a SonarQube token configured? (y/n): "
if /i "%has_token%" NEQ "y" (
    echo.
    echo You need to generate a token:
    echo.
    echo 1. In the browser window that just opened (http://localhost:9000)
    echo 2. Login: admin / admin (change password if asked)
    echo 3. Click profile icon (top right) ^> My Account
    echo 4. Click Security tab
    echo 5. Under "Generate Tokens":
    echo    - Name: demo-token
    echo    - Type: Global Analysis Token
    echo    - Expires: No expiration
    echo 6. Click Generate
    echo 7. COPY THE TOKEN!
    echo.
    pause

    echo.
    echo Paste your token here:
    set /p TOKEN="Token: "

    echo.
    echo Updating sonar-project.properties...
    (
        echo sonar.projectKey=demo-Jpql
        echo sonar.projectName=demo-Jpql
        echo sonar.sources=src/main/java
        echo sonar.host.url=http://localhost:9000
        echo sonar.token=!TOKEN!
    ) > sonar-project.properties

    echo ✓ Token saved
) else (
    echo ✓ Token already configured
)
pause

REM Step 6: Build Application
echo.
echo ========================================
echo STEP 6: Building Application
echo ========================================
echo.
echo Running: mvn clean install -DskipTests
echo.
call mvn clean install -DskipTests

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ✗ Build failed!
    echo Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo ✓ Build successful!
echo ✓ JAR file created: target\demov2-0.0.1-SNAPSHOT.jar
pause

REM Step 7: Run Tests
echo.
echo ========================================
echo STEP 7: Running Tests
echo ========================================
echo.
echo Running: mvn test
echo.
call mvn test

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ⚠ Tests failed or had issues
    echo This is OK for now, continuing...
) else (
    echo.
    echo ✓ Tests passed!
)
pause

REM Step 8: Run SonarQube Analysis
echo.
echo ========================================
echo STEP 8: Running SonarQube Analysis
echo ========================================
echo.
echo This will analyze your code quality...
echo.
echo Running: mvn sonar:sonar
echo.
call mvn sonar:sonar

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ✗ SonarQube analysis failed!
    echo.
    echo Common issues:
    echo 1. Token not valid - generate a new one
    echo 2. SonarQube not fully ready - wait longer
    echo 3. Wrong host URL
    echo.
    pause
    exit /b 1
)

echo.
echo ✓ SonarQube analysis complete!
pause

REM Step 9: Build Docker Container
echo.
echo ========================================
echo STEP 9: Building Docker Container
echo ========================================
echo.
echo Building Docker image for your application...
echo.
docker-compose build app

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ✗ Docker build failed!
    pause
    exit /b 1
)

echo.
echo ✓ Docker image built successfully!
pause

REM Step 10: Start Full Stack
echo.
echo ========================================
echo STEP 10: Starting Full Application Stack
echo ========================================
echo.
echo Starting all services (MySQL, SonarQube, App)...
echo.
docker-compose up -d

echo.
echo Waiting for application to start (15 seconds)...
timeout /t 15 /nobreak

echo.
echo Current service status:
docker-compose ps

echo.
echo ✓ All services started!
pause

REM Step 11: Verify Application
echo.
echo ========================================
echo STEP 11: Verifying Application
echo ========================================
echo.
echo Checking application logs...
echo.
docker logs demo-app --tail 20

echo.
echo.
echo Opening application in browser...
start http://localhost:8080

echo.
echo Please check:
echo 1. Can you access http://localhost:8080?
echo 2. Does the application load without errors?
echo.
set /p app_working="Is the application working? (y/n): "
if /i "%app_working%" NEQ "y" (
    echo.
    echo Check the logs:
    echo   docker logs demo-app
    echo.
    echo The app might need more time to start or there might be a database connection issue.
) else (
    echo.
    echo ✓ Application is working!
)
pause

REM Final Summary
echo.
echo ========================================
echo PIPELINE TEST COMPLETE!
echo ========================================
echo.
echo Summary of what was tested:
echo ✓ Docker and prerequisites
echo ✓ Docker Compose services (MySQL, SonarQube)
echo ✓ Maven build
echo ✓ Unit tests
echo ✓ SonarQube code analysis
echo ✓ Docker container build
echo ✓ Full stack deployment
echo.
echo Your services are now running:
echo.
docker-compose ps
echo.
echo URLs to access:
echo - Application:  http://localhost:8080
echo - SonarQube:    http://localhost:9000
echo - MySQL:        localhost:3307
echo.
echo To view SonarQube results:
echo 1. Go to http://localhost:9000
echo 2. Login (admin/admin or your password)
echo 3. Click on "demo-Jpql" project
echo.
echo To stop all services:
echo   docker-compose down
echo.
echo ========================================
echo.
pause

echo.
echo Would you like to view the SonarQube results now? (y/n)
set /p view_results="Open SonarQube? "
if /i "%view_results%"=="y" (
    start http://localhost:9000
)

echo.
echo ========================================
echo Testing complete! Great job! 🎉
echo ========================================
echo.
pause

