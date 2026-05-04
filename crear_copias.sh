#!/bin/bash

# Activar nullglob para que los patrones sin coincidencias no se expandan literalmente
shopt -s nullglob

# Definir los patrones a buscar en el directorio actual (sin recursión)
patrones=("icon_[0-9][0-9][0-9][0-9].png" "icon_[0-9][0-9][0-9][0-9].svg")

# Variable para saber si se procesó algún archivo
encontrados=0

for patron in "${patrones[@]}"; do
    for archivo in $patron; do
        # Extraer nombre base sin extensión (ej: icon_0001)
        base="${archivo%.*}"
        # Extraer la extensión (ej: png o svg)
        ext="${archivo##*.}"
        # Formar el nuevo nombre con _p antes de la extensión
        nuevo="${base}_p.${ext}"
        
        # Copiar el archivo original al nuevo nombre
        cp "$archivo" "$nuevo"
        echo "Creado: $nuevo (copia de $archivo)"
        encontrados=1
    done
done

if [ $encontrados -eq 0 ]; then
    echo "No se encontraron archivos con el formato icon_xxxx.png o icon_xxxx.svg"
fi