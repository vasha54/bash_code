#!/bin/bash
# @author: Luis Andrés Valido Fajardo luis.valido.umcc.cu 
# Script para realizar una salva de la BD 

#Directorio donde se va hacer una salva
path_parent_store="/opt/salva"

#Ruta donde se guardará la salva de la BD 
#Advertencia el directorio debe existir previamente 
backup_path_database="/opt/salva/BD"


#Directorio donde se va almacenar los logs de las salvas. 
#Advertencia el directorio debe existir previamente
path_log="/opt/salva/LOG"

#Fecha en que se realiza la salva
date=$(date +"%d-%b-%Y")


#Variable que indicará el máximo de dias que va estar almacenados una salva
#. Cada vez que se haga una salva del moodle se verificará que las 
#versiones de las salvas que superen este tiempo de almacenamiento sean 
#eliminadas.
maximun_days_store=5

#Fichero donde se guardará los sucesos ocurridos durante el proceso de salva del
#moodle el nombre del fichero tiene asociado la fecha de la salva.
file_log=backup-moodle-cr-organizacional-bd-$date.log

# Se crea el directorio donde se alamacenará las salvas en caso de 
#que no exista se crea y se registra dicho suceso en el log de la salva.
if [ ! -d $path_parent_store ]
	then
		mkdir $path_parent_store
		chmod 777 -R $path_parent_store
	fi

# Se crea el directorio donde se alamacenará los logs de las salvas en caso de 
#que no exista se crea y se registra dicho suceso en el log de la salva.
if [ ! -d $path_log ]
	then
		mkdir $path_log
		chmod 777 -R $path_log
		echo Creando directorio de logs >> $path_log/$file_log
	fi	
	
	
if ! command -v mysqldump &> /dev/null
then
    echo "mysqldump could not be found"
    exit 1
fi


#Verificar si se ha proporcionado los parámetros esperados:
if [ $# -ne 4 ]; then
	echo No fueron proporcionado los parametros necesarios >> $path_log/$file_log
	exit 1
fi

#Asignar los parametros a las variables
host=$1 
db_name=$2
user=$3
password=$4


#Se registra en el log el inicio del proceso de salva
echo +++Se inicio el proceso de salva+++ >> $path_log/$file_log
#-------------Inicio del proceso de la salva de la BD del moodle---------------

#Se registra en el log el inicio del proceso de salva de la BD
echo ---Inicio del proceso de la salva de la BD--- >> $path_log/$file_log

#Creando el directorio donde se salva la BD en caso que no este creado
#el mismo
if [ ! -d $backup_path_database ]
	then
		mkdir $backup_path_database
		chmod 777 -R $backup_path_database
		echo Creando directorio de salva de las BD >> $path_log/$file_log
	fi
# Cambiando los permisos del fichero donde se va volcar la BD del moodle. 
umask 777

echo Salvando la BD en $backup_path_database/$db_name-$date.sql >> $path_log/$file_log

#Volcando la BD del Moodle en el fichero 

if mysqldump --user=$user --password=$password --host=$host $db_name 2> $path_log/$file_log  > $backup_path_database/$db_name-$date.sql
then
    echo 'Comando mysqldump ejecutado correctamente' >> $path_log/$file_log
else
    echo 'Comando mysqldump fallo en su ejecuccion' >> $path_log/$file_log
fi

echo Fin de la salva de la BD en $backup_path_database/$db_name-$date.sql >> $path_log/$file_log

#Compruebo que el archivo creado no esta vacio para no eliminar 
#las salvas anteiores 
if [ -s $backup_path_database/$db_name-$date.sql ]; then
        # La salva genero un archivo no vacio.
        echo Eliminado salva de BD viejas >> $path_log/$file_log
        
        #Eliminando salvas de la BD del moodle con más días que el valor definido en 
        #la variable maximun_days_store.
        find $backup_path_database/*.sql -mtime +$maximun_days_store -exec rm {} \; 
else
        # La salva genero un archivo vacio.
        echo 'Se genero un archivo .sql vacio' >> $path_log/$file_log
fi

echo ---Fin del proceso de la salva de la BD--- >> $path_log/$file_log
#-------------Fin del proceso de la salva de la BD-------------------

#Se registra en el log el fin del proceso de salva
echo +++Se termino el proceso de salva TODO FRES@!!!!!!!+++ >> $path_log/$file_log
