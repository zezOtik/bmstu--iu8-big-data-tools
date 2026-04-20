-- 1) Выведите имя, должность и название отдела для всех активных сотрудников

select employee_name, position, department_name
from employees

left join departments
using(department_id)
where is_active = true

-- 2) Посчитайте количество проектов для каждого статуса

select status, count(project_id)
from projects

group by status


-- 3) Найдите всех сотрудников, у которых нет руководителя (manager_id IS NULL). Выведите их имя, должность и отдел.

select employee_name, position, department_name
from employees

left join departments 
using(department_id)

where manager_id is null


-- 4) Посчитайте общее количество часов, отработанных сотрудниками каждого отдела над всеми проектами.

select d.department_name, sum(hours_worked)
from departments d 

left join employees e
using(department_id)

left join employee_projects ep 
using(employee_id)

group by d.department_name


-- 5) Выведите руководителей, у которых более 1 подчиненного. Покажите имя руководителя и количество подчиненных.

select m.employee_name, count(e.employee_id) 
from employees e

inner join employees m on e.manager_id = m.employee_id 

group by m.employee_id, m.employee_name
having count(e.employee_id) > 1;