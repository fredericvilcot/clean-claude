#!/usr/bin/env bash
set -euo pipefail

# Spectre Router - Routes events between agents
# Called by hooks when agents complete or errors occur

SPECTRE_DIR=".spectre"
STATE_FILE="$SPECTRE_DIR/state.json"
ERRORS_FILE="$SPECTRE_DIR/errors.jsonl"
EVENTS_FILE="$SPECTRE_DIR/events.jsonl"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

log_event() {
    local event_type="$1"
    local agent="$2"
    local message="$3"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    echo "{\"timestamp\":\"$timestamp\",\"event\":\"$event_type\",\"agent\":\"$agent\",\"message\":\"$message\"}" >> "$EVENTS_FILE"
}

get_state() {
    local key="$1"
    jq -r ".$key // empty" "$STATE_FILE"
}

set_state() {
    local key="$1"
    local value="$2"
    local tmp=$(mktemp)
    jq ".$key = $value" "$STATE_FILE" > "$tmp" && mv "$tmp" "$STATE_FILE"
}

# Read hook input from stdin
read_hook_input() {
    cat
}

# Main router logic
main() {
    local action="${1:-}"
    local agent="${2:-}"
    local input=$(read_hook_input)

    case "$action" in
        "agent-complete")
            handle_agent_complete "$agent" "$input"
            ;;
        "test-result")
            handle_test_result "$input"
            ;;
        "error")
            handle_error "$agent" "$input"
            ;;
        "status")
            show_status
            ;;
        *)
            echo "Usage: spectre-router.sh <action> [agent]"
            echo "Actions: agent-complete, test-result, error, status"
            exit 1
            ;;
    esac
}

handle_agent_complete() {
    local agent="$1"
    local input="$2"

    log_event "agent_complete" "$agent" "Agent completed"

    # Update state
    set_state "agents.lastActive" "\"$agent\""

    local phase=$(get_state "phase")
    local retry_count=$(get_state "retryCount")
    local max_retries=$(get_state "maxRetries")

    case "$agent" in
        "qa-engineer")
            # Check if there were errors
            local last_error=$(tail -1 "$ERRORS_FILE" 2>/dev/null | jq -r '.resolved // false')

            if [[ "$last_error" == "false" ]] && [[ "$retry_count" -lt "$max_retries" ]]; then
                # Error not resolved, trigger dev agent
                echo -e "${YELLOW}[SPECTRE]${NC} Error detected, routing to frontend-dev..."
                set_state "phase" "\"fix\""
                set_state "retryCount" "$((retry_count + 1))"
                echo "TRIGGER:frontend-dev" > "$SPECTRE_DIR/trigger"
            else
                echo -e "${GREEN}[SPECTRE]${NC} All tests passed!"
                set_state "phase" "\"complete\""
                set_state "status" "\"success\""
            fi
            ;;

        "frontend-dev")
            # Dev completed fix, trigger QA to verify
            echo -e "${BLUE}[SPECTRE]${NC} Fix applied, routing to qa-engineer for verification..."
            set_state "phase" "\"verify\""
            echo "TRIGGER:qa-engineer" > "$SPECTRE_DIR/trigger"
            ;;

        "software-craftsman")
            # Design complete, trigger implementation
            echo -e "${BLUE}[SPECTRE]${NC} Design complete, routing to frontend-dev..."
            set_state "phase" "\"implement\""
            echo "TRIGGER:frontend-dev" > "$SPECTRE_DIR/trigger"
            ;;

        "product-owner")
            # Story complete, trigger design
            echo -e "${BLUE}[SPECTRE]${NC} Story defined, routing to software-craftsman..."
            set_state "phase" "\"design\""
            echo "TRIGGER:software-craftsman" > "$SPECTRE_DIR/trigger"
            ;;
    esac
}

handle_test_result() {
    local input="$1"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Parse test output for errors
    if echo "$input" | grep -qiE "(FAIL|ERROR|failed|error)"; then
        # Extract error info
        local error_message=$(echo "$input" | grep -iE "(FAIL|ERROR|failed|error)" | head -5)

        echo "{\"timestamp\":\"$timestamp\",\"type\":\"test_failure\",\"message\":\"$error_message\",\"resolved\":false}" >> "$ERRORS_FILE"

        log_event "test_failure" "qa-engineer" "Test failure detected"
        echo -e "${RED}[SPECTRE]${NC} Test failure detected"
    else
        # Mark last error as resolved if tests pass
        if [[ -f "$ERRORS_FILE" ]]; then
            # Update last error as resolved
            local tmp=$(mktemp)
            head -n -1 "$ERRORS_FILE" > "$tmp" 2>/dev/null || true
            local last_line=$(tail -1 "$ERRORS_FILE" 2>/dev/null)
            if [[ -n "$last_line" ]]; then
                echo "$last_line" | jq '.resolved = true' >> "$tmp"
                mv "$tmp" "$ERRORS_FILE"
            fi
        fi

        log_event "test_success" "qa-engineer" "All tests passed"
        echo -e "${GREEN}[SPECTRE]${NC} All tests passed"
    fi
}

handle_error() {
    local agent="$1"
    local input="$2"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    echo "{\"timestamp\":\"$timestamp\",\"agent\":\"$agent\",\"error\":\"$input\",\"resolved\":false}" >> "$ERRORS_FILE"
    log_event "error" "$agent" "$input"
}

show_status() {
    echo -e "${BLUE}=== Spectre Status ===${NC}"
    echo ""

    if [[ -f "$STATE_FILE" ]]; then
        echo -e "${YELLOW}State:${NC}"
        jq '.' "$STATE_FILE"
    fi

    echo ""
    echo -e "${YELLOW}Recent Events:${NC}"
    if [[ -f "$EVENTS_FILE" ]]; then
        tail -5 "$EVENTS_FILE" | jq -c '.'
    else
        echo "No events yet"
    fi

    echo ""
    echo -e "${YELLOW}Unresolved Errors:${NC}"
    if [[ -f "$ERRORS_FILE" ]]; then
        grep '"resolved":false' "$ERRORS_FILE" | tail -3 | jq -c '.' || echo "None"
    else
        echo "None"
    fi
}

main "$@"
