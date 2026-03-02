-- 1) Выведите имя, должность и название отдела для всех активных сотрудников
select
    e.employee_name,
    e.position,
    d.department_name
from employees e
inner join departments d on e.department_id = d.department_id
where e.is_active = true;

-- 2) Посчитайте количество проектов для каждого статуса
select 
	status,
	count(project_id) as project_count
from projects
group by status;

-- 3) Найдите всех сотрудников, у которых нет руководителя (manager_id IS NULL). 
-- Выведите их имя, должность и отдел.
select
	e.employee_name,
    e.position,
    d.department_name,
    coalesce(m.employee_name, 'Нет руководителя') as manager_name
from employees e 
left join employees m on e.manager_id = m.employee_id
left join departments d on e.department_id = d.department_id
where e.manager_id is null;

-- 4) Посчитайте общее количество часов, отработанных сотрудниками каждого отдела над всеми проектами.
select
	d.department_name,
	coalesce(sum(ep.hours_worked), 0) as total_hours
from departments d
left join employees e on d.department_id = e.department_id
left join employee_projects ep on e.employee_id = ep.employee_id
group by d.department_name;

-- 5) Выведите руководителей, у которых более 1 подчиненного. 
-- Покажите имя руководителя и количество подчиненных.
select
	m.employee_name as manager_name,
    count(s.employee_id) as number_of_subordinates
from employees s
inner join employees m on s.manager_id = m.employee_id
group by m.employee_id, m.employee_name
having count(s.employee_id) > 1;
-- 6) Найдите сотрудников, которые работают более чем над 2 проектами. 
-- Выведите их имя и количество проектов.
select
	e.employee_name,
    count(ep.project_id) as project_count
from employees e
inner join employee_projects ep on e.employee_id = ep.employee_id
group by e.employee_id, e.employee_name
having count(ep.project_id) > 2;
