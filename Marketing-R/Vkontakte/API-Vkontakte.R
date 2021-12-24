# Сохраняем полученный токен в директорию
readRDS(file = "путь-к-токену/myToken.rds")
myToken <- readRDS ("путь-к-токену/myToken.rds")

# Подключаем пакеты
library(rvkstat)
library(openxlsx)
library(dplyr)
library(vroom)
library(googlesheets4)
library(googledrive)
library(DBI)
library(RODBC)
library(odbc)
library(remotes)
library(bigrquery)
library(DBI)
library(RJDBC)

# Электронная почта, к которой привязан токен
options(gargle_oauth_email = "name@gmail.com")

# Запрос списка доступных рекламных кабинетов
my_vk_acc <- vkGetAdAccounts(access_token = myToken$access_token)

# Получаем список рекламных кампаний
vk_camp <- vkGetAdCampaigns(account_id   = 1111111111, # указываем id рекламного аккаунта 
                            access_token = myToken$access_token)

# Переименовываем колонки id и name
vk_camp <- rename(vk_camp, id_camp = id)
vk_camp <- rename(vk_camp, name_campaign = name)

# Фильтруем по активным рекламным кампаниям
vk_camp_act <- filter(vk_camp, status == "кампания запущена")


# Получаем список объявлений
vk_ads <- vkGetAds(account_id   = 1111111111, # указываем id рекламного аккаунта
                   access_token = myToken$access_token)

# Фильтруем по активным объявлениям
vk_ads_act <- filter(vk_ads, status == "объявление запущено")


# Получаем список объявлений с описанием их внешнего вида
vk_ads_vid <- vkGetAdsLayout(account_id   = 1111111111, # указываем id рекламного аккаунта
                             access_token = myToken$access_token)

# Переименовываем колонки campaign_id и id
vk_ads_vid <- rename(vk_ads_vid, id_camp_vid = campaign_id)
vk_ads_vid <- rename(vk_ads_vid, id_ads_vid  = id)

# Приводим колонку id_ads_vid к числовому формату
vk_ads_vid$id_ads_vid = as.integer(vk_ads_vid$id_ads_vid)


# Получить статистику показателей эффективности по рекламным кампаниям
vk_camp_stat <- vkGetAdStatistics(account_id   = 1111111111, # указываем id рекламного аккаунта
                                  ids_type     = "campaign",
                                  ids          = vk_camp_act$id_camp,
                                  period       = "day",
                                  date_from    = "2021-01-01",
                                  access_token = myToken$access_token)

# Приводим колонку day к формату "Дата"
vk_camp_stat$day  = as.Date(vk_camp_stat$day)

# Переименовываем колонку id
vk_camp_stat <- rename(vk_camp_stat, id_camp_stat = id)

# Убираем пропущенные значения и оставляем только уникальные
na.omit(vk_camp_stat) %>% 
    unique()

# Получить статистику показателей эффективности по рекламным объявлениям
vk_ads_stat <- vkGetAdStatistics(account_id   = 1111111111, # указываем id рекламного аккаунта
                                  ids_type     = "ad",
                                  ids          = vk_ads_act$id,
                                  period       = "day",
                                  date_from    = "2021-01-01",
                                  access_token = myToken$access_token)

# Получаем данные по охвату в разрезе рекламных кампаний
vk_post_reach_camp <- vkGetAdPostsReach(account_id   = 1111111111, # указываем id рекламного аккаунта
                                        ids_type     = "campaign",
                                        ids          = vk_camp_act$id_camp,
                                        access_token = myToken$access_token)

# Переименовываем колонку id
vk_post_reach_camp <- rename(vk_post_reach_camp, id_post_reach = id)

# Получить подробную статистику по охвату рекламных записей из объявлений и кампаний для продвижения записей сообщества
vk_post_reach_ads <- vkGetAdPostsReach(account_id   = 1111111111, # указываем id рекламного аккаунта
                                       ids_type     = "ad",
                                       ids          = vk_ads_act$id,
                                       access_token = myToken$access_token)

# Заменяем NA в колонке "name" на Not identified
vk_camp_stat_city_month$name[is.na(vk_camp_stat_city_month$name)] <- 'Not identified'

# Получаем статистику по охвату аудитории по рекламным кампаним в разрезе городов
vk_camp_stat_city_overall <- vkGetAdCityStats(account_id   = 1111111111, # указываем id рекламного аккаунта
                                              ids_type     = "campaign",
                                              id           = vk_camp$id_camp ,
                                              period       = 'overall',
                                              date_from    = "2021-01-01",
                                              access_token = myToken$access_token)

# Приводим колонки "day_from" и "day_to" к формату "Дата"
vk_camp_stat_city_overall$day_from = as.Date(vk_camp_stat_city_overall$day_from)
vk_camp_stat_city_overall$day_to   = as.Date(vk_camp_stat_city_overall$day_to)

# Заменяем NA в колонке "name" на Not identified
vk_camp_stat_city_overall$name[is.na(vk_camp_stat_city_overall$name)] <- 'Not identified'

# Переименовываем колонку id
vk_camp_stat_city_overall <- rename(vk_camp_stat_city_overall, id_camp_stat_city = id)

# Подключаемся в БД Google BigQuery

# Загружаем данные в BigQuery
# Список рекламных кампаний
bq_table(project = "project-name",                         # название проекта
         dataset = "dataset-name",                         # название датасета (набор данных)
         table   = "table-name") %>%                       # название таблицы
  bq_table_upload(values             = vk_camp,            # загружаемый датасет из вышенаписанного кода
                  create_disposition = "CREATE_IF_NEEDED", # Создание ноовый таблицы
                  write_disposition  = "WRITE_TRUNCATE")   # Перезаписать данные в таблице


# Статистика по рекламным кампаниям
bq_table(project = "project-name",
         dataset = "dataset-name",
         table   = "table-name") %>%
  bq_table_upload(values             = vk_camp_stat,
                  create_disposition = "CREATE_IF_NEEDED",
                  write_disposition  = "WRITE_TRUNCATE")

# Статистика по охвату рекламных кампаний
bq_table(project = "project-name",
         dataset = "dataset-name",
         table   = "table-name") %>%
  bq_table_upload(values             = vk_post_reach_camp,
                  create_disposition = "CREATE_IF_NEEDED",
                  write_disposition  = "WRITE_TRUNCATE")
