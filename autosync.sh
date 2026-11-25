#!/usr/bin/env bash
set -u

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_dir"

log() {
    printf '%s autosync: %s\n' "$(date --iso-8601=seconds)" "$*"
}

push_pending() {
    local ahead
    ahead="$(git rev-list --count origin/main..HEAD 2>/dev/null || printf '0')"
    ((ahead > 0)) || return 0

    if git push origin HEAD:main; then
        git update-ref refs/remotes/origin/main HEAD
        log "pushed changes to origin/main"
        return 0
    fi

    log "push failed; fetching and trying to rebase"
    if ! git fetch origin main; then
        log "fetch failed; will retry"
        return 1
    fi

    if ! git rebase origin/main; then
        git rebase --abort >/dev/null 2>&1 || true
        log "rebase conflict; resolve it in the repo, then autosync will retry"
        return 1
    fi

    if git push origin HEAD:main; then
        git update-ref refs/remotes/origin/main HEAD
        log "pushed rebased changes to origin/main"
        return 0
    fi

    log "push still failed; will retry"
    return 1
}

while true; do
    event_status=0
    inotifywait --quiet --recursive --timeout 60 \
        --event close_write,create,delete,moved_to,moved_from,attrib \
        --exclude '(^|/)\.git(/|$)' "$repo_dir" >/dev/null 2>&1 || event_status=$?

    if ((event_status == 1)); then
        log "file watcher failed; retrying in 30 seconds"
        sleep 30
        continue
    fi

    if ((event_status == 0)); then
        sleep 3
    fi

    git add --all
    if ! git diff --cached --quiet; then
        if git commit -m "autosync: $(date -u +%Y-%m-%dT%H:%M:%SZ)"; then
            log "committed repository changes"
        else
            log "commit failed; check git status and identity"
            sleep 30
            continue
        fi
    fi

    push_pending || true
done
