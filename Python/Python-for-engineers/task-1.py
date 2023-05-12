# Количество контейнеров
total_containers = 68796

# Параметры кластера
containers_per_pod = 4
pods_per_node = 117
nodes_per_datacenter = 21

# 1. Расчет количества дата-центров
datacenters = total_containers // (containers_per_pod * pods_per_node * nodes_per_datacenter)

# Параметры оперативной памяти
memory_per_node_gb = 16
memory_per_node_mb = memory_per_node_gb * 1024
memory_per_container_mb = 30

# 2. Расчет неиспользованной оперативной памяти в мегабайтах
unused_memory_mb = (nodes_per_datacenter * memory_per_node_mb) - (total_containers * memory_per_container_mb)

# 3. Разбиение неиспользованной оперативной памяти на гигабайты и мегабайты
unused_memory_gb = unused_memory_mb // 1024
unused_memory_mb = unused_memory_mb % 1024

# Вывод результатов
result = f"{datacenters},{unused_memory_gb},{unused_memory_mb}"
print(result)
