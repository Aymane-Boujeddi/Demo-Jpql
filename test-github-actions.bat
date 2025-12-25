@echo off
echo ========================================
echo  GitHub Actions Pipeline Tester
echo ========================================
echo.
echo This script will help you test your CI/CD pipeline on GitHub.
echo.
pause

REM Step 1: Check Git Configuration
echo.
echo ========================================
echo STEP 1: Checking Git Configuration
echo ========================================
echo.

git --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ✗ Git not installed!
    echo Please install Git from https://git-scm.com/
    pause
    exit /b 1
)
echo ✓ Git is installed

echo.
echo Checking Git remote...
git remote -v
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ✗ No Git remote configured!
    echo.
    echo Please configure your GitHub repository:
    echo   git remote add origin https://github.com/YOUR-USERNAME/Demo-Jpql.git
    pause
    exit /b 1
)
echo ✓ Git remote configured
pause

REM Step 2: Check Current Branch
echo.
echo ========================================
echo STEP 2: Checking Current Branch
echo ========================================
echo.
for /f "tokens=*" %%i in ('git branch --show-current') do set CURRENT_BRANCH=%%i
echo Current branch: %CURRENT_BRANCH%
echo.
if "%CURRENT_BRANCH%"=="main" (
    echo ✓ On main branch
) else if "%CURRENT_BRANCH%"=="master" (
    echo ✓ On master branch
) else (
    echo ⚠ You are on branch: %CURRENT_BRANCH%
    echo Pipeline will trigger on: main or master
    echo.
    set /p switch_branch="Switch to main branch? (y/n): "
    if /i "!switch_branch!"=="y" (
        git checkout main
        if %ERRORLEVEL% NEQ 0 (
            git checkout -b main
        )
    )
)
pause

REM Step 3: Test Build Locally
echo.
echo ========================================
echo STEP 3: Testing Build Locally
echo ========================================
echo.
echo Before pushing to GitHub, let's test locally...
echo.
set /p test_local="Run local build test? (y/n): "
if /i "%test_local%"=="y" (
    echo.
    echo Running: mvn clean install -DskipTests
    call mvn clean install -DskipTests

    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ✗ Local build failed!
        echo Please fix errors before pushing to GitHub.
        pause
        exit /b 1
    )
    echo.
    echo ✓ Local build successful!
) else (
    echo Skipping local test...
)
pause

REM Step 4: Check Git Status
echo.
echo ========================================
echo STEP 4: Checking Git Status
echo ========================================
echo.
git status
echo.
set /p has_changes="Do you have changes to commit? (y/n): "
if /i "%has_changes%"=="y" (
    echo.
    echo Staging all changes...
    git add .

    echo.
    echo Enter commit message:
    set /p commit_msg="Message: "

    if "%commit_msg%"=="" (
        set commit_msg=Configure CI/CD pipeline
    )

    echo.
    echo Committing with message: %commit_msg%
    git commit -m "%commit_msg%"

    echo ✓ Changes committed
) else (
    echo No changes to commit
)
pause

REM Step 5: SonarCloud Configuration
echo.
echo ========================================
echo STEP 5: SonarCloud Configuration (Optional)
echo ========================================
echo.
echo For SonarQube analysis to work on GitHub, you need SonarCloud.
echo.
echo ⚠ If you skip this, the pipeline will still run but skip SonarQube analysis.
echo.
set /p setup_sonar="Do you want to configure SonarCloud? (y/n): "
if /i "%setup_sonar%"=="y" (
    echo.
    echo ========================================
    echo SonarCloud Setup Instructions
    echo ========================================
    echo.
    echo 1. Go to: https://sonarcloud.io
    echo 2. Click "Log in" and sign in with GitHub
    echo 3. Click "+" → "Analyze new project"
    echo 4. Select your Demo-Jpql repository
    echo 5. Follow the setup wizard
    echo 6. Copy your token
    echo.
    echo 7. Go to GitHub repository Settings
    echo 8. Click "Secrets and variables" → "Actions"
    echo 9. Add these secrets:
    echo    - SONAR_TOKEN: [your token]
    echo    - SONAR_HOST_URL: https://sonarcloud.io
    echo.
    echo 10. Add organization to sonar-project.properties:
    echo     sonar.organization=YOUR_ORG_KEY
    echo.
    pause

    echo.
    set /p sonar_done="Have you completed SonarCloud setup? (y/n): "
    if /i "%sonar_done%"=="y" (
        echo ✓ SonarCloud configured
    )
) else (
    echo Skipping SonarCloud setup
    echo Pipeline will skip SonarQube analysis
)
pause

