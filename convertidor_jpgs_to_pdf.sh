#  convertidor_jpgs_to_pdf.sh
#  
#  El siguiente script conviertes todas las fotos dentro de la carpeta
#  que se coloque este archivo a pdf y luego contatena esos pdf en un solo 
#  documento pdf nombrado "resultado.pdf" para que el documento le quede en
#  una secuencia deseada nombre los archivos de imagenes de forma que cuando
#  se ordenen alfabeticamente esten en el orden deseado. 
#  

for f in `ls *.jpg`;do  sam2p $f PDF: $f.pdf ; done
pdftk *.pdf cat output resultado.pdf
for f in `ls *.jpg`;do rm $f.pdf ; done
