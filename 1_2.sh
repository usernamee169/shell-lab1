#2. Shell-программа периодически с некоторым интервалом удаляет все временные файлы с указанным суффиксом (например, .tmp)
#в поддереве, начиная с каталога, имя которого задано параметром Shell-программы и ведет лог действий формата:
#дата/время     : удалённые файлы
#15.02.09T21:00 : file1 file2 file3


#!/bin/bash

# Проверка количества аргументов
if [ $# -ne 3 ]; then
    echo "Ошибка: неверное количество аргументов" >&2
    echo "Использование: $0 <директория> <суффикс> <интервал_в_секундах>" >&2
    echo "Пример: $0 /tmp .tmp 60" >&2
    exit 1
fi

TARGET_DIR="$1"
SUFFIX="$2"
INTERVAL="$3"
# Лог-файл в текущей директории (откуда запускается скрипт)
LOG_FILE="./tmp_cleaner.log"

# Проверка существования директории
if [ ! -d "$TARGET_DIR" ]; then
    echo "Ошибка: директория '$TARGET_DIR' не существует" >&2
    exit 2
fi

# Проверка что интервал - число
if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]] || [ "$INTERVAL" -le 0 ]; then
    echo "Ошибка: интервал должен быть положительным числом (в секундах)" >&2
    exit 3
fi

# Проверка/создание лог-файла в текущей директории
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    echo "Создан лог-файл в текущей директории: $LOG_FILE" >&2
fi

echo "Запуск очистки временных файлов с суффиксом '$SUFFIX'"
echo "Директория: $TARGET_DIR"
echo "Интервал: $INTERVAL секунд"
echo "Лог-файл: $LOG_FILE"
echo "Для остановки нажмите Ctrl+C"
echo "------------------------------------------------------"

# Основной цикл очистки
while true; do
    # Получаем текущую дату и время в нужном формате
    TIMESTAMP=$(date +"%y.%m.%dT%H:%M")
    
    # Ищем и удаляем файлы, собираем список удаленных
    DELETED_FILES=$(find "$TARGET_DIR" -type f -name "*$SUFFIX" 2>/dev/null)
    
    if [ -n "$DELETED_FILES" ]; then
        # Удаляем файлы и получаем список удаленных
        COUNT=0
        DELETED_LIST=""
        
        for file in $DELETED_FILES; do
            if rm -f "$file" 2>/dev/null; then
                DELETED_LIST="$DELETED_LIST $(basename "$file")"
                COUNT=$((COUNT + 1))
            fi
        done
        
        # Записываем в лог
        echo "$TIMESTAMP :$DELETED_LIST" >> "$LOG_FILE"
        
        # Выводим информацию на экран
        echo "[$TIMESTAMP] Удалено $COUNT файлов с суффиксом '$SUFFIX'"
    else
        echo "[$TIMESTAMP] Файлы с суффиксом '$SUFFIX' не найдены"
    fi
    
    # Ждем указанный интервал
    sleep "$INTERVAL"
done
