#!/usr/bin/env bash
set -euo pipefail

# Spectre Router - Intelligent routing between agents
# Routes based on error type, file ownership, and workflow phase

SPECTRE_DIR=".spectre"
STATE_FILE="$SPECTRE_DIR/state.json"
ERRORS_FILE="$SPECTRE_DIR/errors.jsonl"
EVENTS_FILE="$SPECTRE_DIR/events.jsonl"
LEARNINGS_FILE="$SPECTRE_DIR/learnings.jsonl"
OWNERSHIP_FILE="$SPECTRE_DIR/ownership.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

log_event() {
    local event_type="$1"
    local agent="$2"
    local message="$3"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "{\"timestamp\":\"$timestamp\",\"event\":\"$event_type\",\"agent\":\"$agent\",\"message\":\"$message\"}" >> "$EVENTS_FILE"
}

get_state() {
    local key="$1"
    jq -r ".$key // empty" "$STATE_FILE" 2>/dev/null || echo ""
}

set_state() {
    local key="$1"
    local value="$2"
    local tmp=$(mktemp)
    jq ".$key = $value" "$STATE_FILE" > "$tmp" && mv "$tmp" "$STATE_FILE"
}

add_to_history() {
    local agent="$1"
    local tmp=$(mktemp)
    jq ".agents.history += [\"$agent\"]" "$STATE_FILE" > "$tmp" && mv "$tmp" "$STATE_FILE"
}

# ============================================================================
# ERROR TYPE DETECTION
# ============================================================================

detect_error_type() {
    local error_message="$1"

    # TypeScript/Type errors
    if echo "$error_message" | grep -qiE "(type.?error|cannot find name|not assignable|has no property|TS[0-9]+)"; then
        echo "type_error"
        return
    fi

    # Test failures
    if echo "$error_message" | grep -qiE "(FAIL|test.?failed|expect.*received|assertion|vitest|jest|playwright)"; then
        echo "test_failure"
        return
    fi

    # Build errors
    if echo "$error_message" | grep -qiE "(build.?failed|compilation.?error|module not found|cannot resolve|esbuild|vite|webpack)"; then
        echo "build_error"
        return
    fi

    # Runtime errors
    if echo "$error_message" | grep -qiE "(runtime.?error|uncaught|undefined is not|null is not|cannot read|TypeError|ReferenceError)"; then
        echo "runtime_error"
        return
    fi

    # Lint errors
    if echo "$error_message" | grep -qiE "(eslint|prettier|lint.?error|parsing error)"; then
        echo "lint_error"
        return
    fi

    # Accessibility errors
    if echo "$error_message" | grep -qiE "(a11y|accessibility|aria|axe|wcag)"; then
        echo "accessibility_error"
        return
    fi

    # Design/Architecture issues
    if echo "$error_message" | grep -qiE "(circular dependency|design|architecture|coupling|cohesion)"; then
        echo "design_issue"
        return
    fi

    # Default
    echo "unknown_error"
}

# ============================================================================
# AGENT RESOLUTION
# ============================================================================

# Determine which agent should handle an error
resolve_agent_for_error() {
    local error_type="$1"
    local error_file="${2:-}"
    local stack="${3:-frontend}"  # Default stack

    # Check file ownership first
    if [[ -n "$error_file" ]] && [[ -f "$OWNERSHIP_FILE" ]]; then
        local owner=$(jq -r ".\"$error_file\" // empty" "$OWNERSHIP_FILE" 2>/dev/null)
        if [[ -n "$owner" ]]; then
            echo "$owner"
            return
        fi
    fi

    # Route by error type
    case "$error_type" in
        "type_error")
            # Type errors often need architectural review
            echo "software-craftsman"
            ;;
        "test_failure")
            # Route to the appropriate dev based on stack
            if [[ "$stack" == "backend" ]]; then
                echo "backend-dev"
            else
                echo "frontend-dev"
            fi
            ;;
        "build_error")
            # Build errors go to the dev who can fix config
            if [[ "$stack" == "backend" ]]; then
                echo "backend-dev"
            else
                echo "frontend-dev"
            fi
            ;;
        "runtime_error")
            # Runtime errors go to the appropriate dev
            if [[ "$stack" == "backend" ]]; then
                echo "backend-dev"
            else
                echo "frontend-dev"
            fi
            ;;
        "lint_error")
            # Lint errors are quick fixes for the last active dev
            local last_dev=$(get_state "agents.lastDev")
            echo "${last_dev:-frontend-dev}"
            ;;
        "accessibility_error")
            # A11y is frontend specialty
            echo "frontend-dev"
            ;;
        "design_issue")
            # Design issues need architect review
            echo "software-craftsman"
            ;;
        *)
            # Default to last active dev or frontend
            local last_dev=$(get_state "agents.lastDev")
            echo "${last_dev:-frontend-dev}"
            ;;
    esac
}

