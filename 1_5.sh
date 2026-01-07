#5. На языке unix shell написать программу, которая заменяет имена файлов текущего каталога на их md5-сумму:
#kartinko.jpg —> aab9fa58b9b58f00d1e6b037dc94c1c0.jpg
#animashka.gif —> 4dbb610d0b0157c163a47d346d4c9e2c.gif
#Cуффикс файла сохраняется
 


#!/bin/bash

for file in *; do
    # Пропускаем каталоги и сам скрипт
    if [ -f "$file" ] && [ "$file" != "${0##*/}" ]; then
        # Получаем расширение файла
        extension="${file##*.}"
        filename="${file%.*}"
        
        # Если файл без расширения
        if [ "$filename" = "$file" ]; then
            extension=""
        fi
        
        # Вычисляем MD5-сумму
        md5sum_result=$(md5sum "$file" | awk '{print $1}')
        
        # Формируем новое имя файла
        if [ -n "$extension" ]; then
            new_name="${md5sum_result}.${extension}"
        else
            new_name="$md5sum_result"
        fi
        
        # Переименовываем файл
        echo "Переименовываем: $file -> $new_name"
        mv "$file" "$new_name"
    fi
done

echo "Готово! Все файлы переименованы в их MD5-суммы."
