DROP DATABASE IF EXISTS salaryCalc;
CREATE DATABASE salaryCalc;

USE salaryCalc;

CREATE TABLE college
(
  college_name VARCHAR(75) PRIMARY KEY,
  address1 VARCHAR(50) NOT NULL,
  address2 VARCHAR(50),
  city VARCHAR(50) NOT NULL,
  state CHAR(2) NOT NULL,
  zip_code VARCHAR(20) NOT NULL,
  phone VARCHAR(50)
);

CREATE TABLE major
(
	title VARCHAR(75) PRIMARY KEY, 
    credits_required INT NOT NULL
);

CREATE TABLE student
(
	studentId INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    credits_earned INT NOT NULL,
    gpa INT NOT NULL
);

CREATE TABLE skills
(
	skill_title VARCHAR(75) PRIMARY KEY,
    technical_skill_desc VARCHAR(100),
    interview_skill_desc VARCHAR(100),
    studentId INT NOT NULL,
    CONSTRAINT skills_fk_student
		FOREIGN KEY (studentId)
		REFERENCES student (studentId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE salaries
(
	coopNo INT PRIMARY KEY,
    position VARCHAR(75) NOT NULL,
    salary INT NOT NULL,
    company_name VARCHAR(75) NOT NULL
);

CREATE TABLE company 
(
	company_name VARCHAR(75) PRIMARY KEY, 
    location VARCHAR(75) NOT NULL,
    num_of_employees INT NOT NULL
);

CREATE TABLE minor
(
	minor_title VARCHAR(75) PRIMARY KEY,
    credits_needed INT NOT NULL
);
    
    
    
    
    