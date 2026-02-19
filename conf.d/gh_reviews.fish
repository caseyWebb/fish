if not status is-interactive; or not command -q gh
	return
end

function __gh_reviews_fetch
	mkdir -p ~/.cache/fish
	gh search prs --review-requested=@me --state=open \
		--json repository,title,number,url \
		--template '{{range .}}{{.repository.nameWithOwner}}#{{.number}} - {{.title}}{{"\n"}}{{.url}}{{"\n"}}{{end}}' \
		> ~/.cache/fish/gh_review_requests 2>/dev/null
end

# Fetch on shell startup
fish -c "
	mkdir -p ~/.cache/fish
	gh search prs --review-requested=@me --state=open \
		--json repository,title,number,url \
		--template '{{range .}}{{.repository.nameWithOwner}}#{{.number}} - {{.title}}{{\"\n\"}}{{.url}}{{\"\n\"}}{{end}}' \
		> ~/.cache/fish/gh_review_requests 2>/dev/null
" &
disown

function __gh_reviews_postexec --on-event fish_postexec
	set -l cache ~/.cache/fish/gh_review_requests

	# Background re-fetch if cache is stale (>5 min)
	if test -f $cache
		set -l age (math (date +%s) - (stat -f %m $cache))
		if test $age -ge 300
			__gh_reviews_fetch &
			disown
		end
	end

	# Change detection (per-session via global variable)
	if not test -s $cache
		return
	end

	set -l current_hash (md5 -q $cache)

	if test "$current_hash" != "$__gh_reviews_displayed_hash"
		echo
		__gh_reviews_display
		set -g __gh_reviews_displayed_hash $current_hash
	end
end
