DROP DATABASE IF EXISTS salaryCalc;
CREATE DATABASE salaryCalc;

USE salaryCalc;

/*

ENTITIES

*/

CREATE TABLE address (
	loc_id INT PRIMARY KEY AUTO_INCREMENT,
    street VARCHAR(64),
    unitNo VARCHAR(5) DEFAULT NULL,
    city VARCHAR(64),
    state CHAR(2) DEFAULT NULL,
    country VARCHAR(64),
    zipcode CHAR(5) DEFAULT NULL
);

CREATE TABLE college
(
  college_name VARCHAR(75) PRIMARY KEY,
  address INT DEFAULT NULL,
  phone VARCHAR(50) DEFAULT NULL,
  FOREIGN KEY (address) REFERENCES address(loc_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE major
(
	title VARCHAR(75) PRIMARY KEY, 
    credits_required INT DEFAULT 120,
    college VARCHAR(75) DEFAULT NULL,
    FOREIGN KEY (college) REFERENCES college(college_name)
		ON UPDATE CASCADE ON DELETE CASCADE
);
SELECT * FROM major;

DROP TABLE minor;
CREATE TABLE minor
(
	minor_title VARCHAR(75) PRIMARY KEY,
    credits_needed INT DEFAULT 30,
    college VARCHAR(75) DEFAULT NULL,
    FOREIGN KEY (college) REFERENCES college(college_name)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE company 
(
	company_name VARCHAR(75) PRIMARY KEY, 
    location INT DEFAULT NULL,
    num_of_employees INT DEFAULT NULL,
    FOREIGN KEY (location) REFERENCES address(loc_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE skill
(
	skill_title VARCHAR(75) PRIMARY KEY,
    skill_desc VARCHAR(200) DEFAULT NULL
);

DROP TABLE student;
CREATE TABLE student
(
	studentId INT PRIMARY KEY,
    student_name VARCHAR(100) DEFAULT NULL,
    credits_earned INT DEFAULT NULL,
    gpa FLOAT DEFAULT NULL,
    college VARCHAR(75) DEFAULT NULL,
    major VARCHAR(75) DEFAULT NULL,
    minor VARCHAR(75) DEFAULT NULL,
    skill VARCHAR(75) DEFAULT NULL,
    FOREIGN KEY (college) REFERENCES college(college_name)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (major) REFERENCES major(title)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY (minor) REFERENCES minor(minor_title)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY (skill) REFERENCES skill(skill_title)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE coop(
	coopNo INT PRIMARY KEY,
    coop_title VARCHAR(75) NOT NULL,
    coop_desc VARCHAR(200),
    gpa_required INT,
    associated_major VARCHAR(75),
    wages FLOAT,
    company VARCHAR(75) DEFAULT NULL,
    student INT,
    FOREIGN KEY (company) REFERENCES company(company_name)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (student) REFERENCES student(studentId)
		ON UPDATE CASCADE ON DELETE CASCADE
);

/*

PROCEDURES + FUNCTIONS

*/

# CREATE A STUDENT
DROP PROCEDURE createStudent;

DELIMITER //
CREATE PROCEDURE createStudent(sid INT, sname VARCHAR(100), credits INT, gpa INT, college VARCHAR(75), 
									major VARCHAR(75), minor VARCHAR(75), skill VARCHAR(75))
BEGIN

	-- insert major if it doesn't exist
    IF major NOT IN (SELECT title FROM major) THEN
		INSERT INTO major (title) VALUES (major);
	END IF;
    
    -- insert minor if it doesn't exist
    IF minor NOT IN (SELECT minor_title FROM minor) THEN
		INSERT INTO minor (minor_title) VALUES (minor);
	END IF;
    
    -- insert skill if it doesn't exist
    IF skill NOT IN (SELECT skill_title FROM skill) THEN
		INSERT INTO skill (skill_title) VALUES (skill);
	END IF;
    
    -- insert college if it doesn't exist
    IF college NOT IN (SELECT college_name FROM college) THEN
		INSERT INTO college (college_name) VALUES (college);
	END IF;

	-- insert student into student table
    IF sid NOT IN (SELECT studentId FROM student) THEN
		INSERT INTO student (studentId, student_name, credits_earned, gpa, college, major, minor, skill) 
			VALUES (sid, sname, credits, gpa, college, major, minor, skill);
	ELSEIF sid IN (SELECT studentId FROM student) THEN
		SET @t = 0; -- do nothing
	END IF;

END//
DELIMITER ;

CALL createStudent(367, "Carly Clarks", 56, 2.8, "DMSB", "Finance", "english", "logical thinking"); # fails because studentId 367 already exists
CALL createStudent(305, "Carly Clarks", 56, 2.8, "DMSB", "Finance", "english", "logical thinking"); # saves 


# CREATE A COOP POSITION
DROP PROCEDURE createPosition;

DELIMITER //
CREATE PROCEDURE createPosition(coopNo INT, title VARCHAR(75), coop_desc VARCHAR(200), gpa INT, a_major VARCHAR(75),
									wages INT, company_n VARCHAR(75), student INT)
BEGIN

	-- insert new company if not already existing in company table
	IF company_n NOT IN (SELECT company_name FROM company) THEN
		INSERT INTO company (company_name) VALUES (company_n);
	END IF;
    
    -- insert new student if not already existing in student table
    IF student NOT IN (SELECT studentId FROM student) THEN
		INSERT INTO student (studentID) VALUES (student);
	END IF;
        
    -- insert coop position into coop table
	INSERT INTO coop VALUES (coopNo, title, coop_desc, gpa, a_major, wages, company_n, student);
    
END//
DELIMITER ;

CALL createPosition(296, "Investment Banker", "Reconcile bank statements", 4.0, "business", 45, "MFS", 305);
CALL createPosition(296, "Investment Banker", "Reconcile bank statements", 4.0, "business", 45, "MFT", 305);
CALL createPosition(305, "Bank Teller", "Tell the bank", 3.4, "business", 20, "Amazon", 253);
CALL createPosition(2948, "Painter", "Paint walls", 4.2, "painting", 19, "Clarkson Classics", 394);
CALL createPosition(3952, "Physicist", "Predict the spacetime continuum", 4.5, "physics", 20, "NASA", 209);

SELECT * FROM coop;
SELECT * FROM company;
SELECT * FROM student;


# CREATE A MAJOR 
DROP PROCEDURE createMajor;

DELIMITER //
CREATE PROCEDURE createMajor(m_title VARCHAR(75), credits_req INT, college VARCHAR(75))
BEGIN
	-- create college if it doesn't exist
    IF college NOT IN (SELECT college_name FROM college) THEN
		INSERT INTO college (college_name) VALUES (college);
	END IF;
    
    -- create the major
    IF m_title NOT IN (SELECT title FROM major) THEN
		INSERT INTO major VALUES (m_title, credits_req, college);
	END IF;
END//
DELIMITER ;

CALL createMajor("Drumming", 200, "CAMD");

SELECT * FROM major;

# CREATE A MINOR
DELIMITER //
CREATE PROCEDURE createMinor(m_title VARCHAR(75), credits_req INT, college VARCHAR(75))
BEGIN
	-- create college if it doesnt exist
	IF college NOT IN (SELECT college_name FROM college) THEN
		INSERT INTO college (college_name) VALUES (college);
	END IF;
    
    -- create minor if it doesn't exist
    IF m_title NOT IN (SELECT minor_title FROM minor) THEN
		INSERT INTO minor VALUES (m_title, credits_req, college);
	END IF;
END//
DELIMITER ;
    
CALL createMinor("spanish", 30, "CSSH");
CALL createMinor("english", 2, "CSSH"); # fails because an english minor already exists

SELECT * FROM minor;
    
    
# DELETE A STUDENT
DROP PROCEDURE removeStudent;

DELIMITER //
CREATE PROCEDURE removeStudent(sid INT)
BEGIN

	-- remove student
    IF sid IN (SELECT studentId FROM student) THEN
		DELETE FROM student WHERE sid = studentId;
	END IF;
    
    -- remove the student id from the coop position table
    IF sid IN (SELECT student FROM coop) THEN
		DELETE FROM coop WHERE student = sid;
	END IF;
    
END//
DELIMITER ;

SELECT * FROM student;
SELECT * FROM coop;

CALL removeStudent(394);
CALL removeStudent(253);

# DELETE A COOP LISTING
DROP PROCEDURE removeCoop;

DELIMITER //
CREATE PROCEDURE removeCoop(coopNo_v INT)
BEGIN

	#Remove the coop tuple
    IF coopNo_v IN (SELECT coopNo FROM coop) THEN
		DELETE FROM coop WHERE coopNo = coopNo_v;
	END IF;

END//
DELIMITER ;

SELECT * FROM coop;

CALL removeCoop(3952);

# DELETE A MAJOR
DELIMITER //
CREATE PROCEDURE removeMajor(major_title VARCHAR(75))
BEGIN

	# removes a major
    IF major_title IN (SELECT title FROM major) THEN
		DELETE FROM major WHERE title = major_title;
	END IF;
END//
DELIMITER ;
    
SELECT * FROM major;
    
CALL removeMajor("communications");
    