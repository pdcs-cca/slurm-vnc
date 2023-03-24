# slurm-vnc
Script para solicitar una sesión vnc en el cluster

Requisitos:

MATE Desktop
Tiger VNC
NoVNC
Websockify
Nginx

Se puede solicitar la sesión mediante la siguiente instrucción:

~~~bash
sbatch --wrap=run_VNC-Dbus.sh
~~~


En el archivo slurm-$JOBID.out se  reporta la URL de acceso a la sesión. por ejemplo

~~~bash
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
URL para conexión de usuario soporte:

Se recomienda ejecutar dentro de una sesión "screen" o "tmux". 

Para terminar la sesión VNC presionar Ctrl+C. 

https://tlaloc.atmosfera.unam.mx/rew/5022/soporte/172.17.1.5/10500/be0382572   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

~~~
