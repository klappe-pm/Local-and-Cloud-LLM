#!/bin/bash

# Requirements Change Tracking Automation Script
# Compares local and remote versions of Open Requirements.md
# Generates comprehensive Requirements Changelog.md

set -e  # Exit on error

# Configuration
REPO_URL="https://github.com/klappe-pm/Local-and-Cloud-LLM"
LOCAL_REQUIREMENTS="requirements/Open Requirements.md"
REMOTE_REQUIREMENTS_URL="$REPO_URL/raw/main/requirements/Open%20Requirements.md"
CHANGELOG_LOCAL="/Users/kevinlappe/Obsidian/Local and Cloud LLM/z-gitignore/requirements/Requirements Changelog.md"
CHANGELOG_REPO="changelog/Requirements Changelog.md"
TEMP_REMOTE="/tmp/remote-requirements.md"

echo "🔄 Starting Requirements Change Tracking..."

# Check if local requirements file exists
if [ ! -f "$LOCAL_REQUIREMENTS" ]; then
    echo "❌ Local requirements file not found: $LOCAL_REQUIREMENTS"
    exit 1
fi

# Fetch remote requirements file
echo "📥 Fetching remote requirements file..."
if ! curl -s -o "$TEMP_REMOTE" "$REMOTE_REQUIREMENTS_URL"; then
    echo "⚠️  Could not fetch remote file. This might be the first commit."
    touch "$TEMP_REMOTE"
fi

# Get current date and commit info
CURRENT_DATE=$(date +%Y-%m-%d)
COMMIT_NUM=$(git rev-list --count HEAD 2>/dev/null || echo "1")
COMMIT_HEADER="## [$CURRENT_DATE]-[commit $COMMIT_NUM]"

echo "📊 Analyzing changes..."

# Create temporary analysis files
LOCAL_TEMP="/tmp/local-parsed.txt"
REMOTE_TEMP="/tmp/remote-parsed.txt"

# Function to parse requirements table
parse_requirements() {
    local file="$1"
    local output="$2"
    
    if [ -f "$file" ] && [ -s "$file" ]; then
        # Extract table rows (skip header and separator)
        grep -E "^\|.*\|$" "$file" | tail -n +3 > "$output" 2>/dev/null || touch "$output"
    else
        touch "$output"
    fi
}

# Parse both files
parse_requirements "$LOCAL_REQUIREMENTS" "$LOCAL_TEMP"
parse_requirements "$TEMP_REMOTE" "$REMOTE_TEMP"

# Initialize changelog if it doesn't exist
if [ ! -f "$CHANGELOG_LOCAL" ]; then
    echo "# Requirements Changelog" > "$CHANGELOG_LOCAL"
    echo "" >> "$CHANGELOG_LOCAL"
fi

# Create commit section
echo "" >> "$CHANGELOG_LOCAL"
echo "$COMMIT_HEADER" >> "$CHANGELOG_LOCAL"
echo "" >> "$CHANGELOG_LOCAL"

# Analyze changes
NEW_REQS=()
DELETED_REQS=()
REVISED_REQS=()
COMPLETED_REQS=()

echo "🔍 Comparing requirements..."

# Find new, deleted, and revised requirements
while IFS= read -r local_line; do
    if [ -n "$local_line" ]; then
        # Extract requirement name (2nd column)
        req_name=$(echo "$local_line" | awk -F'|' '{print $3}' | xargs)
        
        # Check if exists in remote
        if ! grep -F "$req_name" "$REMOTE_TEMP" >/dev/null 2>&1; then
            NEW_REQS+=("$local_line")
        else
            # Check if revised
            remote_line=$(grep -F "$req_name" "$REMOTE_TEMP" || echo "")
            if [ "$local_line" != "$remote_line" ]; then
                # Check if completed (status changed from [ ] to [x])
                local_status=$(echo "$local_line" | awk -F'|' '{print $2}' | xargs)
                remote_status=$(echo "$remote_line" | awk -F'|' '{print $2}' | xargs)
                
                if [[ "$remote_status" == "- [ ]"* ]] && [[ "$local_status" == "- [x]"* ]]; then
                    COMPLETED_REQS+=("$local_line")
                else
                    REVISED_REQS+=("$local_line")
                fi
            fi
        fi
    fi
