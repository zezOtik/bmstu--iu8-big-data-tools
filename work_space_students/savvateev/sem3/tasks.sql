-- Задачи на семинар
-- 1) Выведите имя, должность и название отдела для всех активных сотрудников

    SELECT e.employee_name, e.position, d.department_name
    FROM employees AS e
        JOIN departments AS d
            ON e.department_id = d.department_id
    WHERE e.is_active;

-- 2) Посчитайте количество проектов для каждого статуса

    SELECT status, COUNT(*)
    FROM projects
    GROUP BY status;

-- 3) Найдите всех сотрудников, у которых нет руководителя (manager_id IS NULL). Выведите их имя, должность и отдел.

    SELECT e.employee_name, e.position, d.department_name
    FROM employees AS e
         JOIN departments AS d
             ON e.department_id = d.department_id
    WHERE e.manager_id IS NULL;

-- 4) Посчитайте общее количество часов, отработанных сотрудниками каждого отдела над всеми проектами.

    SELECT d.department_name, SUM(employee_projects.hours_worked)
    FROM projects
        JOIN employee_projects
            ON projects.project_id = employee_projects.project_id
        JOIN employees
            ON employee_projects.employee_id = employees.employee_id
        JOIN departments AS d
            ON employees.department_id = d.department_id
    GROUP BY d.department_name;

-- 5) Выведите руководителей, у которых более 1 подчиненного. Покажите имя руководителя и количество подчиненных.
    SELECT manager.employee_name, COUNT(*)
    FROM employees AS worker
    JOIN employees AS manager
        ON worker.manager_id = manager.employee_id
    GROUP BY manager.employee_name
    HAVING COUNT(*) > 1;

-- 6) Найдите сотрудников, которые работают более чем над 2 проектами. Выведите их имя и количество проектов.

    SELECT e.employee_name, COUNT(*)
    FROM employee_projects
    JOIN employees AS e
        ON employee_projects.employee_id = e.employee_id
    GROUP BY employee_name
    HAVING COUNT(*) > 2;

