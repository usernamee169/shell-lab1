#2. Shell-программа периодически с некоторым интервалом удаляет все временные файлы с указанным суффиксом (например, .tmp)
#в поддереве, начиная с каталога, имя которого задано параметром Shell-программы и ведет лог действий формата:
#дата/время     : удалённые файлы
#15.02.09T21:00 : file1 file2 file3



#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Ошибка: неверное количество аргументов(!=3)" >&2
    exit 1
fi

TARGET_DIR="$1"
SUFFIX="$2"
INTERVAL="$3"
#лог в текущей директории откуда запускается скрипт
LOG_FILE="./tmp_cleaner.log"

# проверка существования директории
if [ ! -d "$TARGET_DIR" ]; then
    echo "Ошибка: директория '$TARGET_DIR' не существует" >&2
    exit 1
fi

# проверка что интервал положительное целое число
if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]] ; then
    echo "Ошибка: интервал должен быть положительным числом (в секундах)" >&2
    exit 1
fi

# проверка/создание лога в текущей директории
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    echo "Создан лог в текущей директории: $LOG_FILE" >&2
fi

echo "Запуск очистки временных файлов с суффиксом '$SUFFIX'"
echo "Директория: $TARGET_DIR"
echo "Интервал: $INTERVAL секунд"
echo "Лог-файл: $LOG_FILE"




while true; do
    # получаем текущую дату и  время
    TIMESTAMP=$(date +"%y.%m.%dT%H:%M")
    
    #переходим в целевую директорию
    cd "$TARGET_DIR"
    # ищем файлы с нужным суффиксом
    DELETED_FILES=$(find . -type f -name "*$SUFFIX")
    
    if [ -n "$DELETED_FILES" ]; then
        # удаляем файлы и получаем список удаленных
        COUNT=0
        DELETED_LIST=""
        
        for file in $DELETED_FILES; do
            if rm -f "$file"; then
                DELETED_LIST="$DELETED_LIST $clean_file"
                COUNT=$((COUNT + 1))
            fi
        done
        
        # возвращаемся в исходную директорию
        cd - 
        
        # записываем в лог
        echo "$TIMESTAMP :$DELETED_LIST" >> "$LOG_FILE"
        
        
        echo "[$TIMESTAMP] Удалено $COUNT файлов с суффиксом '$SUFFIX'"
    else
        cd -
        echo "[$TIMESTAMP] Файлы с суффиксом '$SUFFIX' не найдены"
    fi
    
    # ждем указанный интервал
    sleep "$INTERVAL"
done