done < "$LOCAL_TEMP"

# Find deleted requirements
while IFS= read -r remote_line; do
    if [ -n "$remote_line" ]; then
        req_name=$(echo "$remote_line" | awk -F'|' '{print $3}' | xargs)
        if ! grep -F "$req_name" "$LOCAL_TEMP" >/dev/null 2>&1; then
            DELETED_REQS+=("$remote_line")
        fi
    fi
done < "$REMOTE_TEMP"

# Write summary
echo "### Summary of Changes" >> "$CHANGELOG_LOCAL"
echo "- New Requirements: ${#NEW_REQS[@]}" >> "$CHANGELOG_LOCAL"
echo "- Completed Requirements: ${#COMPLETED_REQS[@]}" >> "$CHANGELOG_LOCAL"
echo "- Revised Requirements: ${#REVISED_REQS[@]}" >> "$CHANGELOG_LOCAL"
echo "- Deleted Requirements: ${#DELETED_REQS[@]}" >> "$CHANGELOG_LOCAL"
echo "" >> "$CHANGELOG_LOCAL"

# Generate Open Requirements section
echo "## Open Requirements" >> "$CHANGELOG_LOCAL"
echo "" >> "$CHANGELOG_LOCAL"
echo "| Status | nameRequirement | dateCreated | dateRevised | dateClosed | category | subCategory | topics | subTopics | priority | Change Summary |" >> "$CHANGELOG_LOCAL"
echo "|--------|----------------|-------------|-------------|------------|----------|-------------|--------|-----------|----------|----------------|" >> "$CHANGELOG_LOCAL"

# Add all open requirements (sorted alphabetically)
grep "- \\[ \\]" "$LOCAL_TEMP" | sort -t'|' -k3 >> "$CHANGELOG_LOCAL" 2>/dev/null || true
echo "" >> "$CHANGELOG_LOCAL"

# Generate New Closed Requirements section
if [ ${#COMPLETED_REQS[@]} -gt 0 ]; then
    echo "## New Closed Requirements" >> "$CHANGELOG_LOCAL"
    echo "" >> "$CHANGELOG_LOCAL"
    echo "| Status | nameRequirement | dateCreated | dateRevised | dateClosed | category | subCategory | topics | subTopics | priority | Change Summary |" >> "$CHANGELOG_LOCAL"
    echo "|--------|----------------|-------------|-------------|------------|----------|-------------|--------|-----------|----------|----------------|" >> "$CHANGELOG_LOCAL"
    
    for req in "${COMPLETED_REQS[@]}"; do
        echo "$req" >> "$CHANGELOG_LOCAL"
    done
    echo "" >> "$CHANGELOG_LOCAL"
fi

# Generate Aged Requirements section
echo "## Aged Requirements" >> "$CHANGELOG_LOCAL"
echo "" >> "$CHANGELOG_LOCAL"

# Calculate ages and categorize
CURRENT_EPOCH=$(date +%s)

# Age categories function (bash 3.2 compatible)
get_age_category_header() {
    case $1 in
        "121+") echo "### >120 days (121 or more days)" ;;
        "91-120") echo "### 120 days (91 to 120 days)" ;;
        "61-90") echo "### 90 days (61 to 90 days)" ;;
        "31-60") echo "### 60 days (31 to 60 days)" ;;
        "0-30") echo "### 30 days (0 to 30 days)" ;;
    esac
}

