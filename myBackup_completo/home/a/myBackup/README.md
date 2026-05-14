# =============================================================================
# myBackup - Manual de Uso
# =============================================================================

## Sintaxis General

El sistema se ejecuta desde la terminal utilizando:

```bash
./myBackup.sh [opciones]
```

Las opciones pueden combinarse entre sí.

---

# =============================================================================
# Opciones Disponibles
# =============================================================================

| Opción | Función |
|---|---|
| -d | Define origen y destino |
| -v | Activa mensajes verbose |
| -n | Desactiva compresión |
| -t | Ejecuta backups automáticos |
| -m | Limita cantidad de backups |
| -h | Muestra ayuda |

---

# =============================================================================
# Opción: -d
# =============================================================================

## Descripción

La opción `-d` define:

- directorio origen
- directorio destino

Es la opción principal del sistema.

---

## Uso

```bash
./myBackup.sh -d origen:destino
```

---

## Ejemplo

```bash
./myBackup.sh -d $HOME/origen:$HOME/backups
```

---

# =============================================================================
# Opción: -v
# =============================================================================

## Descripción

Activa el modo verbose.

El sistema mostrará mensajes detallados durante la ejecución.

---

## Uso

```bash
./myBackup.sh -d $HOME/origen:$HOME/backups -v
```

---

## Resultado esperado

```bash
Backup creado: /home/usuario/backups/backup_fecha.tar.gz
Rotacion ejecutada
```

---

# =============================================================================
# Opción: -n
# =============================================================================

## Descripción

Desactiva la compresión.

Los backups serán generados en formato `.tar`
en lugar de `.tar.gz`.

---

## Uso

```bash
./myBackup.sh -d $HOME/origen:$HOME/backups -n
```

---

## Resultado esperado

Archivo generado:

```txt
backup_fecha.tar
```

---

# =============================================================================
# Opción: -t
# =============================================================================

## Descripción

Permite ejecutar backups automáticos periódicos.

El sistema repetirá backups cada cierta cantidad de segundos.

---

## Uso

```bash
./myBackup.sh -d $HOME/origen:$HOME/backups -t 5
```

---

## Resultado

- ejecuta un backup
- espera 5 segundos
- repite indefinidamente

---

## Ejemplo práctico

```bash
timeout 15 ./myBackup.sh -d $HOME/origen:$HOME/backups -t 5 -v
```

Este ejemplo:

- ejecuta backups cada 5 segundos
- durante 15 segundos

---

# =============================================================================
# Opción: -m
# =============================================================================

## Descripción

Define la cantidad máxima de backups permitidos.

Cuando se supera el límite,
el sistema elimina los más antiguos.

---

## Uso

```bash
./myBackup.sh -d $HOME/origen:$HOME/backups -m 3
```

---

## Resultado esperado

El sistema mantendrá únicamente las últimas 3 copias.

---

# =============================================================================
# Opción: -h
# =============================================================================

## Descripción

Muestra ayuda del sistema.

---

## Uso

```bash
./myBackup.sh -h
```

---

## Resultado esperado

```bash
Uso:
./myBackup.sh -d origen:destino [opciones]
```

---

# =============================================================================
# Ejemplo Completo
# =============================================================================

```bash
./myBackup.sh \
-d $HOME/origen:$HOME/backups \
-v \
-t 5 \
-m 3
```

---

## Qué hace este comando

- usa `/origen` como carpeta origen
- usa `/backups` como destino
- activa modo verbose
- ejecuta backups cada 5 segundos
- conserva máximo 3 backups

---

# =============================================================================
# Preparación Inicial
# =============================================================================

## Crear carpetas de prueba

```bash
mkdir ~/origen
mkdir ~/backups
```

---

## Crear archivos de prueba

```bash
echo "hola" > ~/origen/a.txt
echo "backup" > ~/origen/b.txt
```

---

## Compilar proyecto

```bash
make
```

---

## Dar permisos al script

```bash
chmod +x myBackup.sh
```

---

# =============================================================================
# Verificar Backups
# =============================================================================

Ver backups generados:

```bash
ls ~/backups
```
