#!/bin/bash
# @author: Luis Andrés Valido Fajardo luis.valido1989@gmail.com +53 53694742 
# Script para realizar una salva de los directorios de Moodle y ficheros generados

#Directorio donde se va hacer una salva
path_parent_store="/opt/salva"

#Directorio donde se va hacer una salva de los ficheros y directorios generados
backup_path_file="/opt/salva/FILE"

#Directorio donde se va almacenar los logs de las salvas. 
path_log="/opt/salva/LOG"

#Fecha en que se realiza la salva
date=$(date +"%d-%b-%Y")

#Verificar si se ha proporcionado los parámetros esperados:
if [ $# -ne 2 ]; then
	echo The necessary parameters were not provided >> $path_log/$file_log
	exit 1
fi

#Asignar los parametros a las variables
directory_moodle=$1 
directory_moodledata=$2


#Arreglo con las rutas absolutas de los directorios y
#que son importante realizarle una salva.
path_directory_to_save=($directory_moodle $directory_moodledata)

#Variable que indicará el máximo de dias que va estar almacenados una salva
#. Cada vez que se haga una salva del moodle se verificará que las 
#versiones de las salvas que superen este tiempo de almacenamiento sean 
#eliminadas.
maximun_days_store=5

#Fichero donde se guardará los sucesos ocurridos durante el proceso de salva del
#moodle el nombre del fichero tiene asociado la fecha de la salva.
file_log=backup-moodle-cr-organizacional-directory-$date.log

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

#Se registra en el log el inicio del proceso de salva
echo +++The save process began+++ >> $path_log/$file_log
#********Inicio del proceso de la salva de los ficheros**************
echo ***Start of the file saving process*** >> $path_log/$file_log

#Creando el directorio de salva y asignandolé todos los permisos
if [ ! -d $backup_path_file ]
	then
		mkdir $backup_path_file
		chmod 777 -R $backup_path_file
		echo Creating general directory to save files and directory >> $path_log/$file_log
	fi

#Creando dentro directorio de salva el corresponiente al de la fecha de la salva
#actual y asignandolé todos los permisos a este directorio que va tener como
#nombre la fecha de la salva.
echo Creating jungle-specific directory corresponding to cr-institucional-$date >> $path_log/$file_log
mkdir $backup_path_file/cr-institucional-$date
echo Giving permission to the specific directory of the salvo corresponding to cr-institucional-$date >> $path_log/$file_log
chmod 777 -R $backup_path_file/cr-institucional-$date

#Salvando cada uno de los directorio definidos en el arreglo siempre y cuando 
#dichos directorio sean válidos los directorios se copian de forma recursiva con
#su contenido interno. De no encontrarse los directorios son registrados en
#el log para un posterior análisis.
echo Saving directories >> $path_log/$file_log
for directory in ${path_directory_to_save[*]}
	do
		echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  >> $path_log/$file_log
		echo Saving the directory $directory >> $path_log/$file_log
			if [ -d $directory ]
			then
				echo Copying the directory $directory >> $path_log/$file_log
				tar -cf $backup_path_file/cr-institucional-$date/"${directory##*/}".zip  $directory  >> $path_log/$file_log
				chmod 777 -R $backup_path_file/cr-institucional-$date
				echo End of directory copy $directory >> $path_log/$file_log
			else
				echo Could not save directory $directory for not being found >> $path_log/$file_log
			fi
		echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  >> $path_log/$file_log
	done

echo End of the salvo of the directories >> $path_log/$file_log
chmod 777 -R $backup_path_file/cr-institucional-$date


#Eliminando salvas de los ficheros y directorios con más días que
#el valor definido en la variable maximun_days_store.
echo Removed saves from old directories and files >> $path_log/$file_log 
find $backup_path_file/*/*.zip -mtime +$maximun_days_store -exec rm -r {} \; 
echo ***End of the file saving process*** >> $path_log/$file_log
#********Fin del proceso de la salva de los ficheros**************

echo Deleted logs of old salvos >> $path_log/$file_log
find $path_log/*.log -mtime +$maximun_days_store -exec rm -r {} \;


#Se registra en el log el fin del proceso de salva
echo +++The save process is finished!!!!!!!+++ >> $path_log/$file_log
