if not status is-interactive; or not command -q brew
	return
end

set -l cache_file ~/.cache/fish/brew_outdated

set -l stale 1
if test -f $cache_file
	set -l age (math (date +%s) - (stat -f %m $cache_file))
	if test $age -lt 3600
		set stale 0
	end
end

if test $stale -eq 1
	fish -c "
		mkdir -p ~/.cache/fish
		brew update --quiet
		brew outdated -q --greedy > ~/.cache/fish/brew_outdated
	" &>/dev/null &
	disown
end
