function brew --wraps brew
    command brew $argv
    if test $status -eq 0
        switch "$argv[1]"
            case upgrade install uninstall reinstall
                rm -f ~/.cache/fish/brew_outdated
        end
    end
end
