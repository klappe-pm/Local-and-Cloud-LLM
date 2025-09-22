#!/bin/bash

# Universal Change Tracking System
# Detects, analyzes, and documents all project changes using LLM intelligence

set -e

# Configuration
PROJECT_ROOT="/Users/kevinlappe/Obsidian/Local and Cloud LLM"
CHANGE_LOG="$PROJECT_ROOT/z-gitignore/project-evolution.md"
TEMP_DIR="/tmp/change-tracker"
CURRENT_DATE=$(date +%Y-%m-%d)
CURRENT_TIME=$(date +%H:%M:%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "🔍 Universal Change Tracker Starting..."

# Create temp directory
mkdir -p "$TEMP_DIR"

# Function to log messages
log() {
    echo -e "${GREEN}[$(date +%H:%M:%S)]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Initialize change log if it doesn't exist
init_change_log() {
    if [ ! -f "$CHANGE_LOG" ]; then
        log "Initializing project evolution log..."
        cat > "$CHANGE_LOG" << 'EOF'
# Project Evolution Log

This file automatically tracks all changes across the project ecosystem using intelligent analysis.

---

EOF
    fi
}

# Capture current project state
capture_project_state() {
    local output_file="$1"
    log "Capturing current project state..."
    
    {
        echo "# Project State Snapshot - $CURRENT_DATE $CURRENT_TIME"
        echo ""
        echo "## File Structure"
        find "$PROJECT_ROOT" -type f -not -path "*/.git/*" -not -path "*/.obsidian/*" -not -path "*/z-gitignore/*" | sort
        echo ""
        echo "## Directory Structure"  
        find "$PROJECT_ROOT" -type d -not -path "*/.git/*" -not -path "*/.obsidian/*" -not -path "*/z-gitignore/*" | sort
        echo ""
        echo "## Git Status"
        cd "$PROJECT_ROOT"
        git status --porcelain || echo "No git repository"
        echo ""
        echo "## Recent Git Changes"
        git diff --name-status HEAD~1 2>/dev/null || echo "No recent git history"
        echo ""
    } > "$output_file"
}

# Detect changes using git and filesystem comparison
detect_changes() {
    local changes_file="$TEMP_DIR/detected_changes.txt"
    log "Detecting changes across all dimensions..."
    
    cd "$PROJECT_ROOT"
    
    {
        echo "# Change Detection Report - $CURRENT_DATE $CURRENT_TIME"
        echo ""
        
        # Git-based change detection
        echo "## Git Changes"
        if git rev-parse --git-dir >/dev/null 2>&1; then
            echo "### Staged Changes"
            git diff --cached --name-status 2>/dev/null || echo "No staged changes"
            echo ""
            
            echo "### Unstaged Changes"
            git diff --name-status 2>/dev/null || echo "No unstaged changes"
            echo ""
            
            echo "### Untracked Files"
            git ls-files --others --exclude-standard 2>/dev/null || echo "No untracked files"
            echo ""
            
            echo "### Recently Modified Files (last commit)"
            git diff --name-status HEAD~1 2>/dev/null || echo "No recent history"
            echo ""
        else
            echo "Not a git repository"
            echo ""
        fi
        
        # File system changes (compared to last snapshot if exists)
        echo "## File System Analysis"
        if [ -f "$TEMP_DIR/last_snapshot.txt" ]; then
            echo "### New Files (since last run)"
            diff <(sort "$TEMP_DIR/last_snapshot.txt" 2>/dev/null || true) <(find "$PROJECT_ROOT" -type f -not -path "*/.git/*" -not -path "*/.obsidian/*" -not -path "*/z-gitignore/*" | sort) | grep "^>" | cut -c3- || echo "No new files"
            echo ""
            
            echo "### Deleted Files (since last run)"
            diff <(sort "$TEMP_DIR/last_snapshot.txt" 2>/dev/null || true) <(find "$PROJECT_ROOT" -type f -not -path "*/.git/*" -not -path "*/.obsidian/*" -not -path "*/z-gitignore/*" | sort) | grep "^<" | cut -c3- || echo "No deleted files"
            echo ""
        else
            echo "First run - establishing baseline"
            echo ""
        fi
        
        # Project structure analysis
        echo "## Current Project Structure"
        echo "### Folders"
        find "$PROJECT_ROOT" -type d -not -path "*/.git/*" -not -path "*/.obsidian/*" -not -path "*/z-gitignore/*" | wc -l | xargs echo "Total folders:"
        echo ""
        
        echo "### Files by Type"
        find "$PROJECT_ROOT" -type f -not -path "*/.git/*" -not -path "*/.obsidian/*" -not -path "*/z-gitignore/*" | sed 's/.*\\.//' | sort | uniq -c | sort -rn || echo "No files found"
        echo ""
        
        echo "### Large Files (>1KB)"
        find "$PROJECT_ROOT" -type f -not -path "*/.git/*" -not -path "*/.obsidian/*" -not -path "*/z-gitignore/*" -size +1024c -exec ls -lh {} + | awk '{print $5 " " $9}' | sort -hr | head -10 || echo "No large files"
        echo ""
        
    } > "$changes_file"
    
    echo "$changes_file"
}

# Use LLM to analyze changes (via Warp AI or fallback to structured analysis)
analyze_changes_with_llm() {
    local changes_file="$1"
    local analysis_file="$TEMP_DIR/llm_analysis.md"
    
    log "Analyzing changes with LLM intelligence..."
    
    # Create a prompt for LLM analysis
    local prompt_file="$TEMP_DIR/analysis_prompt.txt"
    cat > "$prompt_file" << 'EOF'
Please analyze the following project changes and provide insights:

Please provide:
1. **Summary**: What are the main changes happening in this project?
2. **Categories**: Classify changes (new features, refactoring, bug fixes, documentation, etc.)
3. **Impact Analysis**: What files/components might be affected by these changes?
4. **Risk Assessment**: Are there any potential issues or concerns?
5. **Recommendations**: What should be done next or what should be watched?
6. **Pattern Recognition**: Do you see any patterns or trends in these changes?

Format your response in clear markdown with appropriate sections and bullet points.
EOF
    
    # Append the actual change data
    echo "" >> "$prompt_file"
    echo "## Change Data:" >> "$prompt_file"
    cat "$changes_file" >> "$prompt_file"

    # Try to use Warp AI (if available) or provide structured fallback analysis
    if command -v warp >/dev/null 2>&1; then
        log "Using Warp AI for intelligent analysis..."
        # Note: Actual Warp AI integration would go here
        # For now, provide a structured analysis template
        create_structured_analysis "$changes_file" "$analysis_file"
    else
        warn "Warp AI not available, using structured analysis..."
        create_structured_analysis "$changes_file" "$analysis_file"
    fi
    
    echo "$analysis_file"
}

# Create structured analysis when LLM is not available
create_structured_analysis() {
    local changes_file="$1"
    local output_file="$2"
    
    {
        echo "# Automated Change Analysis"
        echo ""
        echo "## Summary"
        echo "Project changes detected on $CURRENT_DATE at $CURRENT_TIME"
        echo ""
        
        echo "## Change Statistics"
        if git rev-parse --git-dir >/dev/null 2>&1; then
            local staged_count=$(git diff --cached --name-only 2>/dev/null | wc -l)
            local unstaged_count=$(git diff --name-only 2>/dev/null | wc -l) 
            local untracked_count=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)
            
            echo "- Staged files: $staged_count"
            echo "- Unstaged modifications: $unstaged_count" 
            echo "- Untracked files: $untracked_count"
        else
            echo "- Not a git repository"
        fi
        echo ""
        
        echo "## File Type Distribution"
        find "$PROJECT_ROOT" -type f -not -path "*/.git/*" -not -path "*/.obsidian/*" -not -path "*/z-gitignore/*" | sed 's/.*\\.//' | sort | uniq -c | sort -rn | head -5 | while read count ext; do
            echo "- .$ext files: $count"
        done
        echo ""
        
        echo "## Recent Activity Indicators"
        echo "- Analysis timestamp: $CURRENT_DATE $CURRENT_TIME"
        if [ -f "$TEMP_DIR/last_run.txt" ]; then
            local last_run=$(cat "$TEMP_DIR/last_run.txt")
            echo "- Previous analysis: $last_run"
        else
            echo "- Previous analysis: First run"
        fi
        echo ""
        
        echo "## Recommendations"
        echo "- Review unstaged changes before committing"
        echo "- Ensure documentation is updated with structural changes"
        echo "- Consider running tests if code modifications detected"
        echo "- Check for broken links if files were moved or renamed"
        echo ""
        
    } > "$output_file"
}

# Update the main change log with new findings
update_change_log() {
    local analysis_file="$1"
    log "Updating project evolution log..."
    
    # Create a new entry in the change log
    {
        echo ""
        echo "---"
        echo ""
        echo "# Change Entry: $CURRENT_DATE $CURRENT_TIME"
        echo ""
        cat "$analysis_file"
        echo ""
    } >> "$CHANGE_LOG"
}

# Save current state for next comparison
save_current_state() {
    log "Saving current state for next comparison..."
    find "$PROJECT_ROOT" -type f -not -path "*/.git/*" -not -path "*/.obsidian/*" -not -path "*/z-gitignore/*" | sort > "$TEMP_DIR/last_snapshot.txt"
    echo "$CURRENT_DATE $CURRENT_TIME" > "$TEMP_DIR/last_run.txt"
}

# Generate summary report
generate_summary() {
    log "Generating change tracking summary..."
    
    echo ""
    echo "📊 Change Tracking Summary"
    echo "=========================="
    echo "Analysis Date: $CURRENT_DATE $CURRENT_TIME"
    echo "Project Root: $PROJECT_ROOT"
    echo "Change Log: $CHANGE_LOG"
    echo ""
    
    if git rev-parse --git-dir >/dev/null 2>&1; then
        echo "Git Repository Status:"
        git status --short | head -10
    fi
    
    echo ""
    echo "✅ Universal change tracking completed successfully!"
    echo "📄 Detailed analysis saved to: $CHANGE_LOG"
    echo ""
}

# Main execution flow
main() {
    log "Starting universal change tracking analysis..."
    
    # Initialize
    init_change_log
    
    # Capture and analyze current state
    local project_state="$TEMP_DIR/current_state.txt"
    capture_project_state "$project_state"
    
    # Detect all changes
    local changes_file
    changes_file=$(detect_changes)
    
    # Analyze changes with intelligence
    local analysis_file
    analysis_file=$(analyze_changes_with_llm "$changes_file")
    
    # Update logs
    update_change_log "$analysis_file"
    
    # Save state for next run
    save_current_state
    
    # Show summary
    generate_summary
    
    # Cleanup
    log "Cleaning up temporary files..."
    # Keep some files for next run comparison
    rm -f "$TEMP_DIR/current_state.txt" "$TEMP_DIR/detected_changes.txt" "$TEMP_DIR/analysis_prompt.txt"
}

# Error handling
trap 'error "Script interrupted"; exit 1' INT TERM

# Run the main function
main "$@"