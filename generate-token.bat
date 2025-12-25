@echo off
echo ========================================
echo  SonarQube Quick Setup
echo ========================================
echo.
echo This script will help you generate a SonarQube token.
echo.
echo Steps:
echo 1. Opening SonarQube in browser...
start http://localhost:9000
echo.
echo 2. Login with: admin / admin
echo    (Change password if prompted)
echo.
echo 3. Generate Token:
echo    - Click your profile icon (top right)
echo    - Go to: My Account ^> Security
echo    - Click "Generate Token"
echo    - Name: demo-token
echo    - Type: Global Analysis Token
echo    - Expires: No expiration
echo    - Click Generate
echo.
echo 4. COPY the token (starts with squ_)
echo.
pause
echo.
echo 5. Paste your token here:
set /p TOKEN="Token: "
echo.
echo Updating sonar-project.properties...
(
echo sonar.projectKey=demo-Jpql
echo sonar.projectName=demo-Jpql
echo sonar.sources=src/main/java
echo sonar.host.url=http://localhost:9000
echo sonar.token=%TOKEN%
) > sonar-project.properties
echo.
echo ✓ Token updated in sonar-project.properties
echo.
echo Running SonarQube analysis...
call mvn sonar:sonar
echo.
echo ========================================
echo Analysis complete!
echo View results at: http://localhost:9000
echo ========================================
pause

