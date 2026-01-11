#!/bin/bash

for file in *; do
    # пропускаем каталоги и сам скрипт
    if [ -f "$file" ] && [ "$file" != "${0##*/}" ]; then
        # получаем расширение файла
        extension="${file##*.}"
        filename="${file%.*}"
        
        # если файл без расширения или расширение совпадает с именем
        if [ "$filename" = "$file" ] || [ "$filename" = "" ]; then
            extension=""
            base_name="$file"
        else
            base_name="$filename"
        fi
        
        # вычисляем MD5-сумму
        md5sum_result=$(md5sum "$file" | awk '{print $1}')
        
        # проверяем, существует ли уже файл с таким именем
        if [ -n "$extension" ]; then
            new_name="${md5sum_result}.${extension}"
        else
            new_name="$md5sum_result"
        fi
        
        # если файл с таким именем уже существует, добавляем суффикс
        counter=1
        while [ -e "$new_name" ] && [ "$md5sum_result" = "$(md5sum "$new_name" | awk '{print $1}')" ]; do
            if [ -n "$extension" ]; then
                new_name="${md5sum_result}_${counter}.${extension}"
            else
                new_name="${md5sum_result}_${counter}"
            fi
            ((counter++))
        done
        
        # переименовываем файл, только если имя изменилось
        if [ "$file" != "$new_name" ]; then
            echo "Переименовываем: $file в $new_name"
            mv -n "$file" "$new_name" 2>/dev/null || echo "Ошибка переименования: $file"
        fi
    fi
done

echo "Все файлы переименованы в их MD5-суммы"
