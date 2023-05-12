# Доработка <a href="https://github.com/Oleg-Loginov-analyst/Analytics/blob/main/Python/Python-for-engineers/task-4.py">task-4</a>
# Первая задача - заменить кортеж на список.
# Далее, при помощи циклов нужно обеспечить ввод дополнительных данных.

# Данные можно вводить двумя способами:
# - По одному числу из потока ввода
# - Пакетным способом из потока ввода. В данном случае числа разделены точкой с запятой (100;132;123;211)

# По введенным данным должны рассчитываться те же показатели, что и в прошлой задаче.
# Но нужно автоматизировать аналитический вывод. Если среднее значение отличается от медианы более, чем на 25%, то такая разница считается существенной.

# Исходя из этого программа сама должна генерировать вывод о характере нагрузки:
# - Нагрузка стабильна
# - Происходят скачки
# - Происходят снижения

# А еще нужно отслеживать не только всю картину, но и её отдельные части. Поэтому возможна ситуация, когда на вход в программу поступит следующая структура:
# [число, число]
# Например: [17, 52]

# Это значит, что необходимо произвести срез по указанным индексам (левая и правая граница, соответственно) и рассчитать показатели по полученной подвыборке.
# В случае, если введена пустая строка или данная конструкция - ввод останавливается и производится расчет значений.

import re

# Инициализация пустого списка для хранения значений
rps_values = []

# Функция для расчета среднего и медианного значений
def calculate_metrics(values):
    # Расчет среднего значения
    average = sum(values) // len(values)

    # Расчет медианного значения
    sorted_values = sorted(values)
    quotient, remainder = divmod(len(sorted_values), 2)
    median = sorted_values[quotient] if remainder else sum(sorted_values[quotient - 1:quotient + 1]) // 2

    return average, median

# Ввод данных
while True:
    data = input("Введите данные (одно число или пакет чисел через точку с запятой): ")

    # Проверка на пустой ввод
    if not data:
        break

    # Проверка на наличие конструкции [число, число]
    if re.match(r'\[\d+,\s*\d+\]', data):
        # Извлечение чисел из конструкции [число, число]
        numbers = re.findall(r'\d+', data)
        left_index = int(numbers[0])
        right_index = int(numbers[1])
        subset = rps_values[left_index:right_index+1]
        average, median = calculate_metrics(subset)
    else:
        # Проверка на наличие пакетного ввода (числа разделены точкой с запятой)
        if ';' in data:
            numbers = data.split(';')
            rps_values.extend([int(num) for num in numbers if num.isdigit()])
        else:
            # Ввод одного числа
            rps_values.append(int(data))

        average, median = calculate_metrics(rps_values)

    # Определение характера нагрузки
    difference = abs(average - median)
    threshold = 0.25 * median

    if difference <= threshold:
        result = "Нагрузка стабильна"
    elif average > median:
        result = "Происходят скачки"
    else:
        result = "Происходят снижения"

    # Вывод результатов
    print("Среднее значение:", average)
    print("Медианное значение:", median)
    print(result)
    print()
