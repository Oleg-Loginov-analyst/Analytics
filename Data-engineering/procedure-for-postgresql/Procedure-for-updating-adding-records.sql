-- Создание процедуры
CREATE OR REPLACE FUNCTION update_test_data() RETURNS VOID AS $$
DECLARE
  max_date DATE;
BEGIN
  -- Получение максимальной даты в таблице
  SELECT MAX(updated_at) INTO max_date FROM test_data;
  
  -- Обновление записей с date_to = '31.12.9999' на актуальную дату
  UPDATE test_data SET date_to = max_date WHERE date_to = '9999-12-31';
  
  -- Вставка новых записей
  INSERT INTO test_data (id, rev, created_at, updated_at)
  SELECT id, rev, created_at, updated_at
  FROM (
    SELECT DISTINCT ON (id) id, rev, created_at, updated_at
    FROM test_data
    WHERE updated_at > max_date
    ORDER BY id, updated_at DESC
  ) AS new_records;
END;
$$ LANGUAGE plpgsql
;