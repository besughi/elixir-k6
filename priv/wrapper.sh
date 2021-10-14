#!/usr/bin/env sh

# Start the program in the background
exec "$@" &
program_pid=$!

# Silence warnings from here on
exec >/dev/null 2>&1

# Read from fd[3] in the background and kill running program when it closes.
# Fd[3] is the file descriptor used by the BEAM to communicate with this
# process (kind-of a fake stdin), since we are using :nouse_stdio with our port
{
  while read -u 3; do :; done
  kill -TERM $program_pid
} &

waiter_pid=$!

# Clean up
wait $program_pid
ret=$?

kill -KILL $waiter_pid

exit $ret