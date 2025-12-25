@echo off
echo ========================================
echo  Complete Pipeline Setup
echo ========================================
echo.

echo What would you like to do?
echo.
echo 1. Test pipeline locally (recommended first)
echo 2. Set up for GitHub Actions
echo 3. Generate SonarQube token
echo 4. View service status
echo 5. Exit
echo.
set /p choice="Enter choice (1-5): "

if "%choice%"=="1" goto test_local
if "%choice%"=="2" goto setup_github
if "%choice%"=="3" goto generate_token
if "%choice%"=="4" goto view_status
if "%choice%"=="5" goto end

echo Invalid choice!
pause
exit /b

:test_local
echo.
echo ========================================
echo Testing Pipeline Locally
echo ========================================
echo.
call test-pipeline.bat
goto end

:setup_github
echo.
echo ========================================
echo GitHub Actions Setup
echo ========================================
echo.
echo Current status:
git remote -v
echo.
echo.
echo To set up GitHub Actions, you need:
echo 1. A GitHub repository (you already have one)
echo 2. SonarCloud account (sign up at sonarcloud.io)
echo 3. GitHub Secrets configured
echo.
echo Next steps:
echo 1. Go to https://sonarcloud.io
echo 2. Sign in with GitHub
echo 3. Import your repository
echo 4. Get the token
echo 5. Add secrets to GitHub:
echo    - Go to repository Settings ^> Secrets ^> Actions
echo    - Add SONAR_TOKEN
echo    - Add SONAR_HOST_URL = https://sonarcloud.io
echo.
echo Then commit and push your changes:
echo   git add .
echo   git commit -m "Set up CI/CD pipeline"
echo   git push
echo.
pause
goto end

:generate_token
echo.
echo ========================================
echo Generate SonarQube Token
echo ========================================
echo.
call generate-token.bat
goto end

:view_status
echo.
echo ========================================
echo Services Status
echo ========================================
echo.
docker-compose ps
echo.
echo ========================================
echo.
echo To view logs:
echo   docker logs demo-app
echo   docker logs demo-mysql
echo   docker logs demo-sonarqube
echo.
pause
goto end

:end
echo.
echo Goodbye!

