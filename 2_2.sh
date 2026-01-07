#2. Shell-программа периодически с некоторым интервалом удаляет все временные файлы с указанным суффиксом (например, .tmp)
#в поддереве, начиная с каталога, имя которого задано параметром Shell-программы и ведет лог действий формата:
#дата/время     : удалённые файлы
#15.02.09T21:00 : file1 file2 file3




#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Использование: $0 <каталог> <суффикс> <интервал_в_секундах>"
    exit 1
fi

directory="$1"
suffix="$2"
interval="$3"

if [ ! -d "$directory" ]; then
    echo "Ошибка: каталог '$directory' не существует"
    exit 1
fi

while true; do
    # Находим файлы с указанным суффиксом
    files_to_delete=$(find "$directory" -type f -name "*$suffix")
    
    if [ -n "$files_to_delete" ]; then
        # Форматируем дату/время
        timestamp=$(date +"%y.%m.%dT%H:%M")
        
        # Удаляем файлы и записываем в лог
        echo "$timestamp : $files_to_delete" >> deletion.log
        rm -f $files_to_delete
        
        echo "$timestamp : удалены файлы: $files_to_delete"
    else
        timestamp=$(date +"%y.%m.%dT%H:%M")
        echo "$timestamp : файлы для удаления не найдены"
    fi
    
    sleep "$interval"
done
