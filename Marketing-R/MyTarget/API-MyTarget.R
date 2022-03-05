# Подключаем пакеты
library(rmytarget)
library(openxlsx)
library(dplyr)
library(vroom)
library(DBI)
library(RODBC)
library(odbc)
library(remotes)
library(bigrquery)
library(RJDBC)

# Электронная почта, к которой привязан токен
options(gargle_oauth_email = "name@gmail.com")

# Авторизация для получения токена
myTarAuth(login = "логин из аккаунта mytarget", token_path = "tokens") # л-Логин вводить до @mail.ru  

# Загрузка списка рекламных кампаний
campaing <- myTarGetCampaignList(login      = "1111111111@agency_client", # Логин из рекламного кабинета
                                 token_path = "путь-к-токену")

# Переводим колонки с датами в формат "Дата"
campaing$created    = as.Date(campaing$created)
campaing$date_start = as.Date(campaing$date_start)
campaing$date_end   = as.Date(campaing$date_end)

# Оставляем только активные кампании
campaing_active <- filter(campaing, status == "active")

# Загрузка списка объявлений
ads <- myTarGetAdList(login      = "1111111111@agency_client", # Логин из рекламного кабинета
                      token_path = "путь-к-токену")

# Оставляем только активные объявления
ads_active <- filter(ads, status == "active")

# Переименовываем колонку "id"
ads <- rename(ads, id_ads = id)

# Переводим колонки с датами в формат "Дата"
ads$updated = as.Date(ads$updated)
ads$created = as.Date(ads$created)

# Загрузка всех возможных метрик с группировкой по рекламным кампаниям
camp_all_statistic <- myTarGetStats(date_from   = Sys.Date() - 92,
                                    date_to     = Sys.Date() - 1,
                                    object_type = "campaigns",
                                    object_id   = campaing$id,
                                    metrics     = "all",
                                    stat_type   = "day",
                                    login       = "1111111111@agency_client", # Логин из рекламного кабинета
                                    token_path  = "путь-к-токену")

# Приводим данные к нужному формату
camp_all_statistic$date                    = as.Date(camp_all_statistic$date)
camp_all_statistic$spent                   = as.integer(camp_all_statistic$spent)
camp_all_statistic$cpm                     = as.integer(camp_all_statistic$cpm)
camp_all_statistic$cpc                     = as.integer(camp_all_statistic$cpc)
camp_all_statistic$cpa                     = as.integer(camp_all_statistic$cpa)
camp_all_statistic$viewed_10_seconds_cost  = as.integer(camp_all_statistic$viewed_10_seconds_cost)
camp_all_statistic$viewed_25_percent_cost  = as.integer(camp_all_statistic$viewed_25_percent_cost)
camp_all_statistic$viewed_50_percent_cost  = as.integer(camp_all_statistic$viewed_50_percent_cost)
camp_all_statistic$viewed_75_percent_cost  = as.integer(camp_all_statistic$viewed_75_percent_cost)
camp_all_statistic$viewed_100_percent_cost = as.integer(camp_all_statistic$viewed_100_percent_cost)

# Подключаемся в БД Google BigQuery

# Загружаем данные в BigQuery
# Список рекламных кампаний
bq_table(project = "project-name",                         # Название продукта
         dataset = "dataset-name",                         # Название датасета (набор данных)
         table   = "table-name") %>%                       # Название таблицы
  bq_table_upload(values = campaing,                       # Загружаемый датасет из вышенаписанного кода
                  create_disposition = "CREATE_IF_NEEDED", # Создание ноовый таблицы
                  write_disposition  = "WRITE_TRUNCATE")   # Перезаписать данные в таблице


# Список рекламных объявлений
bq_table(project = "project-name",
         dataset = "dataset-name",
         table   = "ads") %>%
  bq_table_upload(values = ads,
                  create_disposition = "CREATE_IF_NEEDED",
                  write_disposition  = "WRITE_TRUNCATE")

# Статистика по кампаниям
bq_table(project = "project-name",
         dataset = "dataset-name",
         table   = "table-name") %>%
  bq_table_upload(values = camp_all_statistic,
                  create_disposition = "CREATE_IF_NEEDED",
                  write_disposition  = "WRITE_TRUNCATE")
