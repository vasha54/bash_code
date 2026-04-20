# /usr/bin

#!/bin/bash

# Función que crea un directorio con el nombre basado en $linea
make_addons_company_data_import() {
    local name_base="$1"
    local directory_base="desoft_mtz_company_data_import_${name_base}"
    
    if [ -d "$directory_base" ]; then
        echo "El directorio '$directory_base' ya existe. No se crea."
    else
        mkdir -p "$directory_base"
        echo "Directorio creado: $directory_base"
    fi

    if [ -d "$directory_base/data" ]; then
        echo "El directorio '$directory_base/data' ya existe. No se crea."
    else
        mkdir -p "$directory_base/data"
        echo "Directorio creado: $directory_base/data"
    fi

    if [ -d "$directory_base/static" ]; then
        echo "El directorio '$directory_base/static' ya existe. No se crea."
    else
        mkdir -p "$directory_base/static"
        echo "Directorio creado: $directory_base/static"
    fi

    if [ -d "$directory_base/static/description" ]; then
        echo "El directorio '$directory_base/static/description' ya existe. No se crea."
    else
        mkdir -p "$directory_base/static/description"
        echo "Directorio creado: $directory_base/static/description"
    fi

    if [ -f "$directory_base/__init__.py" ]; then
        echo "El fichero '$directory_base/__init__.py' ya existe. No se crea."
    else
        touch "$directory_base/__init__.py"
        echo "Fichero creado: $directory_base/__init__.py"
    fi

    if [ -f "$directory_base/__manifest__.py" ]; then
        echo "El fichero '$directory_base/__manifest__.py' ya existe. No se crea."
    else
        touch "$directory_base/__manifest__.py"
        echo "Fichero creado: $directory_base/__manifest__.py"
    fi

    if [ -f "$directory_base/data/$name_base.xml" ]; then
        echo "El directorio '$directory_base/data/$name_base.xml' ya existe. No se crea."
    else
        cp xml/$name_base.xml $directory_base/data/
        echo "Fichero movido: $directory_base/data/$name_base.xml"
    fi
}

make_manifest_addons(){
    local name_base="$1"
    local directory_base="desoft_mtz_company_data_import_${name_base}"
    local file="$directory_base/__manifest__.py"
    echo { >> $file
    echo "  'name': 'Desoft MTZ - Company Data Import - ,  - $1'," >> $file
    echo "  'summary': ''," >> $file
    echo "  'author': 'Desoft Matanzas'," >> $file
    echo "  'website': 'https://www.desoft.cu'," >> $file
    echo "  'license': 'AGPL-3'," >> $file
    echo "  'category': 'Tools'," >> $file
    echo "  'version': '0.1'," >> $file
    echo "  'depends': [" >> $file
    echo "      'base'," >> $file
    echo "      'desoft_mtz_company'," >> $file
    echo "      'desoft_mtz_company_data_import'," >> $file
    echo "  ]," >> $file
    echo "  'data': [" >> $file
    echo "      'data/$1.xml'," >> $file
    echo "  ]," >> $file
    echo "  'demo': []," >> $file
    echo "  'installable': True," >> $file
    echo "  'auto_install': False," >> $file
    echo "  'application': False," >> $file
    echo "  'sequence': 1," >> $file
    echo } >> $file
}


# Verificar si se ha proporcionado un argumento
if [ $# -eq 0 ]; then
    echo "Uso: $0 <nombre_del_fichero>"
    echo "Ejemplo: $0 addons.txt"
    exit 1
fi

FICHERO="$1"

# Verificar si el fichero existe
if [ ! -f "$FICHERO" ]; then
    echo "Error: El fichero '$FICHERO' no existe."
    exit 1
fi

# Leer el fichero línea por línea
while IFS= read -r linea; do
    # Aquí puedes procesar cada línea (por ejemplo, mostrarla)
    echo "Creando addons para: $linea"
    make_addons_company_data_import "$linea"
    make_manifest_addons "$linea"
done < "$FICHERO"