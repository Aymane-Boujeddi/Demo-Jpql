@echo off
echo ========================================
echo  Test CI/CD Pipeline Locally
echo ========================================
echo.
echo This script simulates the CI/CD pipeline locally
echo.

echo [Step 1/5] Starting Docker services...
docker-compose up -d mysql sonarqube
echo ✓ Services started
echo.

echo [Step 2/5] Waiting for services to be ready (30 seconds)...
timeout /t 30 /nobreak >nul
echo ✓ Services should be ready
echo.

echo [Step 3/5] Building the application...
call mvn clean install -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ✗ Build failed!
    pause
    exit /b 1
)
echo ✓ Build successful
echo.

echo [Step 4/5] Running tests...
call mvn test
if %ERRORLEVEL% NEQ 0 (
    echo ⚠ Tests failed or skipped
) else (
    echo ✓ Tests passed
)
echo.

echo [Step 5/5] Running SonarQube analysis...
call mvn sonar:sonar
if %ERRORLEVEL% NEQ 0 (
    echo ✗ SonarQube analysis failed!
    echo.
    echo Possible issues:
    echo - Token not set in sonar-project.properties
    echo - SonarQube not ready (wait longer)
    echo - Run generate-token.bat first to set up token
    pause
    exit /b 1
)
echo ✓ SonarQube analysis complete
echo.

echo ========================================
echo Pipeline execution complete!
echo ========================================
echo.
echo View results:
echo - Application: http://localhost:8080
echo - SonarQube: http://localhost:9000
echo.
pause

