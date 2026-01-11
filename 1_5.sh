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
        
        # Если файл без расширения или расширение совпадает с именем (точка в начале)
        if [ "$filename" = "$file" ] || [ "$filename" = "" ]; then
            extension=""
            base_name="$file"
        else
            base_name="$filename"
        fi
        
        # Вычисляем MD5-сумму
        md5sum_result=$(md5sum "$file" | awk '{print $1}')
        
        # Проверяем, существует ли уже файл с таким именем
        if [ -n "$extension" ]; then
            new_name="${md5sum_result}.${extension}"
        else
            new_name="$md5sum_result"
        fi
        
        # Если файл с таким именем уже существует, добавляем суффикс
        counter=1
        while [ -e "$new_name" ] && [ "$md5sum_result" = "$(md5sum "$new_name" | awk '{print $1}')" ]; do
            if [ -n "$extension" ]; then
                new_name="${md5sum_result}_${counter}.${extension}"
            else
                new_name="${md5sum_result}_${counter}"
            fi
            ((counter++))
        done
        
        # Переименовываем файл, только если имя изменилось
        if [ "$file" != "$new_name" ]; then
            echo "Переименовываем: $file -> $new_name"
            mv -n "$file" "$new_name" 2>/dev/null || echo "Ошибка переименования: $file"
        fi
    fi
done

echo "Готово! Все файлы переименованы в их MD5-суммы."
