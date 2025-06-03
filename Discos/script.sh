#!/bin/bash

# 1. Crear imagen de disco virtual
dd if=/dev/zero of=disco_nuevo.img bs=1M count=500

# 2. Formatear como ext4
mkfs.ext4 disco_nuevo.img

# 3. Montar y crear archivo de prueba
sudo mkdir /mnt/disco
sudo mount -o loop disco_nuevo.img /mnt/disco
sudo touch /mnt/prueba_disco/ejemplo.txt
udo umount /mnt/disco

# 4. Corromper el superbloque principal
sudo dd if=/dev/urandom of=disco_nuevo.img bs=1024 count=2 seek=1 conv=notrunc

# 5. Intentar montar para comprobar que se corropio correctamente
echo "Intentando montar disco dañado (debe fallar):"
sudo mount -o loop disco_nuevo.img /mnt/disco   || echo "Esta corrupto"

# 6. Mostrar superbloques alternativos
echo "Buscando superbloques alternativos:"
sudo mkfs.ext4 -n disco_nuevo.img

# 7. Intentar reparar usando el superbloque alternativo
echo "Intentando reparar con superbloque alternativo"
sudo fsck.ext4 -v -y -b 32768 disco_nuevo.img

# 8. Volver a montar si se recuperó
echo "Montando después de reparación:"
sudo mount -o loop disco_nuevo.img /mnt/disco
ls -l /mnt/disco
