# Push to GitHub - Quick Instructions

## Step 1: Create Repository on GitHub

Go to [github.com/new](https://github.com/new) and create a new repository with:
- **Repository name**: `local-cloud-llm` (or your choice)
- **Description**: "AI Development Environment with Local and Cloud LLM Integration"
- **Public/Private**: Your choice
- ⚠️ **DON'T** initialize with README, .gitignore, or license (we already have these)

## Step 2: Add Remote and Push

After creating the repository, GitHub will show you commands. Use these:

### Option A: HTTPS (easier, works everywhere)
```bash
cd "/Users/kevinlappe/Obsidian/Local and Cloud LLM"
git remote add origin https://github.com/YOUR-USERNAME/REPO-NAME.git
git branch -M main
git push -u origin main
```

### Option B: SSH (if you have SSH keys set up)
```bash
cd "/Users/kevinlappe/Obsidian/Local and Cloud LLM"
git remote add origin git@github.com:YOUR-USERNAME/REPO-NAME.git
git branch -M main
git push -u origin main
```

## Step 3: Verify

After pushing, your repository should show:
- ✅ All files except sensitive ones (.env, Keys/, etc.)
- ✅ README.md displayed on the main page
- ✅ No API keys or secrets exposed

## Common Issues

### Authentication Required
If using HTTPS, GitHub might ask for authentication:
- **Username**: Your GitHub username
- **Password**: Use a Personal Access Token (not your password)
  - Create one at: https://github.com/settings/tokens

### Permission Denied (SSH)
If using SSH and getting permission denied:
```bash
# Check if you have SSH keys
ls -la ~/.ssh

# If not, generate one:
ssh-keygen -t ed25519 -C "your-email@example.com"

# Add to GitHub: https://github.com/settings/keys
```

## Quick Copy-Paste Commands

Just replace `YOUR-USERNAME` and `REPO-NAME`:

```bash
# Add remote
git remote add origin https://github.com/YOUR-USERNAME/REPO-NAME.git

# Push
git branch -M main
git push -u origin main

# Verify
git remote -v
git log --oneline
```

---

**Security Reminder**: The .gitignore is already configured to prevent uploading sensitive files. Double-check that .env and API keys are NOT in the repository after pushing!