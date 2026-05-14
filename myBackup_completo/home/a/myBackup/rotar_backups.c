/*
==================================================
rotar_backups.c

Programa desarrollado en C.

Se encarga de eliminar backups antiguos
cuando se supera el maximo permitido.
==================================================
*/

#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <sys/stat.h>

/*
==================================================
Funcion: comparar_fecha

Compara la fecha de modificacion de dos archivos.
Se utiliza para ordenar backups del mas nuevo
al mas viejo.
==================================================
*/

int comparar_fecha(const void *a, const void *b) {

    struct stat sa;
    struct stat sb;

    stat(*(const char **)a, &sa);
    stat(*(const char **)b, &sb);

    return sb.st_mtime - sa.st_mtime;
}

/*
==================================================
Funcion principal

Lee los backups existentes dentro del directorio.
Si la cantidad supera el maximo permitido,
elimina los mas antiguos.
==================================================
*/

int main(int argc, char *argv[]) {

    if (argc != 3) {

        printf("Uso: %s <directorio> <max>\n", argv[0]);

        return 1;
    }

    char *directorio = argv[1];

    int max = atoi(argv[2]);

    DIR *dir = opendir(directorio);

    if (!dir) {

        perror("opendir");

        return 1;
    }

    struct dirent *entrada;

    char **lista = malloc(sizeof(char *) * 1000);

    int cantidad = 0;

    while ((entrada = readdir(dir)) != NULL) {

        if (strncmp(entrada->d_name, "backup_", 7) == 0) {

            char ruta[1024];

            snprintf(ruta, sizeof(ruta), "%s/%s", directorio, entrada->d_name);

            lista[cantidad] = malloc(strlen(ruta) + 1);

            strcpy(lista[cantidad], ruta);

            cantidad++;
        }
    }

    closedir(dir);

    if (cantidad <= max) {

        for (int i = 0; i < cantidad; i++) {

            free(lista[i]);
        }

        free(lista);

        return 0;
    }

    qsort(lista, cantidad, sizeof(char *), comparar_fecha);

    for (int i = max; i < cantidad; i++) {

        if (remove(lista[i]) == 0) {

            printf("Eliminado: %s\n", lista[i]);

        } else {

            perror("remove");
        }
    }

    for (int i = 0; i < cantidad; i++) {

        free(lista[i]);
    }

    free(lista);

    return 0;
}
