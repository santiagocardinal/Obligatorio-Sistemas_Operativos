# ==================================================
# Makefile del proyecto myBackup
#
# Permite compilar el programa en C
# encargado de la rotacion de backups.
# ==================================================

CC = gcc

CFLAGS = -Wall -Wextra -std=c99

.PHONY: all clean

all: rotar_backups

rotar_backups: rotar_backups.c
	$(CC) $(CFLAGS) rotar_backups.c -o rotar_backups

clean:
	rm -f rotar_backups
