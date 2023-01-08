CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE titles ( 
	emp_no INT NOT NULL, 
	title VARCHAR NOT NULL, 
	from_date DATE NOT NULL, 
	to_date DATE NOT NULL, 
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
)

CREATE TABLE dept_emp ( 
	emp_no INT NOT NULL, 
	dept_no VARCHAR NOT NULL, 
	from_date DATE NOT NULL, 
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no), 
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
)


SELECT * FROM departments
SELECT * FROM employees
SELECT * FROM dept_manager
SELECT * FROM salaries
SELECT * FROM titles
SELECT * FROM dept_emp

--DELIVERABLE 1: 

--Retrieve emp_no, first_name, last_name from employees table 
SELECT emp_no, first_name, last_name 
FROM employees 

--Retrive title, from_date, to_date from titles table 
SELECT title, from_date, to_date 
FROM titles  


--export retirement titles table
SELECT e.emp_no, e.first_name, e.last_name, ts.title, ts.from_date, ts.to_date
INTO ret_titles_table
FROM employees as e 
INNER JOIN titles AS ts ON 
e.emp_no = ts.emp_no
--Filter data on birth_date to retrieve employee birth 1952-1955
--order by employee number
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no

--display data to confirm 
SELECT * FROM ret_titles_table


--retrieve emp_no, first_name, last_name, title from ret_titles_table
--use DISTINCT ON to retrieve first occurrence of emp_no
--filter to_date where date equals to '9999-01-01'
--order by emp_no ASC & to_date DESC 
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, 
first_name,
last_name,
title

INTO Unique_Title
FROM ret_titles_table AS RT 
WHERE RT.to_date = '9999-01-01'
ORDER BY emp_no, RT.to_date DESC;

--display data to confirm 
SELECT * FROM Unique_Title

--retrieve titles from unique_titles table 
--group by title; sort count in desc order 
--count in select statement: SELECT COUNT()
SELECT COUNT(title), title
INTO retiring_titles
FROM Unique_Title
GROUP BY title
ORDER BY COUNT(title) DESC

--display data to confirm 
SELECT * FROM retiring_titles


---retrieve emp_no, first_name, last_name, birth_date from employees table
SELECT emp_no, first_name, last_name, birth_date 
FROM employees 

--retrieve from_date, to_date from dept_emp table 
SELECT from_date, to_date 
FROM dept_emp 

--retrieve title from Titles table 
SELECT title 
FROM titles 



--Create New table
SELECT e.emp_no, e.first_name, e.last_name, e.birth_date, 
de.from_date, de.to_date, ts.title
INTO mentorship_eligibilty
FROM employees AS e 
--join employees and dept_emp tables 
INNER JOIN dept_emp AS de ON 
e.emp_no=de.emp_no 
--join employees and titles tables 
INNER JOIN titles AS ts ON 
e.emp_no=ts.emp_no
ORDER BY emp_no

SELECT * FROM mentorship_eligibilty

--Use DISTINCT ON to retrieve first occurrence of emp_no 
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, birth_date, 
from_date, to_date, title 
INTO mentorshipEligibility
FROM mentorship_eligibilty
--filter to_date where date equals to '9999-01-01'
WHERE (to_date = '9999-01-01') 
AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no

--display data to confirm 
SELECT * FROM mentorshipEligibility