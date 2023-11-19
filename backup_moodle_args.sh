#!/bin/bash
# @author: Luis Andrés Valido Fajardo luis.valido1989@gmail.com +53 53694742
# Script para realizar una salva de la BD al cual se le pasa por parametros 
# IP de la base de datos, nombre de la base datos, usuario y password para la
# conexion a la base datos

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
		echo Creating log directory >> $path_log/$file_log
	fi	
	
# Combrobando que existe el comando mysqldump instalado en el sistema que 
# permita volcar la BD en un fichero	
if ! command -v mysqldump &> /dev/null
then
    echo "mysqldump could not be found"
    exit 1
fi


#Verificar si se ha proporcionado los parámetros esperados:
if [ $# -ne 4 ]; then
	echo The necessary parameters were not provided >> $path_log/$file_log
	exit 1
fi

#Asignar los parametros a las variables
host=$1 
db_name=$2
user=$3
password=$4


#Se registra en el log el inicio del proceso de salva
echo +++The save process began+++ >> $path_log/$file_log
#-------------Inicio del proceso de la salva de la BD del moodle---------------

#Se registra en el log el inicio del proceso de salva de la BD
echo ---Start of the DB save process--- >> $path_log/$file_log

#Creando el directorio donde se salva la BD en caso que no este creado
#el mismo
if [ ! -d $backup_path_database ]
	then
		mkdir $backup_path_database
		chmod 777 -R $backup_path_database
		echo Creating DB save directory >> $path_log/$file_log
	fi
# Cambiando los permisos del fichero donde se va volcar la BD del moodle. 
umask 777

echo Saving the DB in $backup_path_database/$db_name-$date.sql >> $path_log/$file_log

#Volcando la BD del Moodle en el fichero 

if mysqldump --user=$user --password=$password --host=$host $db_name 2> $path_log/$file_log  > $backup_path_database/$db_name-$date.sql
then
    echo 'Comando mysqldump ejecutado correctamente' >> $path_log/$file_log
else
    echo 'Comando mysqldump fallo en su ejecuccion' >> $path_log/$file_log
fi

echo End of database save process $backup_path_database/$db_name-$date.sql >> $path_log/$file_log

#Compruebo que el archivo creado no esta vacio para no eliminar 
#las salvas anteiores 
if [ -s $backup_path_database/$db_name-$date.sql ]; then
        # La salva genero un archivo no vacio.
        echo Deleted saves from old databases >> $path_log/$file_log
        
        #Eliminando salvas de la BD del moodle con más días que el valor definido en 
        #la variable maximun_days_store.
        find $backup_path_database/*.sql -mtime +$maximun_days_store -exec rm {} \; 
else
        # La salva genero un archivo vacio.
        echo 'An empty .sql file was generated' >> $path_log/$file_log
fi

echo ---End of the DB save process--- >> $path_log/$file_log
#-------------Fin del proceso de la salva de la BD-------------------

#Se registra en el log el fin del proceso de salva
echo +++The save process is finished !!!!!!!+++ >> $path_log/$file_log
