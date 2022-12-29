
## Планировщик
Планировщик необходимо запускать отдельно от веб-сервера. Для его старта нужно выполнить команду `airflow scheduler`

Планировщик отвечает за запуск пайплайнов (DAG Run) по расписанию, мониторинг и обнаружение новых DAGов (в случае, когда пишем новые пайплайны и загружаем в указанную директорию). Без запущенного планировщика невозможно выполнить DAG.

При созданию дата пайплайна (DAG), опционально, можно указать периодичность его запуска через параметр `schedule_interval` (значения могут быть согласно синтаксиса crontab или <a href="https://airflow.apache.org/docs/apache-airflow/stable/dag-run.html#cron-presets">готовые пресеты</a>). Например, если планируем запускать пайплайн ежедневно (значение `@daily`), то запуск за 26 января 2021 года будет произведён в полночь 27 января, т.е. сразу после наступления новой даты. То же самое касается и ежемесячных интервалов. Запуск за январь будет произведён 1-го февраля.

Ранее планировщик Airflow был узким местом всей системы из-за отсутствия отказоустойчивости и проблем с масштабированием. Но начиная со второй версии эта проблема была решена. Теперь для более надёжной работы всей системы можно запускать сразу несколько планировщиков. DAG не будет выполнен несколько раз, если у вас запущено несколько планировщиков, т.к. достигается за счёт блокировки на уровне базы данных. Более подробно об этом можно прочитать в статье <a href="https://www.astronomer.io/blog/airflow-2-scheduler/">The Airflow 2.0 Scheduler</a>.