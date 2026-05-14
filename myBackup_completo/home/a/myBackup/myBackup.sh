# ==================================================
# myBackup.sh
#
# Script de backup automatico desarrollado en Bash.
#
# Permite:
# - Crear backups comprimidos o sin compresion.
# - Mantener una cantidad maxima de copias.
# - Ejecutarse automaticamente cada cierto tiempo.
# - Registrar eventos en un archivo de log.
# - Utilizar un programa en C para rotacion.
# ==================================================

#!/bin/bash

ORIGEN=""
DESTINO="$HOME/backups"

VERBOSE=false
COMPRIMIR=true

INTERVALO=0
MAX_COPIAS=5

CONF_FILE="$HOME/.myBackup.conf"

LOG_FILE="$HOME/.mybackup.log"

# ==================================================
# Funcion: log
#
# Guarda mensajes en un archivo de log.
# Si el modo verbose esta activado,
# tambien muestra mensajes por pantalla.
# ==================================================

log() {

    local nivel="$1"

    local mensaje="$2"

    local fecha=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$fecha] [$nivel] $mensaje" >> "$LOG_FILE"

    if $VERBOSE; then

        echo "[$nivel] $mensaje"
    fi
}

# ==================================================
# Funcion: mostrar_ayuda
#
# Muestra las opciones disponibles
# para ejecutar el script.
# ==================================================

mostrar_ayuda() {

    echo "Uso:"

    echo "myBackup [opciones]"

    echo ""

    echo "-d origen:destino"

    echo "-v verbose"

    echo "-n sin compresion"

    echo "-t segundos"

    echo "-m maximo backups"

    echo "-h ayuda"
}

# ==================================================
# Funcion: cargar_configuracion
#
# Carga los parametros guardados
# en el archivo de configuracion.
# ==================================================

cargar_configuracion() {

    if [ -f "$CONF_FILE" ]; then

        source "$CONF_FILE"
    fi
}

# ==================================================
# Funcion: verificar_dependencias
#
# Verifica que las herramientas necesarias
# para ejecutar el sistema existan.
# ==================================================

verificar_dependencias() {

    if ! command -v tar &>/dev/null; then

        echo "[ERROR] tar no instalado"

        exit 1
    fi

    if [ ! -f "./rotar_backups" ]; then

        echo "[ERROR] rotar_backups no compilado"

        exit 1
    fi
}

# ==================================================
# Funcion: hacer_backup
#
# Crea un backup del directorio origen.
# Puede comprimir o no comprimir.
# Luego ejecuta la rotacion de backups.
# ==================================================

hacer_backup() {

    if [ ! -d "$ORIGEN" ]; then

        log "ERROR" "Origen inexistente"

        exit 1
    fi

    mkdir -p "$DESTINO"

    FECHA=$(date +%Y%m%d_%H%M%S)

    ARCHIVO="$DESTINO/backup_$FECHA"

    if $COMPRIMIR; then

        ARCHIVO="$ARCHIVO.tar.gz"

        tar -czf "$ARCHIVO" -C "$ORIGEN" .

    else

        ARCHIVO="$ARCHIVO.tar"

        tar -cf "$ARCHIVO" -C "$ORIGEN" .
    fi

    if [ $? -eq 0 ]; then

        log "INFO" "Backup exitoso: $ARCHIVO"

        ./rotar_backups "$DESTINO" "$MAX_COPIAS"

    else

        log "ERROR" "Fallo backup"

        exit 1
    fi
}

cargar_configuracion

# ==================================================
# Lectura de parametros
#
# Procesa las opciones ingresadas
# por linea de comandos.
# ==================================================

while getopts "d:vnt:m:h" opt
do

    case $opt in

        d)

            IFS=':' read -r ORIGEN DESTINO <<< "$OPTARG"

            ORIGEN=$(eval echo "$ORIGEN")

            DESTINO=$(eval echo "$DESTINO")

            ;;

        v)

            VERBOSE=true
            ;;

        n)

            COMPRIMIR=false
            ;;

        t)

            INTERVALO="$OPTARG"
            ;;

        m)

            MAX_COPIAS="$OPTARG"
            ;;

        h)

            mostrar_ayuda

            exit 0
            ;;
    esac

done

verificar_dependencias

if [ "$INTERVALO" -gt 0 ]; then

    while true
    do

        hacer_backup

        sleep "$INTERVALO"

    done

else

    hacer_backup

fi
