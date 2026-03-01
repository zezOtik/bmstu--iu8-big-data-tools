CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    created_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INTEGER REFERENCES departments(department_id),
    position VARCHAR(100),
    hire_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget NUMERIC(12, 2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(50) DEFAULT 'active'
);

CREATE TABLE employee_projects (
    employee_id INTEGER REFERENCES employees(employee_id),
    project_id INTEGER REFERENCES projects(project_id),
    role VARCHAR(50),
    hours_worked INTEGER,
    PRIMARY KEY (employee_id, project_id)
);


INSERT INTO departments (department_id, department_name, location, created_date) VALUES
(1, 'IT', 'Москва', '2022-01-01'),
(2, 'HR', 'Санкт-Петербург', '2022-01-01'),
(3, 'Finance', 'Москва', '2022-01-01'),
(4, 'Marketing', 'Екатеринбург', '2022-02-01'),
(5, 'Sales', 'Москва', '2022-02-01');

INSERT INTO employees (employee_id, employee_name, department_id, position, hire_date, is_active) VALUES
(1, 'Иванов Иван', 1, 'Разработчик', '2022-03-01', TRUE),
(2, 'Петров Петр', 1, 'Разработчик', '2022-04-01', TRUE),
(3, 'Сидоров Сидор', 1, 'Team Lead', '2021-01-01', TRUE),
(4, 'Кузнецова Анна', 2, 'HR Менеджер', '2022-05-01', TRUE),
(5, 'Смирнов Сергей', 2, 'HR Директор', '2020-06-01', TRUE),
(6, 'Попов Павел', 3, 'Бухгалтер', '2022-06-01', TRUE),
(7, 'Васильева Ольга', 3, 'Финансовый директор', '2019-01-01', TRUE),
(8, 'Михайлов Михаил', 4, 'Маркетолог', '2022-07-01', TRUE),
(9, 'Федоров Федор', 4, 'Маркетолог', '2022-08-01', TRUE),
(10, 'Алексеев Алексей', 5, 'Менеджер по продажам', '2022-09-01', TRUE),
(11, 'Григорьев Григорий', 5, 'Менеджер по продажам', '2022-10-01', TRUE),
(12, 'Николаев Николай', 1, 'Разработчик', '2023-01-01', FALSE),
(13, 'Семенова Светлана', 4, 'Маркетолог', '2023-02-01', TRUE),
(14, 'Борисов Борис', 5, 'Старший менеджер', '2021-03-01', TRUE),
(15, 'Владимиров Владимир', 3, 'Аналитик', '2022-11-01', TRUE);

INSERT INTO projects (project_id, project_name, budget, start_date, end_date, status) VALUES
(1, 'Веб-сайт компании', 500000.00, '2023-01-01', '2023-06-01', 'completed'),
(2, 'Мобильное приложение', 800000.00, '2023-03-01', '2023-12-01', 'active'),
(3, 'CRM система', 1200000.00, '2023-02-01', '2024-02-01', 'active'),
(4, 'Маркетинговая кампания', 300000.00, '2023-04-01', '2023-08-01', 'active'),
(5, 'Обучение сотрудников', 150000.00, '2023-05-01', '2023-07-01', 'completed'),
(6, 'Аналитика продаж', 400000.00, '2023-06-01', '2023-12-01', 'active'),
(7, 'Редизайн логотипа', 100000.00, '2023-01-01', '2023-03-01', 'completed'),
(8, 'Интеграция API', 600000.00, '2023-07-01', '2024-01-01', 'active');

INSERT INTO employee_projects (employee_id, project_id, role, hours_worked) VALUES
(1, 1, 'Разработчик', 160),
(1, 2, 'Разработчик', 120),
(2, 1, 'Разработчик', 140),
(2, 3, 'Разработчик', 180),
(3, 1, 'Team Lead', 100),
(3, 2, 'Team Lead', 150),
(3, 3, 'Team Lead', 200),
(4, 5, 'Организатор', 80),
(5, 5, 'Руководитель', 60),
(6, 6, 'Аналитик', 120),
(7, 6, 'Руководитель', 100),
(7, 3, 'Консультант', 50),
(8, 4, 'Маркетолог', 140),
(8, 7, 'Дизайнер', 80),
(9, 4, 'Маркетолог', 160),
(9, 7, 'Маркетолог', 60),
(10, 6, 'Аналитик', 100),
(11, 6, 'Аналитик', 90),
(12, 1, 'Разработчик', 80),
(13, 4, 'Маркетолог', 120),
(14, 6, 'Руководитель', 110),
(15, 3, 'Аналитик', 150),
(15, 6, 'Аналитик', 130),
(1, 8, 'Разработчик', 100),
(2, 8, 'Разработчик', 110),
(3, 8, 'Team Lead', 90);


-- для теста self-join
ALTER TABLE employees
ADD COLUMN manager_id INTEGER REFERENCES employees(employee_id);

UPDATE employees SET manager_id = NULL WHERE employee_id IN (3, 5, 7);
UPDATE employees SET manager_id = 3  WHERE employee_id IN (1, 2, 12);
UPDATE employees SET manager_id = 5  WHERE employee_id = 4;
UPDATE employees SET manager_id = 7  WHERE employee_id IN (6, 15);
UPDATE employees SET manager_id = 14 WHERE employee_id IN (10, 11);
UPDATE employees SET manager_id = NULL WHERE employee_id IN (8, 9, 13);
UPDATE employees SET manager_id = 14 WHERE employee_id = 8;
UPDATE employees SET manager_id = 8  WHERE employee_id IN (9, 13);


-- Примеры:
-- Вывести ФИ сотрудника и его название департамента
select
    emp.employee_name
    , dep.department_name
from employees emp
inner join departments dep
using(department_id);

-- все сотрудники + их проекты (даже если проектов нет)

-- пример через using
select
    emp.employee_name
    , pr.project_name
from employees emp

left join employee_projects emp_p
using(employee_id)

left join projects pr
using(project_id);

-- через ON
select
    emp.employee_name
    , pr.project_name
from employees emp

left join employee_projects emp_p
on emp_p.employee_id = emp.employee_id

left join projects pr
on pr.project_id = emp_p.project_id;


-- Количество сотрудников в каждом отделе
-- 1ый способ
select
    d.department_name
    , count(emp.employee_id)
from departments d

left join employees emp
using(department_id)

group by d.department_name;

-- 2ой способ
select
	d.department_name
	, count(emp.employee_id)
from employees emp

left join departments d
using(department_id)

group by d.department_name;

-- Вывести отделы в которых больше 3ех(строго) сотрудников
select
    d.department_name
    , count(emp.employee_id)
from departments d

left join employees emp
using(department_id)

group by d.department_name
having count(emp.employee_id) > 3;

-- Вывести сотрудника и его руководителя.

select
    emp_m.employee_name
    , coalesce(emp_p.employee_name, 'Начальник сам себе') as boss
from employees emp_m

left join employees emp_p
on emp_m.manager_id = emp_p.employee_id;


-- Задачи на семинар
-- 1) Выведите имя, должность и название отдела для всех активных сотрудников
-- 2) Посчитайте количество проектов для каждого статуса
-- 3) Найдите всех сотрудников, у которых нет руководителя (manager_id IS NULL). Выведите их имя, должность и отдел.
-- 4) Посчитайте общее количество часов, отработанных сотрудниками каждого отдела над всеми проектами.
-- 5) Выведите руководителей, у которых более 1 подчиненного. Покажите имя руководителя и количество подчиненных.
-- 6) Найдите сотрудников, которые работают более чем над 2 проектами. Выведите их имя и количество проектов.

