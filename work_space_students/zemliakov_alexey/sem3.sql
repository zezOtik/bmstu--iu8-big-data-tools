-- 1)
SELECT e.employee_name, e.position, d.department_name
FROM employees AS e
LEFT JOIN departments AS d
    ON e.department_id = d.department_id
WHERE e.is_active = TRUE;


-- 2)
SELECT count(project_id), status
FROM projects
GROUP BY (status);


-- 3)
SELECT e.employee_name, e.position,d.department_name
FROM employees as e
LEFT JOIN departments as d
on e.department_id = d.department_id
WHERE e.manager_id IS NULL;


-- 4)
SELECT  d.department_name, SUM(ep.hours_worked)
FROM employee_projects as ep
Left Join employees as e
on ep.employee_id = e.employee_id
left join departments as d
on e.department_id = d.department_id
GROUP BY (d.department_name);


-- 5)
SELECT e.employee_name, count(e2.employee_name)
FROM employees AS e
Left Join employees AS e2
on e.employee_id = e2.manager_id
GROUP BY e.employee_name
HAVING count(e2.employee_name)>1;


-- 6)
SELECT e.employee_name, count(ep.project_id)
FROM employees AS e
LEFT JOIN employee_projects AS ep
ON e.employee_id = ep.employee_id
GROUP BY e.employee_name
HAVING count(ep.project_id) > 2;

