# Декомпозиция программы на функции.
# В результате выполнения получится готовая программа, написанная в процедурной парадигме

import re

# Рассчитываем среднее значение
def calculate_average(values):
    return sum(values) // len(values)

# Рассчитываем медиану
def calculate_median(values):
    sorted_values = sorted(values)
    quotient, remainder = divmod(len(sorted_values), 2)
    median = sorted_values[quotient] if remainder else sum(sorted_values[quotient - 1:quotient + 1]) // 2
    return median

# Рассчитываем частоту встречаемости значений
def calculate_frequencies(values):
    frequencies = {}
    for value in values:
        frequencies[value] = frequencies.get(value, 0) + 1
    return frequencies

# Определяем характер нагрузки на основе среднего и медианного значений
def analyze_load(average, median):
    difference = abs(average - median)
    threshold = 0.25 * median

    if difference <= threshold:
        return "Нагрузка стабильна"
    elif average > median:
        return "Происходят скачки"
    else:
        return "Происходят снижения"

# Обрабатываем входные данные и рассчитываем показатели на основе выбранной логики
def process_input_data(data, rps_values):
    if re.match(r'\[\d+,\s*\d+\]', data):
        numbers = re.findall(r'\d+', data)
        left_index = int(numbers[0])
        right_index = int(numbers[1])
        subset = rps_values[left_index:right_index + 1]
        average = calculate_average(subset)
        median = calculate_median(subset)
        frequencies = calculate_frequencies(subset)
    else:
        if ';' in data:
            numbers = data.split(';')
            rps_values.extend([int(num) for num in numbers if num.isdigit()])
        else:
            rps_values.append(int(data))
        average = calculate_average(rps_values)
        median = calculate_median(rps_values)
        frequencies = calculate_frequencies(rps_values)

    return average, median, frequencies

def main():
    rps_values = []

    while True:
        data = input("Введите данные (одно число или пакет чисел через точку с запятой): ")

        if not data:
            break

        average, median, frequencies = process_input_data(data, rps_values)
        load_analysis = analyze_load(average, median)

        print("Среднее значение:", average)
        print("Медианное значение:", median)
        print("Характер нагрузки:", load_analysis)
        print("Частоты встречаемости значений:")
        for value, frequency in frequencies.items():
            print(f"{value}: {frequency}")
        print()

if __name__ == "__main__":
    main()