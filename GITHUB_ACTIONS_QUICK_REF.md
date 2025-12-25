# 🚀 GitHub Actions - Quick Reference

## ⚡ Quick Start (3 Steps)

1. **Commit your changes**
   ```cmd
   git add .
   git commit -m "Setup CI/CD pipeline"
   ```

2. **Push to GitHub**
   ```cmd
   git push origin main
   ```

3. **Watch it run**
   - Go to: https://github.com/YOUR-USERNAME/Demo-Jpql/actions
   - See your workflow running!

---

## 🤖 Automated Testing

Just run:
```cmd
test-github-actions.bat
```

This script will:
- ✅ Check your Git setup
- ✅ Test build locally first
- ✅ Commit your changes
- ✅ Push to GitHub
- ✅ Open Actions page automatically

---

## 📊 What Happens on GitHub

When you push, GitHub automatically:

1. ✅ **Checkout** - Downloads your code
2. ✅ **Setup Java** - Installs Java 17
3. ✅ **Start MySQL** - Database for tests
4. ✅ **Build** - Compiles your app
5. ✅ **Test** - Runs unit tests
6. ✅ **Analyze** - SonarQube (if configured)

**Time**: 2-5 minutes total

---

## ✅ Success Looks Like

- Green checkmark ✅ next to commit
- All steps green in Actions tab
- "Build and SonarQube Analysis" shows "Success"

---

## ❌ If It Fails

1. **Click the failed workflow** on Actions tab
2. **Click the red X step** to see error
3. **Fix the issue locally**
4. **Test**: `mvn clean install`
5. **Commit and push again**

---

## 🔧 Common Issues

### Build Fails
```cmd
# Test locally first
mvn clean install -DskipTests
```

### Tests Fail
```cmd
# Run tests locally
mvn test

# Or skip them temporarily
mvn install -DskipTests
```

### Can't Push
```cmd
# Check remote
git remote -v

# Configure if needed
git remote add origin https://github.com/USER/Demo-Jpql.git
```

---

## 📝 Workflow File

Located at: `.github/workflows/build.yml`

Triggers on:
- Push to `main` or `master`
- Pull requests to `main` or `master`

---

## 🎯 Testing Scenarios

### Test Normal Push
```cmd
git add .
git commit -m "Test commit"
git push
```

### Test Pull Request
```cmd
git checkout -b feature/test
git push origin feature/test
# Create PR on GitHub
```

### Manual Trigger
Add to workflow:
```yaml
on:
  workflow_dispatch:
```

---

## 🌐 URLs

- **Repository**: https://github.com/YOUR-USERNAME/Demo-Jpql
- **Actions**: https://github.com/YOUR-USERNAME/Demo-Jpql/actions
- **Settings**: https://github.com/YOUR-USERNAME/Demo-Jpql/settings

---

## 🔑 SonarCloud (Optional)

To enable SonarQube analysis:

1. Sign up: https://sonarcloud.io
2. Import repository
3. Get token
4. Add to GitHub Secrets:
   - `SONAR_TOKEN`
   - `SONAR_HOST_URL` = https://sonarcloud.io

---

## 📚 Documentation

- **Full Guide**: `GITHUB_ACTIONS_TESTING.md`
- **Pipeline Quick Ref**: `PIPELINE_QUICK_REF.md`
- **Local Testing**: `TESTING_WALKTHROUGH.md`

---

## 🎓 Tips

1. **Test Locally First** - Always run `mvn clean install` before pushing
2. **Small Commits** - Easier to debug if something fails
3. **Check Actions Tab** - Monitor your builds
4. **Read the Logs** - GitHub provides detailed error messages

---

## ⚡ Commands Cheat Sheet

```cmd
# Check status
git status

# Stage all
git add .

# Commit
git commit -m "message"

# Push
git push

# View remote
git remote -v

# Run local test
mvn clean install

# Open GitHub Actions
test-github-actions.bat
```

---

**Ready? Run: `test-github-actions.bat` to get started! 🚀**

