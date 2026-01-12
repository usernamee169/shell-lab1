#4. На языке unix shell написать программу, которая переводит имена подкаталогов текущего каталога в латиницу.



#!/bin/bash


translate() {
    declare -A translit_map=(
        [а]="a" [б]="b" [в]="v" [г]="g" [д]="d" [е]="e" [ё]="yo" [ж]="zh"
        [з]="z" [и]="i" [й]="y" [к]="k" [л]="l" [м]="m" [н]="n" [о]="o"
        [п]="p" [р]="r" [с]="s" [т]="t" [у]="u" [ф]="f" [х]="h" [ц]="ts"
        [ч]="ch" [ш]="sh" [щ]="sch" [ъ]="" [ы]="y" [ь]="" [э]="e" [ю]="yu"
        [я]="ya"
        
        [А]="A" [Б]="B" [В]="V" [Г]="G" [Д]="D" [Е]="E" [Ё]="Yo" [Ж]="Zh"
        [З]="Z" [И]="I" [Й]="Y" [К]="K" [Л]="L" [М]="M" [Н]="N" [О]="O"
        [П]="P" [Р]="R" [С]="S" [Т]="T" [У]="U" [Ф]="F" [Х]="H" [Ц]="Ts"
        [Ч]="Ch" [Ш]="Sh" [Щ]="Sch" [Ъ]="" [Ы]="Y" [Ь]="" [Э]="E" [Ю]="Yu"
        [Я]="Ya"
    )
    
    local result=""
    local char
    
    for ((i=0; i<${#1}; i++)); do
        char="${1:$i:1}" 
        if [[ -n "${translit_map[$char]}" ]]; then
            result+="${translit_map[$char]}"
        else
            result+="$char"
        fi
    done
    
    echo "$result"
}



main() {
    echo "Перевод  имен подкаталогов в текущем каталоге из кириллицы в латиницу"
    echo "Текущий каталог: $(pwd)"
    echo " "
    
    local count=0
    local skipped=0
    local processed=0
    
    # Обрабатываем каждый каталог 
    for dir in */; do
        # Пропускаем если это не каталог
        [[ -d "$dir" ]] || continue
        
        #Переводим
        new_name=$(translate "$dir")
        ((processed++))

        # Если имя не изменилось, пропускаем
        if [[ "$dir" == "$new_name" ]]; then
            echo "Пропуск: '$dir' не содержит кириллицы"
            ((skipped++))
            continue
        fi
        
        # Переименовываем каталог
        if mv -v "$dir" "$new_name"; then
            echo "Переименован: '$dir' в  '$new_name'"
            ((count++))
	   
        else
            echo "Ошибка переименования: '$dir' в  '$new_name'"
        fi
    done
    
    echo " "
    echo "Итого:"
    echo "Переименовано: $count"
    echo "Пропущено: $skipped"
    echo "Всего обработано: $processed"
}



main
