# Complete Guide: Setting Up Git LFS for Your Repository
LFS - large file storage

## Step 1: Install Git LFS

### On WSL Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install git-lfs
```

### On macOS:
```bash
brew install git-lfs
```

### On Windows (if using Git Bash):
```bash
# Download installer from: https://git-lfs.github.com/
# Or use Chocolatey:
choco install git-lfs
```

### Verify installation:
```bash
git lfs --version
# Should output something like: git-lfs/3.4.0
```

---

## Step 2: Initialize Git LFS (One-time setup)

Run this once per user account (global setup):
```bash
git lfs install
```
This configures Git to use LFS for tracked file types.

---

## Step 3: Configure Repository to Track CSV Files

Navigate to your repository and specify which file types to track:

```bash
cd /path/to/your/repo

# Track all CSV files
git lfs track "*.csv"

# You can also track specific file types
git lfs track "*.parquet"
git lfs track "*.json"
```

### Verify tracking configuration:
```bash
# Check which patterns are being tracked
git lfs track

# View the .gitattributes file
cat .gitattributes
```
Expected output:
```
*.csv filter=lfs diff=lfs merge=lfs -text
```

### Stage the .gitattributes file:
```bash
git add .gitattributes
git commit -m "Configure Git LFS for CSV files"
```

---

## Step 4: Save Your CSV File and Add to Repository

### If you haven't saved the CSV yet:
```python
import pandas as pd

url = "https://raw.githubusercontent.com/kohjiaxuan/Predicting-HDB-Price-with-Machine-Learning/master/resale-flat-prices-based-on-registration-date-from-jan-2017-onwards.csv"
data = pd.read_csv(url)

# Save to your repository directory
data.to_csv('hdb_resale_prices.csv', index=False)
print("CSV file saved successfully!")
```

### Add the file to Git:
```bash
# Add the CSV file to staging
git add hdb_resale_prices.csv

# Verify LFS is tracking it
git lfs ls-files
# Should show your CSV file

# Commit the file
git commit -m "Add HDB resale price dataset"
```

---

## Step 5: Push to GitHub

### Push normally:
```bash
git push origin main
# or if your default branch is 'master':
git push origin master
```

### If LFS migration is needed for existing files:
```bash
# Option A: Migrate specific file types in history
git lfs migrate import --include="*.csv" --everything

# Option B: Migrate only the current branch
git lfs migrate import --include="*.csv"

# Option C: Migrate specific files only
git lfs migrate import --include="hdb_resale_prices.csv"
```

### If you need to force push (only if you've rewritten history):
```bash
git push origin main --force
```

---

## Step 6: Verify Success on GitHub

1. Go to your GitHub repository online
2. Navigate to the CSV file
3. You should see:
   - A "Git LFS" badge or indicator
   - File size displayed with an LFS icon
   - Option to download or view the file

Example of what you'll see:
```
hdb_resale_prices.csv
Stored with Git LFS
Size: 45.2 MB
[Download] [View raw]
```

---

## Step 7: Check LFS Status (Optional)

### View tracked files:
```bash
git lfs ls-files
# Shows: hdb_resale_prices.csv
```

### Check LFS storage usage:
```bash
git lfs status
```

### View LFS environment info:
```bash
git lfs env
```

---

## Troubleshooting Common Issues

### Issue 1: "This repository is configured for Git LFS but does not have 'git-lfs' installed"
```bash
git lfs install --skip-repo
```

### Issue 2: LFS files not being tracked correctly
```bash
# Check if .gitattributes is in your repo root
ls -la | grep gitattributes

# If missing, create it:
git lfs track "*.csv"
git add .gitattributes
git commit -m "Update LFS tracking"
```

### Issue 3: Large files in history causing push failures
```bash
# Remove the file from Git history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch hdb_resale_prices.csv" \
  --prune-empty --tag-name-filter cat -- --all

# Then add it with LFS
git lfs track "*.csv"
git add hdb_resale_prices.csv
git commit -m "Add dataset with LFS"
git push origin main --force
```

### Issue 4: LFS storage limit exceeded
- Free tier: 1 GB storage, 1 GB monthly bandwidth
- Consider compressing the CSV before adding
- Split large files into smaller chunks
- Upgrade your LFS plan on GitHub

### Issue 5: Collaborators can't pull the file
```bash
# Collaborators need to install Git LFS
git lfs install

# Then pull normally
git pull origin main
```

---

## Complete One-Command Setup Script

Create a script `setup_lfs.sh`:

```bash
#!/bin/bash

# Install Git LFS
sudo apt-get update
sudo apt-get install -y git-lfs

# Initialize LFS
git lfs install

# Track CSV files
git lfs track "*.csv"

# Add and commit .gitattributes
git add .gitattributes
git commit -m "Add Git LFS tracking for CSV files"

# Add your CSV file
git add hdb_resale_prices.csv
git commit -m "Add HDB resale dataset"

# Push to GitHub
git push origin main

echo "Git LFS setup complete!"
```

Run it:
```bash
chmod +x setup_lfs.sh
./setup_lfs.sh
```

---

## Quick Reference Commands

| Command | Description |
|---------|-------------|
| `git lfs install` | Initialize Git LFS globally |
| `git lfs track "*.csv"` | Track all CSV files with LFS |
| `git lfs untrack "*.csv"` | Stop tracking CSV files with LFS |
| `git lfs ls-files` | List all files tracked by LFS |
| `git lfs status` | Show LFS status of files |
| `git lfs migrate import --include="*.csv"` | Convert files to LFS |
| `git lfs env` | Display LFS environment info |
| `git lfs --version` | Check installed version |

Now your CSV file will be properly stored and visible in your GitHub repository!

## Additional Notes

The url to read ONLY the file content, as the direct github.com link goes to the html not dataframe content.
Only ONE of following works depending on whether the raw is a pointer to the actual media:
1. Method1: 
"https://raw.githubusercontent.com/[USERNAME]/[REPO_NAME]/[BRANCH_NAME]/[FILE_PATH]"

[BRANCH_NAME] is 'main' or 'master'

2. Method2: 
"https://media.githubusercontent.com/media/[USERNAME]/[REPO_NAME]/[BRANCH_NAME]/[FILE_PATH]"

Example:
```
url = "https://media.githubusercontent.com/media/[USERNAME]/[REPO_NAME]/[BRANCH_NAME]/[FILE_PATH]"
data = pd.read_csv(url)
```


