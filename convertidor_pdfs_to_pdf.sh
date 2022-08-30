#  convertidor_jpgs_to_pdf.sh
#  
#  El siguiente script conviertes todas documentos pdf dentro de la carpeta
#  que se coloque este archivo a un solo documento pdf nombrado "resultado.pdf" 
#  para que el documento le quede en una secuencia deseada nombre los archivos 
#  de forma que cuando se ordenen alfabeticamente esten en el orden deseado. 
#  
pdftk *.pdf cat output resultado.pdf

file='portada.pdf'

for f in `ls *.pdf`;
do  
	if [ $f != $file ];
	then
		pdfjam  $file $f --outfile $file ;
	fi	 
done

echo "Termino la ejecucción"