REM Step 6: Push to GitHub
echo.
echo ========================================
echo STEP 6: Push to GitHub
echo ========================================
echo.
echo Ready to push to GitHub and trigger the pipeline!
echo.
echo This will:
echo - Push your code to GitHub
echo - Trigger GitHub Actions workflow
echo - Run build, tests, and analysis
echo.
set /p ready_push="Push to GitHub now? (y/n): "
if /i "%ready_push%"=="y" (
    echo.
    echo Pushing to origin %CURRENT_BRANCH%...
    git push origin %CURRENT_BRANCH%

    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ⚠ Push failed. Trying with -u flag...
        git push -u origin %CURRENT_BRANCH%

        if %ERRORLEVEL% NEQ 0 (
            echo.
            echo ✗ Push failed!
            echo Please check your GitHub credentials and remote URL.
            pause
            exit /b 1
        )
    )

    echo.
    echo ✓ Code pushed to GitHub!
    echo ✓ Pipeline should now be running!
) else (
    echo.
    echo Push cancelled. Run this script again when ready.
    pause
    exit /b 0
)
pause

REM Step 7: Open GitHub Actions
echo.
echo ========================================
echo STEP 7: View Pipeline Execution
echo ========================================
echo.
echo Opening GitHub Actions in your browser...
echo.

REM Extract GitHub URL from git remote
for /f "tokens=2 delims=:" %%i in ('git remote get-url origin') do set REPO_PATH=%%i
set REPO_PATH=%REPO_PATH:.git=%

REM Try different URL formats
for /f "tokens=1 delims=@" %%i in ('git remote get-url origin') do set REMOTE_URL=%%i

if "%REMOTE_URL:~0,5%"=="https" (
    REM HTTPS format
    for /f "tokens=3,4,5 delims=/" %%i in ('git remote get-url origin') do (
        set GITHUB_URL=https://%%i/%%j/%%k
    )
) else (
    REM SSH format
    set GITHUB_URL=https://github.com/%REPO_PATH%
)

echo GitHub Repository: %GITHUB_URL%
echo Actions Page: %GITHUB_URL%/actions
echo.

start %GITHUB_URL%/actions

echo.
echo ========================================
echo What to Look For
echo ========================================
echo.
echo In the GitHub Actions page, you should see:
echo.
echo 1. A new workflow run called "Build and SonarQube Analysis"
echo 2. Your commit message
echo 3. Status: Running (yellow circle) or Success (green check)
echo.
echo Click on the workflow run to see detailed logs!
echo.
pause

REM Step 8: Monitor Status
echo.
echo ========================================
echo STEP 8: Pipeline Monitoring
echo ========================================
echo.
echo The pipeline is now running on GitHub!
echo.
echo Expected steps:
echo 1. Checkout code (5-10s)
echo 2. Set up Java 17 (10-15s)
echo 3. Start MySQL (10-20s)
echo 4. Build with Maven (30-60s)
echo 5. Run Tests (10-30s)
echo 6. SonarQube Analysis (if configured)
echo.
echo Total time: 2-5 minutes
echo.
echo ✅ GREEN CHECK = Success!
echo ❌ RED X = Failed (check logs)
echo 🟡 YELLOW CIRCLE = Running
echo.
pause

REM Final Summary
echo.
echo ========================================
echo PIPELINE TEST SUMMARY
echo ========================================
echo.
echo ✓ Git configured and connected to GitHub
echo ✓ Code pushed to GitHub
echo ✓ Pipeline triggered
echo.
echo Next steps:
echo 1. Watch the pipeline run on GitHub Actions
echo 2. If it succeeds, you're done! 🎉
echo 3. If it fails, check the logs and fix issues
echo 4. Make changes, commit, and push again
echo.
echo Useful commands:
echo - View status: git status
echo - Pull changes: git pull
echo - View logs: Check GitHub Actions page
echo.
echo Documentation:
echo - See GITHUB_ACTIONS_TESTING.md for detailed guide
echo - Troubleshooting tips included
echo.
echo ========================================
echo.
pause

echo.
set /p open_logs="Open GitHub Actions page again? (y/n): "
if /i "%open_logs%"=="y" (
    start %GITHUB_URL%/actions
)

echo.
echo ========================================
echo Testing Complete! 🚀
echo ========================================
echo.
echo Your CI/CD pipeline is now set up and running!
echo.
pause

