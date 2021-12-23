/* Задача 1
Получить статистику по дням.
Посчитать число всех событий по дням,
число показов,
число кликов,
число уникальных объявлений,
число уникальных кампаний. */

SELECT
	toDate(time) AS day,
    countIf(event = 'view') AS views,
    countIf(event = 'click') AS clicks,
    uniq(ad_id) AS uniq_ad_id,
    uniq(campaign_union_id) AS uniq_campaign_union_id
FROM
	ads_data
GROUP BY
    day;

/* Задача 2
Разобраться, почему случился такой скачок 2019-04-05?
Ответ: Таргетинг аудитории сузился, чтобы показывать рекламу более релевантной и целевой аудитории

Каких событий стало больше?
Ответ: выросли показы и клики на Android и iOS

У всех объявлений или только у некоторых?
Ответ: у объявлений с ad_id 112583 */

SELECT
    toDate(time) AS day,
    countIf(event = 'view') AS views,
    countIf(event = 'click') AS clicks,
    platform,
    ad_id AS ad_id,
    target_audience_count,
    campaign_union_id AS campaign_union_id
FROM
    ads_data
WHERE
    day = '2019-04-05'
GROUP BY
    day,
    platform,
    target_audience_count,
    ad_id,
    campaign_union_id
ORDER BY
    views DESC;

/* Задача 3
Найти топ 10 объявлений по CTR за все время.
CTR — это отношение всех кликов объявлений к просмотрам.
Например, если у объявления было 100 показов и 2 клика, CTR = 0.02.
Различается ли средний и медианный CTR объявлений в наших данных?
Ответ: Да, различаются */

SELECT
       ad_id,
       count(ad_id) AS count_ad_id,
       countIf(event = 'view') AS views,
       countIf(event = 'click') AS clicks,
       countIf(event = 'click') / countIf(event = 'view') AS ctr,
       avg(event = 'click') / avg(event = 'view') AS ctr_avg,
       median(event = 'click') / median(event = 'view') AS ctr_med
FROM
       ads_data
GROUP BY
       ad_id
ORDER BY
       clicks DESC
LIMIT
       10;

/* Задача 4
Похоже, в наших логах есть баг, объявления приходят с кликами, но без показов!

Сколько таких объявлений, есть ли какие-то закономерности?
Ответ: 20 объявлений

Эта проблема наблюдается на всех платформах?
Ответ: Да, проблема есть на всех платформах: Android, iOS и web */

SELECT
    ad_id,
    platform,
    countIf(event = 'view') AS views,
    countIf(event = 'click') AS clicks
FROM
    ads_data
GROUP BY
    ad_id,
    platform
HAVING
    views = 0
ORDER BY
    clicks DESC;

/* Задача 5
Для финансового отчета нужно рассчитать наш заработок по дням.
В какой день мы заработали больше всего? В какой меньше?
Ответ: Суммарно больше всего заработали 2019-04-05, а меньше всего 2019-04-01.
По CPM закупке больше всего заработали 2019-04-05, а меньше всего 2019-04-01.
По CPC закупке больше всего заработали 2019-04-02, а меньше всего 2019-04-01. */

SELECT
    toDate(time) AS day,
    sum(ad_cost) AS total_cost,
    ad_cost_type
FROM
    ads_data
GROUP BY
    day,
    ad_cost_type
ORDER BY
    total_cost DESC ;

/* Задача 6
Какая платформа самая популярная для размещения рекламных объявлений?
Ответ: На Android приходится больше всего показов и кликов */

SELECT
    platform,
    countIf(event = 'view') AS views,
    countIf(event = 'click') AS clicks
FROM
    ads_data
GROUP BY
    platform
ORDER BY
    views DESC,
    clicks DESC;