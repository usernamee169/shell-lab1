#1. Shell-программа подсчитывает количество и выводит список всех файлов 
#(без каталогов) в порядке уменьшения их длин в поддереве, начиная с каталога,
#имя которого задано параметром Shell-программы


#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Использование: $0 <каталог>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Ошибка: каталог '$1' не существует"
    exit 1
fi

find "$1" -type f -exec bash -c 'echo $(wc -c < "$1") "$1"' _ {} \; | sort -nr | awk '{print $2}'






#!/bin/bash

# Проверяем наличие параметра
if [ $# -ne 1 ]; then
    echo "Использование: $0 <путь_к_каталогу>"
    exit 1
fi

DIR="$1"

# Создаем массив для хранения файлов
FILES=()

# Рекурсивно проходим по всем файлам в каталоге
find "$DIR" -type f -print0 | while IFS= read -r -d '' file; do
    FILES+=("$file")
done

# Сортируем файлы по убыванию размера
IFS=$'\n'
sorted_files=($(sort -r -k2 -n -t: < <(for file in "${FILES[@]}"; do echo "$file:${stat -c %s "$file"}" | sort -n; done)))
IFS=' '

# Выводим результаты
echo "Список файлов по убыванию размера:"
for file in "${sorted_files[@]}"; do
    echo "$file (размер: ${file##*:})"
done
