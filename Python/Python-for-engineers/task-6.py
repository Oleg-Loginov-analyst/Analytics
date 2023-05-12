# Доработка task-5

# Необходимо в дополнение ко всему посчитать частоты встреченных значений.
# Частотой называется количество всех вхождений (в т.ч. и повторных) элемента в коллекцию.
# Для этого воспользуйтесь словарями. То же касается и подвыборки: частоты должны рассчитываться по полученному срезу.

import re

# Инициализация пустого списка для хранения значений
rps_values = []

# Функция для расчета среднего и медианного значений, а также частот встречаемости значений
def calculate_metrics(values):
    # Расчет среднего значения
    average = sum(values) // len(values)

    # Расчет медианного значения
    sorted_values = sorted(values)
    quotient, remainder = divmod(len(sorted_values), 2)
    median = sorted_values[quotient] if remainder else sum(sorted_values[quotient - 1:quotient + 1]) // 2

    # Расчет частот встречаемости значений
    frequencies = {}
    for value in values:
        frequencies[value] = frequencies.get(value, 0) + 1

    return average, median, frequencies


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
        average, median, frequencies = calculate_metrics(subset)
    else:
        # Проверка на наличие пакетного ввода (числа разделены точкой с запятой)
        if ';' in data:
            numbers = data.split(';')
            rps_values.extend([int(num) for num in numbers if num.isdigit()])
        else:
            # Ввод одного числа
            rps_values.append(int(data))

        average, median, frequencies = calculate_metrics(rps_values)

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
    print("Характер нагрузки:", result)
    print("Частоты встречаемости значений:")
    for value, frequency in frequencies.items():
        print(f"{value}: {frequency}")
    print()
