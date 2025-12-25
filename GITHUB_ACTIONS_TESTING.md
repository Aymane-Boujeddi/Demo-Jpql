# 🚀 GitHub Actions CI/CD Pipeline Testing Guide

## 📋 Overview

This guide will help you test your GitHub Actions pipeline end-to-end.

**Time needed**: 15-20 minutes  
**Difficulty**: Beginner-Intermediate  
**Prerequisites**: GitHub account, Git configured locally

---

## 🎯 What This Pipeline Does

Your GitHub Actions pipeline automatically:
1. ✅ Checks out your code
2. ✅ Sets up Java 17
3. ✅ Starts a MySQL database
4. ✅ Builds your application with Maven
5. ✅ Runs unit tests
6. ✅ Analyzes code with SonarQube (if configured)

**Triggers**: Runs on every push to `main` or `master` branch and on pull requests.

---

## 🔧 Setup Steps

### Step 1: Verify Git Configuration

Check your Git remote:
```cmd
git remote -v
```

**Expected output:**
```
origin  https://github.com/YOUR-USERNAME/Demo-Jpql.git (fetch)
origin  https://github.com/YOUR-USERNAME/Demo-Jpql.git (push)
```

**If not configured:**
```cmd
git remote add origin https://github.com/YOUR-USERNAME/Demo-Jpql.git
```

---

### Step 2: Prepare Your Changes

Check what needs to be committed:
```cmd
git status
```

Stage all changes:
```cmd
git add .
```

Commit:
```cmd
git commit -m "Configure CI/CD pipeline with GitHub Actions"
```

---

### Step 3: (Optional) Configure SonarCloud

**Note**: GitHub Actions can't access your local SonarQube. You have 2 options:

#### Option A: Skip SonarQube Analysis (Easiest)
The pipeline will skip the SonarQube step since secrets aren't configured. Everything else will still run.

#### Option B: Use SonarCloud (Recommended for Production)

1. **Go to SonarCloud**
   - Visit: https://sonarcloud.io
   - Click "Log in" → Sign in with GitHub

2. **Import Your Repository**
   - Click "+" → "Analyze new project"
   - Select your `Demo-Jpql` repository
   - Click "Set Up"

3. **Get Your Token**
   - Follow the setup wizard
   - Copy the token (starts with `squ_`)
   - Copy your organization key

4. **Add GitHub Secrets**
   - Go to your GitHub repository
   - Click "Settings" → "Secrets and variables" → "Actions"
   - Click "New repository secret"
   - Add:
     - **Name**: `SONAR_TOKEN`
     - **Value**: [paste your SonarCloud token]
   - Click "Add secret"
   - Add another:
     - **Name**: `SONAR_HOST_URL`
     - **Value**: `https://sonarcloud.io`

5. **Update sonar-project.properties**
   Add this line:
   ```properties
   sonar.organization=YOUR_SONARCLOUD_ORG_KEY
   ```

---

### Step 4: Push to GitHub

Push your changes:
```cmd
git push origin main
```

**Or if your branch is named master:**
```cmd
git push origin master
```

**If this is your first push:**
```cmd
git branch -M main
git push -u origin main
```

---

### Step 5: Watch the Pipeline Run

1. **Go to GitHub**
   - Navigate to: https://github.com/YOUR-USERNAME/Demo-Jpql

2. **Open Actions Tab**
   - Click the "Actions" tab at the top

3. **View Your Workflow**
   - You'll see "Build and SonarQube Analysis" running
   - Click on the workflow run to see details

4. **Monitor Progress**
   - Watch each step execute in real-time
   - Green checkmark ✅ = Success
   - Red X ❌ = Failed

---

## 📊 Expected Pipeline Flow

### Step 1: Checkout code (5-10 seconds)
```
Run actions/checkout@v3
Syncing repository...
✓ Complete
```

### Step 2: Set up Java 17 (10-15 seconds)
```
Run actions/setup-java@v3
Java 17 installed
✓ Complete
```

### Step 3: Start MySQL (10-20 seconds)
```
MySQL container starting...
Waiting for health check...
✓ MySQL ready
```

### Step 4: Build with Maven (30-60 seconds)
```
[INFO] Building demov2 0.0.1-SNAPSHOT
[INFO] Compiling 12 source files
[INFO] BUILD SUCCESS
✓ Complete
```

### Step 5: Run Tests (10-30 seconds)
```
[INFO] Running tests
[INFO] Tests run: X, Failures: 0, Errors: 0
✓ Complete
```

