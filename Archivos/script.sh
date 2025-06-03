#!/bin/bash

dd if=/dev/zero of=disco_prueba.img bs=1M count=1024

# 2. Formatear como ext4
mkfs.ext4 disco_prueba.img

# 3. Montar la imagen
sudo mkdir -p /mnt/disco_prueba
sudo mount -o loop disco_prueba.img /mnt/disco_prueba

# 4. Crear archivos dentro del disco montado
sudo bash -c 'echo "Este es un documento de prueba." > /mnt/disco_prueba/documento.txt'
sudo bash -c 'echo "#!/bin/bash" > /mnt/disco_prueba/script.sh'
sudo bash -c 'echo "echo Hola mundo" >> /mnt/disco_prueba/script.sh'
sudo chmod +x /mnt/disco_prueba/script.sh

# 5. Borrar de manera forense el archivo 
sudo shred -u -v /mnt/disco_prueba/documento.txt

# 6. Desmontar el disco
sudo umount /mnt/disco_prueba

# 7. Crear una imagen forense del disco 
sudo mkdir -p evidencia
sudo dc3dd if=disco_prueba.img of=evidencia/imagen_forense.dd hash=md5 log=evidencia/registro_forense.txt

# 8. Recuperar archivos 
echo "Recuperando archivos eliminados:"
inode=$(fls -r -o 0 evidencia/imagen_forense.dd | grep 'documento.txt' | awk '{print $1}' | sed 's/://')
sudo icat -o 0 evidencia/imagen_forense.dd $inode > evidencia/documento_recuperado.txt
