# Example:
#
# ```
# local old_options=$(bash_save_options)
# set +u
#
# do_something
#
# bash_restore_options "$old_options"
# ```
#
# Credits: https://unix.stackexchange.com/questions/310957/how-to-restore-the-value-of-shell-options-like-set-x/310963
#
bash_save_options() {
    echo "$(set +o); set -$-" # POSIXly store all set options.
}

bash_restore_options() {
    local oldstate=$1
    
    set -vx; eval "$oldstate" # restore all options stored.
}
