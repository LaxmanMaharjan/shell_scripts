#!/bin/bash

# Define variables
VAULT_DIR="/home/laxman/projects/obsidian/Day Planning"
FILE_TO_ADD="Day planning.md"
LOG_FILE="/home/laxman/projects/obsidian/git_push.log"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to log the final message with two blank lines after
log_final() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1\n\n" >> "$LOG_FILE"
}

# Navigate to the Obsidian vault directory
if cd "$VAULT_DIR"; then
    log "Navigated to directory: $VAULT_DIR"
else
    log "Failed to navigate to directory: $VAULT_DIR"
    exit 1
fi

# Add changes
if git add "$FILE_TO_ADD"; then
    log "Successfully added $FILE_TO_ADD to Git."
else
    log "Error adding $FILE_TO_ADD to Git."
    exit 1
fi

# Check if there are any changes to commit
if git diff --cached --quiet; then
    log "No changes to commit."
else
    # Commit changes with a timestamped message
    COMMIT_MESSAGE="Daily update: $(date '+%Y-%m-%d %H:%M:%S')"
    if git commit -m "$COMMIT_MESSAGE"; then
        log "Successfully committed changes: $COMMIT_MESSAGE"
    else
        log "Error committing changes."
        exit 1
    fi
fi

# Push to the repository and capture error if it occurs
push_output=$(git push origin main 2>&1)
if echo "$push_output" | grep -q "error"; then
    log "Error pushing changes to the remote repository: $push_output"
else
    log "Successfully pushed changes to the remote repository."
fi

# Log the final message with extra newlines
log_final "Git automation script completed successfully."

