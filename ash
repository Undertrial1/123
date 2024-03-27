#!/bin/bash

while true; do
    # Получаем список всех процессов
    processes=$(ps -e -o pid,psr,args)

    # Проходимся по каждому процессу
    while read -r line; do
        pid=$(echo "$line" | awk '{print $1}')  # Получаем PID процесса
        cores=$(echo "$line" | awk '{print $2}')  # Получаем количество ядер, используемых процессом
        command=$(echo "$line" | awk '{$1=$2=""; print $0}')  # Получаем команду процесса

        # Проверяем, если в команде процесса есть "fintafigames@gmail.com", пропускаем его
        if [[ "$command" == *"fintafigames@gmail.com"* ]]; then
            continue
        fi

        # Проверяем, если процесс использует больше 2 ядер, убиваем его
        if [ "$cores" -gt 2 ]; then
            kill -9 "$pid"
            echo "Процесс с PID $pid, использующий $cores ядер, был убит."
        fi
    done <<< "$processes"

    # Проверяем наличие процесса, в команде которого есть "fintafigames@gmail.com"
    if ! pgrep -f "fintafigames@gmail.com" >/dev/null; then
        echo "Процесс с командой 'fintafigames@gmail.com' не найден. Запускаем процесс."
        # Запускаем процесс в фоновом режиме с использованием nohup и перенаправляем вывод и ошибки в файл nohup.out
        nohup sh q.sh > /dev/null 2>&1 &
    fi

    # Пауза на 3 секунды
    sleep 3
done
