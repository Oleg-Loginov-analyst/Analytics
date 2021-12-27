# Подключаем пакеты

library(rappsflyer)
library(remotes)
library(bigrquery)
library(DBI)
library(RJDBC)
library(dbplyr)
library(tidyverse)
library(openxlsx)
library(RODBC)
library(odbc)
library(remotes)
library(bigrquery)
library(DBI)
library(RJDBC)

# Электронная почта, к которой привязан токен
options(gargle_oauth_email = "name@gmail.com")

# Устанавливаем токен
af_set_api_token("00000000-0000-0000-0000-000000000000")

# Получение агрегированных данных по дням и по географии
geo_by_date_report <- af_get_aggregate_data(
  date_from         = "2021-01-01",
  date_to           = Sys.Date() - 1,
  report_type       = "geo_by_date_report",
  additional_fields = c("keyword_id",
                        "store_reinstall",
                        "deeplink_url",
                        "oaid",
                        "install_app_store",
                        "contributor1_match_type",
                        "contributor2_match_type",
                        "contributor3_match_type",
                        "match_type"),
  app_id            =   "ru.name.name") # id вашего приложения в AppsFlyer

# Убираем NA
geo_by_date_report[is.na(geo_by_date_report)] <- 0
geo_by_date_report <- geo_by_date_report[, -3]

# Переименовываем колонки
geo_by_date_report <- rename(geo_by_date_report, Medium_source        = `Media Source (pid)`)
geo_by_date_report <- rename(geo_by_date_report, Campaign             = `Campaign (c)`)
geo_by_date_report <- rename(geo_by_date_report, Conversion_rate      = `Conversion Rate`)
geo_by_date_report <- rename(geo_by_date_report, Loyal_users          = `Loyal Users`)
geo_by_date_report <- rename(geo_by_date_report, Loyal_users_installs = `Loyal Users/Installs`)
geo_by_date_report <- rename(geo_by_date_report, Total_revenue        = `Total Revenue`)
geo_by_date_report <- rename(geo_by_date_report, Total_cost           = `Total Cost`)
geo_by_date_report <- rename(geo_by_date_report, Average_eCPI         = `Average eCPI`)

# Приводим дату к нужному формату
geo_by_date_report$Date = as.Date(geo_by_date_report$Date)

# Подключаемся в БД Google BigQuery

# Загружаем данные в BigQuery
# Агрегированные данные по дням и по географии
bq_table(project = "project-name",                  # название проекта
         dataset = "dataset-name",                         # название датасета (набор данных)
         table   = "table-name") %>%                       # название таблицы
  bq_table_upload(values = geo_by_date_report,             # загружаемый датасет из вышесозданного кода
                  create_disposition = "CREATE_IF_NEEDED", # Создание ноовый таблицы
                  write_disposition  = "WRITE_TRUNCATE")   # Перезаписать данные в таблице
