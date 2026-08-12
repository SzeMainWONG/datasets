#!/bin/bash

# Test how much compression will save
echo "Testing compression ratio..."
gzip -c dataset/SGJobData.csv > /tmp/test.csv.gz
echo "Original: $(ls -lh dataset/SGJobData.csv | awk '{print $5}')"
echo "Compressed: $(ls -lh /tmp/test.csv.gz | awk '{print $5}')"

# Compress the actual file
echo "Compressing file..."
gzip -9 dataset/SGJobData.csv

# Update git
echo "Updating git..."
git rm dataset/SGJobData.csv
git add dataset/SGJobData.csv.gz

# Update .gitattributes
echo "*.csv.gz filter=lfs diff=lfs merge=lfs -text" >> .gitattributes
git add .gitattributes

# Commit
git commit -m "Compress SGJobData.csv to .csv.gz"

# Push LFS
echo "Pushing to LFS..."
git lfs push --all origin main

# Push commit
git push origin main

# Cleanup test file
rm /tmp/test.csv.gz 2>/dev/null

echo "Done!"