### Step 6: SonarQube Analysis (Optional)
- **If secrets configured**: Runs analysis
- **If not configured**: Skips (that's OK!)

---

## ✅ Success Indicators

Your pipeline is successful if you see:

1. ✅ Green checkmark next to your commit on GitHub
2. ✅ All steps show green in Actions tab
3. ✅ "Build and SonarQube Analysis" workflow shows "Success"
4. ✅ No red X marks or error messages

---

## 🐛 Troubleshooting

### Issue 1: "Build failed - compilation error"

**Cause**: Code doesn't compile

**Solution**:
```cmd
# Test locally first
mvn clean install -DskipTests

# Fix any errors shown
# Then commit and push again
git add .
git commit -m "Fix compilation errors"
git push
```

### Issue 2: "Tests failed"

**Cause**: Unit tests are failing

**Check locally**:
```cmd
mvn test
```

**Fix the tests or skip them temporarily**:
Update `.github/workflows/build.yml` line 48:
```yaml
- name: Run Tests
  run: mvn test -DskipTests
```

### Issue 3: "SonarQube analysis failed"

**Cause**: Secrets not configured or invalid token

**Solution**:
- Either configure SonarCloud (see Step 3)
- Or remove the SonarQube step from the workflow

### Issue 4: "No workflow runs showing up"

**Cause**: Push didn't trigger the workflow

**Check**:
1. Did you push to `main` or `master`?
2. Is the workflow file in `.github/workflows/`?
3. Is the YAML valid?

**Solution**:
```cmd
# Check current branch
git branch

# Push to correct branch
git push origin main
```

### Issue 5: "Permission denied"

**Cause**: GitHub authentication issue

**Solution**:
```cmd
# Check if you're logged in
git config user.name
git config user.email

# Re-authenticate if needed
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

---

## 🔄 Testing Different Scenarios

### Scenario 1: Test on New Branch

Create a feature branch:
```cmd
git checkout -b feature/test-pipeline
git push origin feature/test-pipeline
```

Create a pull request on GitHub to see the pipeline run on PR.

### Scenario 2: Test After Code Change

Make a small change:
```cmd
echo # Test >> README.md
git add README.md
git commit -m "Test pipeline trigger"
git push
```

Watch it run again in Actions tab.

### Scenario 3: Test Workflow File Changes

Modify the workflow:
```cmd
# Edit .github/workflows/build.yml
git add .github/workflows/build.yml
git commit -m "Update workflow"
git push
```

### Scenario 4: Manual Trigger

Add this to your workflow file after line 11:
```yaml
  workflow_dispatch:
```

Then you can manually trigger from GitHub Actions tab.

---

## 📝 Pipeline Testing Checklist

Before pushing:
- [ ] Code compiles locally: `mvn clean install -DskipTests`
- [ ] Tests pass locally: `mvn test`
- [ ] All files committed: `git status`
- [ ] Correct branch: `git branch`
- [ ] Remote configured: `git remote -v`

After pushing:
- [ ] GitHub Actions tab shows workflow running
- [ ] All steps turn green
- [ ] No error messages in logs
- [ ] Commit shows green checkmark on GitHub

---

## 🎨 Viewing Results

### On GitHub Repository Page
- Green checkmark ✅ next to commit = Pipeline passed
- Red X ❌ next to commit = Pipeline failed
- Yellow circle 🟡 = Pipeline running

### On Actions Tab
- Click "Actions" to see all workflow runs
- Click a specific run to see detailed logs
- Click individual steps to see their output
- Download logs for debugging

### On Pull Requests
- Status checks appear at the bottom
- Shows which checks passed/failed
- Required for merge if configured

---

## 🚀 Advanced: Setting Up Branch Protection

Require pipeline to pass before merging:

1. Go to repository Settings
2. Click "Branches"
3. Add rule for `main` branch
4. Enable "Require status checks to pass"
5. Select "Build and SonarQube Analysis"
6. Save

Now PRs can't be merged unless pipeline passes!

---

## 📊 What Gets Tested

| Component | What's Tested | Where |
|-----------|---------------|-------|
| Code Compilation | Java code compiles | Maven build step |
| Dependencies | All dependencies resolve | Maven build step |
| Unit Tests | All tests pass | Maven test step |
| Database Connection | MySQL connectivity | Test step |
| Code Quality | SonarQube analysis | SonarQube step (if configured) |

---

## 🔐 Security Best Practices

1. **Never commit secrets** to Git
   - Use GitHub Secrets for tokens
   - Don't hardcode passwords in workflow

2. **Keep dependencies updated**
   - Update action versions regularly
   - Update Maven dependencies

3. **Review workflow changes**
   - Understand what each step does
   - Be careful with external actions

---

## 📈 Monitoring Your Pipeline

### View Workflow History
```
GitHub → Actions → All workflows → Build and SonarQube Analysis
```

### Check Success Rate
- See how many runs passed vs failed
- Identify patterns in failures

### View Timing
- See how long each step takes
- Optimize slow steps

---

## 🎯 Success Metrics

Your pipeline is working well if:

1. ✅ 90%+ of runs are successful
2. ✅ Pipeline completes in < 5 minutes
3. ✅ No manual intervention needed
4. ✅ Clear error messages when it fails
5. ✅ Team can see status easily

---

## 🆘 Getting Help

If pipeline fails:

1. **Check the logs**
   - Actions tab → Click failed run → View logs

2. **Test locally first**
   ```cmd
   mvn clean install
   mvn test
   ```

3. **Common fixes**
   - Update dependencies: `mvn clean install -U`
   - Clear Maven cache: Delete `~/.m2/repository`
   - Restart workflow: Click "Re-run all jobs"

4. **Read the error**
   - GitHub Actions provides detailed error messages
   - Look for the red X step
   - Read the log output

---

## 🎓 Learning More

### GitHub Actions Documentation
- https://docs.github.com/en/actions

### Workflow Syntax
- https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions

### SonarCloud Documentation
- https://docs.sonarcloud.io/

---

## ✨ Quick Commands Reference

```cmd
# Check status
git status

# Stage all changes
git add .

# Commit
git commit -m "Your message"

# Push to GitHub
git push

# View remote
git remote -v

# Check current branch
git branch

# Create new branch
git checkout -b branch-name

# Switch branch
git checkout main

# Pull latest
git pull
```

---

## 🎉 What's Next?

After your pipeline is working:

1. **Add badges** to README
   ```markdown
   ![CI](https://github.com/USERNAME/Demo-Jpql/workflows/Build%20and%20SonarQube%20Analysis/badge.svg)
   ```

2. **Set up notifications**
   - Get notified on failures
   - Configure in GitHub settings

3. **Add more checks**
   - Code coverage
   - Security scanning
   - Docker image building

4. **Optimize speed**
   - Cache Maven dependencies
   - Parallel test execution

---

**Ready to test? Just push your code to GitHub and watch the magic happen! 🚀**

Remember: The first run might take longer as it downloads dependencies. Subsequent runs will be faster.

