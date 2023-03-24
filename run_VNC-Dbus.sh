#!/bin/bash -l 

VNCPASS=$(echo $RANDOM | md5sum | tr -d -- -)

test ! -d $HOME/.vnc &&  mkdir -p $HOME/.vnc
echo "$VNCPASS" | vncpasswd -f > $HOME/.vnc/passwd 
chmod 600 $HOME/.vnc/passwd 

VNCDISPLAY=$(($(id -u) + 1100))
export DISPLAY=":$VNCDISPLAY"

echo "#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export DISPLAY=$DISPLAY
/usr/bin/dbus-launch --exit-with-session /usr/bin/mate-session
" > $HOME/.vnc/xstartup
chmod 755 $HOME/.vnc/xstartup 


vncserver -kill :$VNCDISPLAY &>/dev/null 
rm -fv $HOME/.vnc/*.{log,pid} $HOME/.ICEauthority $HOME/.Xauthority /tmp/.X$VNCDISPLAY-lock /tmp/.X11-unix/X$VNCDISPLAY #&>/dev/null

WEBVNC=$((8900+$VNCDISPLAY))
VNCSERVER=$((5900+$VNCDISPLAY))

vncserver :$VNCDISPLAY -desktop "Desktop $USER"  -localhost -AlwaysShared -AcceptKeyEvents \
	-AcceptPointerEvents -AcceptSetDesktopSize -SendCutText -AcceptCutText -autokill 


sleep 5s
pgrep -lf tigervnc -u $USER 
if [ $? -gt 0 ]; then 
echo "
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
ERROR EN EL COMANDO:
vncserver :$VNCDISPLAY -desktop \"Desktop $USER\"  -localhost -AlwaysShared -AcceptKeyEvents \
    -AcceptPointerEvents -AcceptSetDesktopSize -SendCutText -AcceptCutText -autokill

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
exit 1
else 

pstree -u $USER 

fi

#echo "--------- noVNC WEB:$WEBVNC  | vncserver: $VNCSERVER ------------"
test -z $SLURM_JOBID && SLURM_JOBID=3.1415926535897

echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
URL para conexión de usuario $USER:

Se recomienda ejecutar dentro de una sesión \"screen\" o \"tmux\". 

Para terminar la sesión VNC presionar Ctrl+C. 

https://tlaloc.atmosfera.unam.mx/rew/$SLURM_JOBID/$USER/$(hostname -i)/$WEBVNC/$VNCPASS 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" 

/opt/software/apps/websockify/websockify-0.9.0/run $WEBVNC 127.0.0.1:$VNCSERVER