# Get the next agent in the workflow
get_next_workflow_agent() {
    local current_agent="$1"
    local workflow=$(get_state "workflow")
    local stack=$(get_state "stack")

    # Default workflow: PO → Architect → Dev → QA
    case "$current_agent" in
        "product-owner")
            echo "software-craftsman"
            ;;
        "software-craftsman")
            # Route to appropriate dev based on stack
            if [[ "$stack" == "backend" ]]; then
                echo "backend-dev"
            elif [[ "$stack" == "fullstack" ]]; then
                # Fullstack: start with backend, then frontend
                echo "backend-dev"
            else
                echo "frontend-dev"
            fi
            ;;
        "backend-dev")
            if [[ "$stack" == "fullstack" ]]; then
                # Fullstack: backend done, now frontend
                echo "frontend-dev"
            else
                echo "qa-engineer"
            fi
            ;;
        "frontend-dev")
            echo "qa-engineer"
            ;;
        "qa-engineer")
            # QA complete = workflow complete (unless errors)
            echo "complete"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# ============================================================================
# TRIGGER MANAGEMENT
# ============================================================================

trigger_agent() {
    local agent="$1"
    local reason="$2"
    local context="${3:-}"

    echo -e "${CYAN}[SPECTRE]${NC} Triggering ${YELLOW}$agent${NC} — $reason"

    # Write trigger file
    cat > "$SPECTRE_DIR/trigger" << EOF
{
    "agent": "$agent",
    "reason": "$reason",
    "context": "$context",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

    log_event "trigger" "$agent" "$reason"
}

# ============================================================================
# MAIN HANDLERS
# ============================================================================

handle_agent_complete() {
    local agent="$1"
    local input="$2"

    log_event "agent_complete" "$agent" "Agent completed"

    # Update state
    set_state "agents.lastActive" "\"$agent\""
    add_to_history "$agent"

    # Track dev agents separately
    if [[ "$agent" =~ -dev$ ]]; then
        set_state "agents.lastDev" "\"$agent\""
    fi

    local retry_count=$(get_state "retryCount")
    local max_retries=$(get_state "maxRetries")

    # Special handling for QA
    if [[ "$agent" == "qa-engineer" ]]; then
        # Check for unresolved errors
        local has_errors="false"
        if [[ -f "$ERRORS_FILE" ]]; then
            has_errors=$(tail -1 "$ERRORS_FILE" 2>/dev/null | jq -r '.resolved // true')
            [[ "$has_errors" == "false" ]] && has_errors="true" || has_errors="false"
        fi

        if [[ "$has_errors" == "true" ]]; then
            if [[ "$retry_count" -lt "$max_retries" ]]; then
                # Get the last error details
                local last_error=$(tail -1 "$ERRORS_FILE")
                local error_type=$(echo "$last_error" | jq -r '.type // "unknown"')
                local error_file=$(echo "$last_error" | jq -r '.file // empty')

                # Resolve which agent should fix this
                local fixer=$(resolve_agent_for_error "$error_type" "$error_file")

                set_state "phase" "\"fix\""
                set_state "retryCount" "$((retry_count + 1))"

                trigger_agent "$fixer" "Fix error: $error_type" "$last_error"
            else
                echo -e "${RED}[SPECTRE]${NC} Max retries ($max_retries) exceeded"
                set_state "phase" "\"blocked\""
                set_state "status" "\"needs_help\""
                echo -e "${YELLOW}[SPECTRE]${NC} Manual intervention required"
            fi
        else
            echo -e "${GREEN}[SPECTRE]${NC} All tests passed!"
            set_state "phase" "\"complete\""
            set_state "status" "\"success\""

            # Record learnings from this successful run
            record_success_learning
        fi
        return
    fi

    # For other agents, continue workflow
    local next_agent=$(get_next_workflow_agent "$agent")

    if [[ "$next_agent" == "complete" ]]; then
        echo -e "${GREEN}[SPECTRE]${NC} Workflow complete!"
        set_state "phase" "\"complete\""
        set_state "status" "\"success\""
    elif [[ "$next_agent" != "unknown" ]]; then
        local phase_map=(
            ["software-craftsman"]="design"
            ["frontend-dev"]="implement"
            ["backend-dev"]="implement"
            ["qa-engineer"]="verify"
        )
        local next_phase="${phase_map[$next_agent]:-implement}"

        set_state "phase" "\"$next_phase\""
        trigger_agent "$next_agent" "Continue workflow after $agent"
    fi
}

handle_test_result() {
    local input="$1"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Detect error type from test output
    if echo "$input" | grep -qiE "(FAIL|ERROR|failed|error)"; then
        local error_type=$(detect_error_type "$input")
        local error_message=$(echo "$input" | grep -iE "(FAIL|ERROR|failed|error|expect)" | head -10)

        # Try to extract file from error
        local error_file=$(echo "$input" | grep -oE "[a-zA-Z0-9_/.-]+\.(ts|tsx|js|jsx)" | head -1 || echo "")

        # Record the error
        cat >> "$ERRORS_FILE" << EOF
{"timestamp":"$timestamp","type":"$error_type","message":"$(echo "$error_message" | tr '\n' ' ' | sed 's/"/\\"/g')","file":"$error_file","resolved":false}
EOF

        log_event "error_detected" "system" "$error_type in $error_file"
        echo -e "${RED}[SPECTRE]${NC} Error detected: ${YELLOW}$error_type${NC}"

        # Check for similar past errors and suggest learnings
        suggest_from_learnings "$error_type" "$error_message"
    else
        # Tests passed - mark last error as resolved
        if [[ -f "$ERRORS_FILE" ]] && [[ -s "$ERRORS_FILE" ]]; then
            local tmp=$(mktemp)
            head -n -1 "$ERRORS_FILE" > "$tmp" 2>/dev/null || true
            local last_line=$(tail -1 "$ERRORS_FILE" 2>/dev/null)
            if [[ -n "$last_line" ]] && echo "$last_line" | jq -e '.resolved == false' > /dev/null 2>&1; then
                echo "$last_line" | jq '.resolved = true' >> "$tmp"
                mv "$tmp" "$ERRORS_FILE"

                # Record learning from this fix
                record_fix_learning "$last_line"
            fi
        fi

        log_event "tests_passed" "system" "All tests passing"
        echo -e "${GREEN}[SPECTRE]${NC} All tests passing"
    fi
}

handle_error() {
    local agent="$1"
    local error_message="$2"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    local error_type=$(detect_error_type "$error_message")

    cat >> "$ERRORS_FILE" << EOF
{"timestamp":"$timestamp","agent":"$agent","type":"$error_type","message":"$(echo "$error_message" | tr '\n' ' ' | sed 's/"/\\"/g')","resolved":false}
EOF

    log_event "error" "$agent" "$error_type"
    echo -e "${RED}[SPECTRE]${NC} Error from $agent: $error_type"
}

# ============================================================================
# LEARNING SYSTEM
# ============================================================================

record_fix_learning() {
    local error_json="$1"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    local error_type=$(echo "$error_json" | jq -r '.type')
    local error_file=$(echo "$error_json" | jq -r '.file // "unknown"')
    local fixer=$(get_state "agents.lastDev")

    # Get fix details from git diff if possible
    local fix_summary="Fixed by $fixer"
    if command -v git &> /dev/null && git rev-parse --git-dir &> /dev/null; then
        fix_summary=$(git diff --name-only HEAD~1 2>/dev/null | head -3 | tr '\n' ',' || echo "Fixed by $fixer")
    fi

    cat >> "$LEARNINGS_FILE" << EOF
{"timestamp":"$timestamp","error_type":"$error_type","file_pattern":"$error_file","fixed_by":"$fixer","solution":"$fix_summary","confidence":0.7}
EOF

    echo -e "${CYAN}[SPECTRE]${NC} Learning recorded: $error_type → $fixer"
}

record_success_learning() {
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local retry_count=$(get_state "retryCount")

    if [[ "$retry_count" -gt 0 ]]; then
        # We had errors but fixed them - boost confidence in the learnings
        echo -e "${CYAN}[SPECTRE]${NC} Workflow succeeded after $retry_count retries - learnings reinforced"
    fi
}

suggest_from_learnings() {
    local error_type="$1"
    local error_message="$2"

    if [[ ! -f "$LEARNINGS_FILE" ]] || [[ ! -s "$LEARNINGS_FILE" ]]; then
        return
    fi

    # Find similar past errors
    local similar=$(grep "\"error_type\":\"$error_type\"" "$LEARNINGS_FILE" | tail -1)

    if [[ -n "$similar" ]]; then
        local past_solution=$(echo "$similar" | jq -r '.solution')
        local past_fixer=$(echo "$similar" | jq -r '.fixed_by')
        local confidence=$(echo "$similar" | jq -r '.confidence')

        echo -e "${CYAN}[SPECTRE]${NC} Similar error found in learnings:"
        echo -e "  Past fix: $past_solution"
        echo -e "  Fixed by: $past_fixer (confidence: $confidence)"
    fi
}

# ============================================================================
# FILE OWNERSHIP TRACKING
# ============================================================================

update_ownership() {
    local agent="$1"
    local files="$2"  # Comma-separated list

    if [[ ! -f "$OWNERSHIP_FILE" ]]; then
        echo "{}" > "$OWNERSHIP_FILE"
    fi

    for file in $(echo "$files" | tr ',' '\n'); do
        local tmp=$(mktemp)
        jq ".\"$file\" = \"$agent\"" "$OWNERSHIP_FILE" > "$tmp" && mv "$tmp" "$OWNERSHIP_FILE"
    done
}

# ============================================================================
# STATUS & INIT
# ============================================================================

show_status() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║         SPECTRE STATUS                 ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""

    if [[ -f "$STATE_FILE" ]]; then
        local phase=$(get_state "phase")
        local status=$(get_state "status")
        local retries=$(get_state "retryCount")
        local feature=$(get_state "feature")

        echo -e "${YELLOW}Workflow:${NC} $(get_state "workflow")"
        echo -e "${YELLOW}Feature:${NC} $feature"
        echo -e "${YELLOW}Phase:${NC} $phase"
        echo -e "${YELLOW}Status:${NC} $status"
        echo -e "${YELLOW}Retries:${NC} $retries / $(get_state "maxRetries")"
        echo ""

        echo -e "${YELLOW}Agent History:${NC}"
        jq -r '.agents.history | .[-5:] | .[]' "$STATE_FILE" 2>/dev/null | while read agent; do
            echo "  → $agent"
        done
    fi

    echo ""
    echo -e "${YELLOW}Recent Errors:${NC}"
    if [[ -f "$ERRORS_FILE" ]] && [[ -s "$ERRORS_FILE" ]]; then
        tail -3 "$ERRORS_FILE" | while read line; do
            local type=$(echo "$line" | jq -r '.type')
            local resolved=$(echo "$line" | jq -r '.resolved')
            local icon="❌"
            [[ "$resolved" == "true" ]] && icon="✅"
            echo "  $icon $type"
        done
    else
        echo "  None"
    fi

    echo ""
    echo -e "${YELLOW}Learnings:${NC} $(wc -l < "$LEARNINGS_FILE" 2>/dev/null || echo "0") patterns recorded"
}

