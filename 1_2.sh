#2. Shell-программа периодически с некоторым интервалом удаляет все временные файлы с указанным суффиксом (например, .tmp)
#в поддереве, начиная с каталога, имя которого задано параметром Shell-программы и ведет лог действий формата:
#дата/время     : удалённые файлы
#15.02.09T21:00 : file1 file2 file3


#!/bin/bash

# Версия для запуска в фоне
if [ $# -ne 3 ]; then
    echo "Использование: $0 <директория> <суффикс> <интервал_в_секундах>" >&2
    echo "Пример запуска: $0 /tmp .tmp 60 &" >&2
    echo "Пример запуска: nohup $0 ~/downloads .temp 300 > /dev/null 2>&1 &" >&2
    exit 1
fi

TARGET_DIR=$(realpath "$1")
SUFFIX="$2"
INTERVAL="$3"
LOG_FILE="$HOME/tmp_cleaner_$(date +%Y%m%d_%H%M%S).log"

# Проверки
[ ! -d "$TARGET_DIR" ] && { echo "Директория не существует" >&2; exit 2; }
! [[ "$INTERVAL" =~ ^[0-9]+$ ]] && { echo "Интервал должен быть числом" >&2; exit 3; }

# Основная функция
cleanup_loop() {
    echo "Старт очистки $(date)" >> "$LOG_FILE"
    echo "Директория: $TARGET_DIR" >> "$LOG_FILE"
    echo "Суффикс: $SUFFIX" >> "$LOG_FILE"
    echo "Интервал: ${INTERVAL}с" >> "$LOG_FILE"
    
    while true; do
        TIMESTAMP=$(date +"%y.%m.%dT%H:%M")
        FILES=$(find "$TARGET_DIR" -type f -name "*$SUFFIX" 2>/dev/null | xargs -r basename -a 2>/dev/null)
        
        if [ -n "$FILES" ]; then
            # Удаляем файлы
            find "$TARGET_DIR" -type f -name "*$SUFFIX" -delete 2>/dev/null
            echo "$TIMESTAMP : $FILES" >> "$LOG_FILE"
        else
            echo "$TIMESTAMP :" >> "$LOG_FILE"
        fi
        
        sleep "$INTERVAL"
    done
}

# Запуск в фоне
cleanup_loop &
CLEANER_PID=$!

echo "Очистка запущена с PID: $CLEANER_PID"
echo "Лог: $LOG_FILE"
echo "Для остановки выполните: kill $CLEANER_PID"
