function __gh_reviews_display
	set -l pr_cache ~/.cache/fish/gh_review_requests
	if not test -s $pr_cache
		return 1
	end

	set -l lines (cat $pr_cache)
	set -l pr_count (math (count $lines) / 2)

	if test $pr_count -le 0
		return 1
	end

	set_color yellow
	if test $pr_count -eq 1
		echo "$pr_count PR awaiting your review:"
	else
		echo "$pr_count PRs awaiting your review:"
	end
	set_color normal
	echo

	set -l i 1
	while test $i -le (count $lines)
		echo "  $lines[$i]"
		set -l j (math $i + 1)
		if test $j -le (count $lines)
			set_color cyan
			echo "    $lines[$j]"
			set_color normal
		end
		set i (math $i + 2)
	end
end
