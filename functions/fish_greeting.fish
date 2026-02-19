function fish_greeting
	set -l brew_cache ~/.cache/fish/brew_outdated
	set -l showed_brew 0

	if test -s $brew_cache
		set -l packages (cat $brew_cache)
		set -l count (count $packages)

		set_color yellow
		if test $count -eq 1
			echo "$count Homebrew package outdated:"
		else
			echo "$count Homebrew packages outdated:"
		end
		set_color normal
		for pkg in $packages
			echo "  $pkg"
		end
		echo
		echo -n "Run: "
		set_color cyan
		echo "brew upgrade"
		set_color normal
		set showed_brew 1
	end

	set -l pr_cache ~/.cache/fish/gh_review_requests
	if test -s $pr_cache
		if test $showed_brew -eq 1
			echo
		end
		__gh_reviews_display
		# Record displayed hash so postexec hook doesn't re-show in this session
		set -g __gh_reviews_displayed_hash (md5 -q $pr_cache)
	end
end