init_state() {
    local feature="${1:-unnamed}"
    local stack="${2:-frontend}"

    mkdir -p "$SPECTRE_DIR"

    cat > "$STATE_FILE" << EOF
{
    "workflow": "feature",
    "feature": "$feature",
    "stack": "$stack",
    "phase": "define",
    "retryCount": 0,
    "maxRetries": 3,
    "agents": {
        "lastActive": null,
        "lastDev": null,
        "history": []
    },
    "status": "in_progress"
}
EOF

    touch "$ERRORS_FILE"
    touch "$EVENTS_FILE"
    touch "$LEARNINGS_FILE"
    echo "{}" > "$OWNERSHIP_FILE"

    echo -e "${GREEN}[SPECTRE]${NC} Initialized for feature: $feature (stack: $stack)"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    local action="${1:-}"
    shift || true

    case "$action" in
        "agent-complete")
            local agent="${1:-}"
            local input=$(cat)
            handle_agent_complete "$agent" "$input"
            ;;
        "test-result")
            local input=$(cat)
            handle_test_result "$input"
            ;;
        "error")
            local agent="${1:-unknown}"
            local message="${2:-$(cat)}"
            handle_error "$agent" "$message"
            ;;
        "ownership")
            local agent="${1:-}"
            local files="${2:-}"
            update_ownership "$agent" "$files"
            ;;
        "status")
            show_status
            ;;
        "init")
            local feature="${1:-unnamed}"
            local stack="${2:-frontend}"
            init_state "$feature" "$stack"
            ;;
        *)
            echo "Spectre Router - Intelligent multi-agent routing"
            echo ""
            echo "Usage: spectre-router.sh <action> [args]"
            echo ""
            echo "Actions:"
            echo "  agent-complete <agent>     Agent finished (reads context from stdin)"
            echo "  test-result                Parse test output (reads from stdin)"
            echo "  error <agent> [message]    Record an error"
            echo "  ownership <agent> <files>  Track file ownership"
            echo "  status                     Show current state"
            echo "  init <feature> [stack]     Initialize new workflow"
            echo ""
            echo "Stacks: frontend, backend, fullstack"
            exit 1
            ;;
    esac
}

main "$@"