# Process open requirements by age
for category in "121+" "91-120" "61-90" "31-60" "0-30"; do
    echo "$(get_age_category_header $category)" >> "$CHANGELOG_LOCAL"
    echo "" >> "$CHANGELOG_LOCAL"
    
    has_items=false
    while IFS= read -r req_line; do
        if [ -n "$req_line" ]; then
            date_created=$(echo "$req_line" | awk -F'|' '{print $4}' | xargs)
            if [ -n "$date_created" ]; then
                created_epoch=$(date -j -f "%Y-%m-%d" "$date_created" "+%s" 2>/dev/null || echo "0")
                age_days=$(( (CURRENT_EPOCH - created_epoch) / 86400 ))
                
                case $category in
                    "121+") [ $age_days -ge 121 ] && echo "$req_line" >> "$CHANGELOG_LOCAL" && has_items=true ;;
                    "91-120") [ $age_days -ge 91 ] && [ $age_days -le 120 ] && echo "$req_line" >> "$CHANGELOG_LOCAL" && has_items=true ;;
                    "61-90") [ $age_days -ge 61 ] && [ $age_days -le 90 ] && echo "$req_line" >> "$CHANGELOG_LOCAL" && has_items=true ;;
                    "31-60") [ $age_days -ge 31 ] && [ $age_days -le 60 ] && echo "$req_line" >> "$CHANGELOG_LOCAL" && has_items=true ;;
                    "0-30") [ $age_days -ge 0 ] && [ $age_days -le 30 ] && echo "$req_line" >> "$CHANGELOG_LOCAL" && has_items=true ;;
                esac
            fi
        fi
    done < <(grep "- \\[ \\]" "$LOCAL_TEMP" 2>/dev/null || true)
    
    [ "$has_items" = false ] && echo "_No requirements in this category_" >> "$CHANGELOG_LOCAL"
    echo "" >> "$CHANGELOG_LOCAL"
done

# Generate All Closed Requirements section
echo "## All Closed Requirements" >> "$CHANGELOG_LOCAL"
echo "" >> "$CHANGELOG_LOCAL"

# Get all closed requirements and group by dateClosed
closed_reqs=$(grep "- \\[x\\]" "$LOCAL_TEMP" 2>/dev/null || true)

if [ -n "$closed_reqs" ]; then
    # Extract unique close dates and sort in reverse chronological order
    close_dates=$(echo "$closed_reqs" | awk -F'|' '{print $6}' | xargs -n1 | sort -r | uniq)
    
    for close_date in $close_dates; do
        if [ -n "$close_date" ]; then
            echo "### $close_date" >> "$CHANGELOG_LOCAL"
            echo "" >> "$CHANGELOG_LOCAL"
            echo "| Status | nameRequirement | dateCreated | dateRevised | dateClosed | category | subCategory | topics | subTopics | priority | Change Summary |" >> "$CHANGELOG_LOCAL"
            echo "|--------|----------------|-------------|-------------|------------|----------|-------------|--------|-----------|----------|----------------|" >> "$CHANGELOG_LOCAL"
            
            # Add requirements closed on this date (sorted alphabetically)
            echo "$closed_reqs" | grep "|.*$close_date.*|" | sort -t'|' -k3 >> "$CHANGELOG_LOCAL" 2>/dev/null || true
            echo "" >> "$CHANGELOG_LOCAL"
        fi
    done
else
    echo "_No closed requirements yet_" >> "$CHANGELOG_LOCAL"
    echo "" >> "$CHANGELOG_LOCAL"
fi

# Copy to repository location
cp "$CHANGELOG_LOCAL" "$CHANGELOG_REPO"

# Clean up temp files
rm -f "$TEMP_REMOTE" "$LOCAL_TEMP" "$REMOTE_TEMP"

echo "✅ Requirements changelog updated successfully!"
echo "📄 Local copy: $CHANGELOG_LOCAL"
echo "📄 Repository copy: $CHANGELOG_REPO"

# Stage the changelog for commit
git add "$CHANGELOG_REPO" "$LOCAL_REQUIREMENTS"

echo "🎯 Files staged for commit. Ready to push changes!"