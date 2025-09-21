#!/bin/bash

# GitHub Repository Setup Script
# Replace YOUR-GITHUB-USERNAME and REPOSITORY-NAME with your actual values

echo "Setting up GitHub repository..."

# Option 1: If you're creating a NEW repository on GitHub
echo "
First, create a new repository on GitHub:
1. Go to https://github.com/new
2. Name it: local-cloud-llm (or your preferred name)
3. DON'T initialize with README (we already have one)
4. Create the repository
"

# Option 2: Add the remote origin (replace with your actual GitHub URL)
# Uncomment and modify the line below with your repository URL:

# git remote add origin https://github.com/YOUR-USERNAME/REPO-NAME.git
# OR for SSH:
# git remote add origin git@github.com:YOUR-USERNAME/REPO-NAME.git

# Example (replace with your actual details):
# git remote add origin https://github.com/kevinlappe/local-cloud-llm.git

# Push to GitHub
# git branch -M main
# git push -u origin main

echo "
After adding the remote, run these commands:
git branch -M main
git push -u origin main
"

# To use this script:
# 1. Edit the repository URL above
# 2. Uncomment the appropriate lines
# 3. Run: chmod +x github-setup.sh && ./github-setup.sh