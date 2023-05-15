-- Создание процедуры
create or replace function update_test_data() returns void as $$
declare
  max_date date;
begin
  -- Получение максимальной даты в таблице
  select
    max(updated_at) into max_date
  from
    test_data
  ;
  
  -- Обновление записей с date_to = '31.12.9999' на актуальную дату
  update test_data set date_to = max_date where date_to = '9999-12-31';
  
  -- Вставка новых записей
  insert into test_data (id, rev, created_at, updated_at)
  select
    id
    ,rev
    ,created_at
    ,updated_at
  from (
    select distinct on (id) id, rev, created_at, updated_at
    from
      test_data
    where
      updated_at > max_date
    order by
      id
      ,updated_at desc
  ) as new_records;
END;
$$ language plpgsql
;
