#! /bin/sh
#
# skeleton	example file to build /etc/init.d/ scripts.
#		This file should be used to construct scripts for /etc/init.d.
#
#		Written by Miquel van Smoorenburg <miquels@cistron.nl>.
#		Modified for Debian 
#		by Ian Murdock <imurdock@gnu.ai.mit.edu>.
#
# Version:	@(#)skeleton  1.9  26-Feb-2001  miquels@cistron.nl
#
### BEGIN INIT INFO
# Provides:          lastfmproxy
# Required-Start:    $remote_fs $network
# Required-Stop:     $remote_fs $network
# Should-Start:      
# Should-Stop:       
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start a proxy to listen to lastfm radio
# Description:
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/sbin/lastfmproxy
NAME=lastfmproxy
DESC=lastfmproxy
DAEMON_OPTS=/var/log/lastfmproxy/lastfmproxy.log

test -x $DAEMON || exit 0

# Include lastfmproxy defaults if available
if [ -f /etc/default/lastfmproxy ] ; then
	. /etc/default/lastfmproxy
fi

set -e

case "$1" in
  start)
	if [ "$START_LASTFMPROXY" = "false" ]; then
		echo "Not starting $DESC, see /etc/default/lastfmproxy"
		exit 0;
	fi
	echo -n "Starting $DESC: "
	start-stop-daemon --start --quiet --background --chuid $NAME \
		--exec $DAEMON -- $DAEMON_OPTS
	echo "$NAME."
	;;
  stop)
	echo -n "Stopping $DESC: "
	start-stop-daemon --stop --oknodo --quiet --user lastfmproxy --signal TERM
	echo "$NAME."
	;;
  force-reload)
	#
	#	If the "reload" option is implemented, move the "force-reload"
	#	option to the "reload" entry above. If not, "force-reload" is
	#	just the same as "restart" except that it does nothing if the
	#   daemon isn't already running.
	# check wether $DAEMON is running. If so, restart
	start-stop-daemon --stop --test --quiet --pidfile \
		/var/run/$NAME.pid --exec $DAEMON \
	&& $0 restart \
	|| exit 0
	;;
  restart)
    echo -n "Restarting $DESC: "
	start-stop-daemon --stop --oknodo --quiet --user lastfmproxy --signal TERM
	sleep 1
	start-stop-daemon --start --quiet --background --chuid $NAME \
                --exec $DAEMON -- $DAEMON_OPTS
	echo "$NAME."
	;;
  *)
	N=/etc/init.d/$NAME
	# echo "Usage: $N {start|stop|restart|reload|force-reload}" >&2
	echo "Usage: $N {start|stop|restart|force-reload}" >&2
	exit 1
	;;
esac

exit 0
