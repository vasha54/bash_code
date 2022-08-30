#!/bin/bash

# @author: Luis Andrés Valido Fajardo luis.valido.umcc.cu 
# Script para realizar una salva de la BD del Repositorio Institucional

# Parámetros de la BD 
user="user"
password="password"
host="localhost"
db_name="db_name"



#Ruta donde se guardará la salva de la BD
#Advertencia el directorio debe existir previamente 
backup_path_database="/opt/backupDB"

#Directorio donde se va almacenar los logs de las salvas.
#Advertencia el directorio debe existir previamente 
path_log="/opt/logBackupDB"

#Fecha en que se realiza la salva
date=$(date +"%d-%b-%Y")

#Variable que indicará el máximo de dias que va estar almacenados una salva
#. Cada vez que se haga una salva de la base datos se verificará que las 
#versiones de las salvas que superen este tiempo de almacenamiento sean 
#eliminadas.
maximun_days_store=5

#Fichero donde se guardará los sucesos ocurridos durante el proceso de salva de
#base datos el nombre del fichero tiene asociado la fecha de la salva.
file_log=backup-reimdb-umcc-cu-$date.log

# Se crea el directorio donde se alamacenará los logs de las salvas en caso de 
#que no exista se crea y se registra dicho suceso en el log de la salva.
if [ ! -d $path_log ]
	then
		mkdir $path_log
		chmod 777 -R $path_log
		echo Creando directorio de logs >> $path_log/$file_log
	fi

#Se registra en el log el inicio del proceso de salva
echo '+++Se inicio el proceso de salva+++' >> $path_log/$file_log
#-------------Inicio del proceso de la salva de la BD del Repositorio Institucional--------------

#Se registra en el log el inicio del proceso de salva de la BD
echo '---Inicio del proceso de la salva de la BD---' >> $path_log/$file_log

#Creando el directorio donde se salva la BD en caso que no este creado
#el mismo
if [ ! -d $backup_path_database ]
	then
		mkdir $backup_path_database
		chmod 777 -R $backup_path_database
		echo Creando directorio de salva de las BD >> $path_log/$file_log
	fi
# Cambiando los permisos del fichero donde se va volcar la BD del Repositorio Institucional. 
umask 777

echo Salvando la BD en $backup_path_database/$db_name-$date.sql >> $path_log/$file_log

#Volcando la BD del Repositorio institucional en el fichero 

if pg_dump -U $user $db_name 2> $path_log/$file_log  > $backup_path_database/$db_name-$date.sql
then
    echo 'Comando pg_dump ejecutado correctamente' >> $path_log/$file_log
    echo 'Cambiando los permisos al fichero de la salva' >> $path_log/$file_log
    chmod 777  $backup_path_database/$db_name-$date.sql
else
    echo 'Comando pg_dump fallo en su ejecuccion' >> $path_log/$file_log
fi

echo Fin de la salva de la BD en $backup_path_database/$db_name-$date.sql >> $path_log/$file_log

echo 'Eliminado salva de BD viejas' >> $path_log/$file_log


#Eliminando salvas de la BD del Repositorio Institucional con más días 
#que el valor definido en la variable maximun_days_store.
find $backup_path_database/*.sql -mtime +$maximun_days_store -exec rm {} \; 


echo '---Fin del proceso de la salva de la BD---' >> $path_log/$file_log
#-------------Fin del proceso de la salva de la BD-------------------

