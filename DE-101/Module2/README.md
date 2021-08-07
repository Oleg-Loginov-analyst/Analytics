<h1>Задание для модуля 2</h1>
<h2><a id="user-content-устанавливаем-postgresql-на-локальный-компьютер-загружаем-данные-в-БД-пишем SQL-запросы-к-БЬ" class="anchor" aria-hidden="true" href="https://github.com/a2say/DE-101/blob/main/Module02/Readme.md#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%B0%D0%B2%D0%BB%D0%B8%D0%B2%D0%B0%D0%B5%D0%BC-postgresql-%D0%BD%D0%B0-%D0%BB%D0%BE%D0%BA%D0%B0%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9-%D0%BA%D0%BE%D0%BC%D0%BF%D1%8C%D1%8E%D1%82%D0%B5%D1%80-%D0%B7%D0%B0%D0%B3%D1%80%D1%83%D0%B7%D0%BA%D0%B0-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85-%D0%B2-%D0%B1%D0%B4-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D1%8B-%D0%BA-%D0%B1%D0%B4"><svg class="octicon octicon-link" viewbox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M7.775 3.275a.75.75 0 001.06 1.06l1.25-1.25a2 2 0 112.83 2.83l-2.5 2.5a2 2 0 01-2.83 0 .75.75 0 00-1.06 1.06 3.5 3.5 0 004.95 0l2.5-2.5a3.5 3.5 0 00-4.95-4.95l-1.25 1.25zm-4.69 9.64a2 2 0 010-2.83l2.5-2.5a2 2 0 012.83 0 .75.75 0 001.06-1.06 3.5 3.5 0 00-4.95 0l-2.5 2.5a3.5 3.5 0 004.95 4.95l1.25-1.25a.75.75 0 00-1.06-1.06l-1.25 1.25a2 2 0 01-2.83 0z"></path></svg></a>Устанавливаем PostgreSQL на локальный компьютер. Загружаем данные в БД. Пишем запросы к БД</h2>
<p><strong>Запросы для загрузки данных</strong></p>
<ul class="contains-task-list">
<li class="task-list-item"><input type="checkbox" id="" disabled="disabled" class="task-list-item-checkbox" checked="checked" /><span>&nbsp;</span><a href="https://github.com/Oleg-Loginov-analyst/Analytics/blob/main/DE-101/Module2/orders.sql">2.1. orders.sql</a></li>
<li class="task-list-item"><input type="checkbox" id="" disabled="disabled" class="task-list-item-checkbox" checked="checked" /><span>&nbsp;</span><a href="https://github.com/Oleg-Loginov-analyst/Analytics/blob/main/DE-101/Module2/people.sql">2.2. people.sql</a></li>
<li class="task-list-item"><input type="checkbox" id="" disabled="disabled" class="task-list-item-checkbox" checked="checked" /><span>&nbsp;</span><a href="https://github.com/Oleg-Loginov-analyst/Analytics/blob/main/DE-101/Module2/returns.sql">2.3. returns.sql</a></li>
</ul>
<p><strong>Делаем SQL запросы к БД</strong></p>
<ul class="contains-task-list">
<li class="task-list-item"><input type="checkbox" id="" disabled="disabled" class="task-list-item-checkbox" checked="checked" /><span>&nbsp;</span><a href="https://github.com/Oleg-Loginov-analyst/Analytics/blob/main/DE-101/Module2/query.sql">2.3. query.sql</a></li>
</ul>
<h2>Рисуем модель данных в SQLdbm для создания новой БД</h2>
<p><strong>Концептуальная модель</strong></p>
<p><a target="_blank" rel="noopener noreferrer" href="https://github.com/Oleg-Loginov-analyst/Analytics/blob/main/DE-101/Module2/Conceptual%20model.png"><img src="https://github.com/Oleg-Loginov-analyst/Analytics/blob/main/DE-101/Module2/Conceptual%20model.png" alt="Концептуальная модель" /></a></p>
<p><strong>Логическая модель</strong></p>
<p><a target="_blank" rel="noopener noreferrer" href="https://github.com/Oleg-Loginov-analyst/Analytics/blob/main/DE-101/Module2/Logical%20model.png"><img src="https://github.com/Oleg-Loginov-analyst/Analytics/blob/main/DE-101/Module2/Logical%20model.png" alt="Логическая модель" /></a></p>
<p><strong>Физическая модель</strong></p>
<p><a target="_blank" rel="noopener noreferrer" href="https://github.com/Oleg-Loginov-analyst/Analytics/blob/main/DE-101/Module2/Physical%20model.png"><img src="https://github.com/Oleg-Loginov-analyst/Analytics/blob/main/DE-101/Module2/Physical%20model.png" alt="Физическая модель" /></a></p>
<h2>Создаём БД в Google BigQuery и загружаем данные</h2>
<ul class="contains-task-list">
<li class="task-list-item"><input type="checkbox" id="" disabled="disabled" class="task-list-item-checkbox" checked="checked" /><span>&nbsp;</span>Создаем учетную запись в AWS.</li>
<li class="task-list-item"><input type="checkbox" id="" disabled="disabled" class="task-list-item-checkbox" checked="checked" /><span>&nbsp;</span>Используя сервис AWS RDS создаём БД PostgreSQL и настраиваем к ней доступ.</li>
<li class="task-list-item"><input type="checkbox" id="" disabled="disabled" class="task-list-item-checkbox" checked="checked" /><span>&nbsp;</span>Подключаемся к новой БД через SQL клиент (DBeaver) и загружаем данные из модуля 2.3 (Superstore dataset):
<ul class="contains-task-list">
<li class="task-list-item"><input type="checkbox" id="" disabled="disabled" class="task-list-item-checkbox" checked="checked" /><span>&nbsp;</span>В staging (схема БД stg) &mdash;<span>&nbsp;</span><a href="https://github.com/a2say/DE-101/blob/main/Module02/stg.orders.sql">stg.orders.sql</a></li>
<li class="task-list-item"><input type="checkbox" id="" disabled="disabled" class="task-list-item-checkbox" checked="checked" /><span>&nbsp;</span>В Business Layer (схема БД dw) &mdash;<span>&nbsp;</span><a href="https://github.com/a2say/DE-101/blob/main/Module02/from_stg_to_dw.sql">from_stg_to_dw.sql</a></li>
</ul>
</li>
</ul>
<h2><a id="user-content-google-data-studio-подключение-к-бд-в-aws-rds-и-создание-дашборда" class="anchor" aria-hidden="true" href="https://github.com/a2say/DE-101/tree/main/Module02#google-data-studio-%D0%BF%D0%BE%D0%B4%D0%BA%D0%BB%D1%8E%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-%D0%BA-%D0%B1%D0%B4-%D0%B2-aws-rds-%D0%B8-%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%B4%D0%B0%D1%88%D0%B1%D0%BE%D1%80%D0%B4%D0%B0"><svg class="octicon octicon-link" viewbox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M7.775 3.275a.75.75 0 001.06 1.06l1.25-1.25a2 2 0 112.83 2.83l-2.5 2.5a2 2 0 01-2.83 0 .75.75 0 00-1.06 1.06 3.5 3.5 0 004.95 0l2.5-2.5a3.5 3.5 0 00-4.95-4.95l-1.25 1.25zm-4.69 9.64a2 2 0 010-2.83l2.5-2.5a2 2 0 012.83 0 .75.75 0 001.06-1.06 3.5 3.5 0 00-4.95 0l-2.5 2.5a3.5 3.5 0 004.95 4.95l1.25-1.25a.75.75 0 00-1.06-1.06l-1.25 1.25a2 2 0 01-2.83 0z"></path></svg></a>Google Data Studio: подключение к БД в AWS RDS и создание дашборда</h2>
<p><a href="https://datastudio.google.com/reporting/ef9fef9b-5892-434d-8f2c-3214bc23d2be" rel="nofollow">Дашборд в Data Studio</a></p>
