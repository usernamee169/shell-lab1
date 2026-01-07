#4. На языке unix shell написать программу, которая переводит имена подкаталогов текущего каталога в латиницу.

#!/bin/bash

# Функция для транслитерации кириллицы в латиницу
transliterate() {
    echo "$1" | sed -e 's/а/a/g' -e 's/б/b/g' -e 's/в/v/g' -e 's/г/g/g' \
                   -e 's/д/d/g' -e 's/е/e/g' -e 's/ё/yo/g' -e 's/ж/zh/g' \
                   -e 's/з/z/g' -e 's/и/i/g' -e 's/й/y/g' -e 's/к/k/g' \
                   -e 's/л/l/g' -e 's/м/m/g' -e 's/н/n/g' -e 's/о/o/g' \
                   -e 's/п/p/g' -e 's/р/r/g' -e 's/с/s/g' -e 's/т/t/g' \
                   -e 's/у/u/g' -e 's/ф/f/g' -e 's/х/h/g' -e 's/ц/ts/g' \
                   -e 's/ч/ch/g' -e 's/ш/sh/g' -e 's/щ/sch/g' -e 's/ъ//g' \
                   -e 's/ы/y/g' -e 's/ь//g' -e 's/э/e/g' -e 's/ю/yu/g' \
                   -e 's/я/ya/g' \
                   -e 's/А/A/g' -e 's/Б/B/g' -e 's/В/V/g' -e 's/Г/G/g' \
                   -e 's/Д/D/g' -e 's/Е/E/g' -e 's/Ё/Yo/g' -e 's/Ж/Zh/g' \
                   -e 's/З/Z/g' -e 's/И/I/g' -e 's/Й/Y/g' -e 's/К/K/g' \
                   -e 's/Л/L/g' -e 's/М/M/g' -e 's/Н/N/g' -e 's/О/O/g' \
                   -e 's/П/P/g' -e 's/Р/R/g' -e 's/С/S/g' -e 's/Т/T/g' \
                   -e 's/У/U/g' -e 's/Ф/F/g' -e 's/Х/H/g' -e 's/Ц/Ts/g' \
                   -e 's/Ч/Ch/g' -e 's/Ш/Sh/g' -e 's/Щ/Sch/g' -e 's/Ъ//g' \
                   -e 's/Ы/Y/g' -e 's/Ь//g' -e 's/Э/E/g' -e 's/Ю/Yu/g' \
                   -e 's/Я/Ya/g'
}

# Обрабатываем только подкаталоги (не включая текущий каталог)
find . -maxdepth 1 -type d ! -path . | while read dir; do
    if [ -d "$dir" ]; then
        base_name=$(basename "$dir")
        new_name=$(transliterate "$base_name")
        
        # Переименовываем только если имя изменилось
        if [ "$base_name" != "$new_name" ]; then
            echo "Переименовываем: '$base_name' -> '$new_name'"
            mv "$dir" "$new_name"
        fi
    fi
done

echo "Готово! Все подкаталоги переведены в латиницу."
