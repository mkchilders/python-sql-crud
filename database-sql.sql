DROP DATABASE IF EXISTS salaryCalc;
CREATE DATABASE salaryCalc;

USE salaryCalc;

/*
ENTITIES
*/

DROP TABLE IF EXISTS address;
CREATE TABLE address (
	loc_id INT PRIMARY KEY AUTO_INCREMENT,
    street VARCHAR(64),
    unitNo VARCHAR(5) DEFAULT NULL,
    city VARCHAR(64),
    state CHAR(2) DEFAULT NULL,
    country VARCHAR(64),
    zipcode CHAR(5) DEFAULT NULL
);

DROP TABLE IF EXISTS college;
CREATE TABLE college
(
  college_name VARCHAR(75) PRIMARY KEY,
  address INT DEFAULT NULL,
  phone VARCHAR(15) DEFAULT NULL,
  FOREIGN KEY (address) REFERENCES address(loc_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS major;
CREATE TABLE major
(
	title VARCHAR(75) PRIMARY KEY, 
    credits_required INT DEFAULT 120,
    college VARCHAR(75) DEFAULT NULL,
    FOREIGN KEY (college) REFERENCES college(college_name)
		ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS minor;
CREATE TABLE minor
(
	minor_title VARCHAR(75) PRIMARY KEY,
    credits_needed INT DEFAULT 30,
    college VARCHAR(75) DEFAULT NULL,
    FOREIGN KEY (college) REFERENCES college(college_name)
		ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS company;
CREATE TABLE company 
(
	company_name VARCHAR(75) PRIMARY KEY, 
    location INT DEFAULT NULL,
    num_of_employees INT DEFAULT NULL,
    FOREIGN KEY (location) REFERENCES address(loc_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS skill;
CREATE TABLE skill
(
	skill_title VARCHAR(75) PRIMARY KEY,
    skill_desc VARCHAR(200) DEFAULT NULL
);

DROP TABLE IF EXISTS student;
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

DROP TABLE IF EXISTS coop;
CREATE TABLE coop (
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
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (associated_major) REFERENCES major(title)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

/*
PROCEDURES + FUNCTIONS
*/

# CREATE A STUDENT
DROP PROCEDURE IF EXISTS createStudent;

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


# CREATE A MAJOR 
DROP PROCEDURE IF EXISTS createMajor;

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


# CREATE A MINOR
DROP PROCEDURE IF EXISTS createMinor;

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


# CREATE A COOP POSITION
DROP PROCEDURE IF EXISTS createPosition;

DELIMITER //
CREATE PROCEDURE createPosition(coopNo INT, title VARCHAR(75), coop_desc VARCHAR(200), gpa INT, a_major VARCHAR(75),
									wages INT, company_n VARCHAR(75), student INT)
BEGIN

	-- insert new major if not already existing in major table
    IF a_major NOT IN (SELECT title FROM major) THEN
		call createMajor(a_major, NULL, NULL);
		-- INSERT INTO major (title) VALUES (a_major);
	END IF;

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
    

# DELETE A STUDENT
DROP PROCEDURE IF EXISTS removeStudent;

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


# DELETE A COOP LISTING
DROP PROCEDURE IF EXISTS removeCoop;

DELIMITER //
CREATE PROCEDURE removeCoop(coopNo_v INT)
BEGIN

	#Remove the coop tuple
    IF coopNo_v IN (SELECT coopNo FROM coop) THEN
		DELETE FROM coop WHERE coopNo = coopNo_v;
	END IF;

END//
DELIMITER ;


# DELETE A MAJOR
DROP PROCEDURE IF EXISTS removeMajor;

DELIMITER //
CREATE PROCEDURE removeMajor(major_title VARCHAR(75))
BEGIN

	# removes a major
    IF major_title IN (SELECT title FROM major) THEN
		DELETE FROM major WHERE title = major_title;
	END IF;
END//
DELIMITER ;


# UPDATE CREDITS
DROP PROCEDURE IF EXISTS changeCredits;

DELIMITER //
CREATE PROCEDURE changeCredits(IN id INT, credits INT)
BEGIN

	# adds credits given to credits_earned
    IF id IN (SELECT studentId FROM student) THEN 
		UPDATE student SET credits_earned = credits WHERE
		studentId = id;
	END IF;
END//
DELIMITER ;


# UPDATE MAJOR
DROP PROCEDURE IF EXISTS changeMajor;

DELIMITER //
CREATE PROCEDURE changeMajor(IN id INT, major_p VARCHAR(75))
BEGIN
	
    # changes student's major to new major
    IF id IN (SELECT studentId FROM student) AND major_p IN (SELECT title FROM major) THEN
		UPDATE student SET major = major_p WHERE
		studentId = id;
	# if student exists but major does not exist yet, create the major
	ELSEIF id IN (SELECT studentId FROM student) AND major_p NOT IN (SELECT title FROM major) THEN
		call createMajor(major_p,NULL,NULL);
        UPDATE student SET major = major_p WHERE studentId = id; 
	END IF;
END//
DELIMITER ;


-- major that is not defined yet
-- CALL changeMajor(305, "Biology");
-- major that is defined already
-- CALL changeMajor(367, "Drumming");

# UPDATE MINOR
DROP PROCEDURE IF EXISTS changeMinor;

DELIMITER //
CREATE PROCEDURE changeMinor(IN id INT, minor_p VARCHAR(75))
BEGIN
	
    # changes student's minor to different minor
    IF id IN (SELECT studentId FROM student) AND minor_p IN (SELECT minor_title FROM minor) THEN
		UPDATE student SET minor = minor_p WHERE
		studentId = id;
	# if student exists but minor does not exist yet, create the minor
	ELSEIF id IN (SELECT studentId FROM student) AND minor_p NOT IN (SELECT minor_title FROM minor) THEN
		call createMinor(minor_p,NULL,NULL);
        UPDATE student SET minor = minor_p WHERE studentId = id; 
	END IF;
END//
DELIMITER ;


# UPDATE COOP STUDENT
DROP PROCEDURE IF EXISTS changeStudent;

DELIMITER //
CREATE PROCEDURE changeStudent(IN id INT, coopNo_p INT)
BEGIN

	# updates student in a coop only if student and coop exist
    IF id IN (SELECT studentId FROM student) AND coopNo_p IN (SELECT coopNo FROM coop) THEN
		UPDATE coop SET student = id WHERE
		coopNo = coopNo_p;
	END IF;
END//
DELIMITER ;


# UPDATE COLLEGE PHONE NUMBER
DROP PROCEDURE IF EXISTS changePhone;
DELIMITER //
CREATE PROCEDURE changePhone(IN name VARCHAR(75), phone_p VARCHAR(15))
BEGIN

	# updates phone number for college
    IF name IN (SELECT college_name FROM college) THEN
		UPDATE college SET phone = phone_p WHERE
		name = college_name;
	END IF;
END//
DELIMITER ;


-- CALL changePhone("DMSB", 1234567890);

###################################################

## READ PROCEDURES

# Get the top 10 highest paying co-op positions
DROP PROCEDURE IF EXISTS highestPayCoops;

DELIMITER // 
CREATE PROCEDURE highestPayCoops()
BEGIN 
	SELECT * 
    FROM (
		SELECT coop_title,coop_desc,gpa_required,associated_major,wages,company 
		FROM coop
		ORDER BY wages DESC
	) `x`
    LIMIT 10;
END//
DELIMITER ;


# Get the top 10 majors with highest avg salaries
DROP PROCEDURE IF EXISTS topMajors;

DELIMITER //
CREATE PROCEDURE topMajors()
BEGIN
	SELECT * FROM
    (
		SELECT major.title, major.credits_required, major.college,avg(coop.wages) as avgWage FROM major
		INNER JOIN coop ON coop.associated_major = major.title
		GROUP BY major.title
		ORDER BY avg(coop.wages) DESC
    ) `x`
    LIMIT 10;
END //
DELIMITER ;

# Get the 10 majors with lowest avg salaries
DROP PROCEDURE IF EXISTS lowestMajors;

DELIMITER //
CREATE PROCEDURE lowestMajors()
BEGIN
	SELECT * FROM
    (
		SELECT major.title, major.credits_required, major.college,avg(coop.wages) as avgWage FROM major
		INNER JOIN coop ON coop.associated_major = major.title
		GROUP BY major.title
		ORDER BY avg(coop.wages) ASC
    ) `x`
    LIMIT 10;
END //
DELIMITER ;


# Get the average co-op salary for the given major
DROP PROCEDURE IF EXISTS getMajorAvg;

DELIMITER //
CREATE PROCEDURE getMajorAvg(IN m_title VARCHAR(75))
BEGIN 
	IF m_title IN (SELECT title FROM major) THEN
		SELECT avg(coop.wages) FROM coop 
        WHERE associated_major = m_title;
	END IF;
END//
DELIMITER ;


# Get the average co-op salary for the given college
DROP PROCEDURE IF EXISTS getCollegeAvg;

DELIMITER //
CREATE PROCEDURE getCollegeAvg(IN c_name VARCHAR(75))
BEGIN
	IF c_name IN (SELECT college_name FROM college) THEN
		SELECT avg(coop.wages) FROM coop 
		INNER JOIN major ON coop.associated_major = major.title 
		WHERE major.college = c_name;
    END IF;
END//
DELIMITER ;


# Get the average salary for a company's co-ops 
DROP PROCEDURE IF EXISTS avgWageCompany;

DELIMITER //
CREATE PROCEDURE avgWageCompany(IN c_name VARCHAR(75))
BEGIN
	IF c_name IN (SELECT company FROM coop) THEN
		SELECT avg(coop.wages) FROM coop
        WHERE c_name = company;
	END IF;
END//
DELIMITER ;


# Get all co-ops at a given company (wages sorted high->low)
DROP PROCEDURE IF EXISTS getCoopsFromCo;

DELIMITER //
CREATE PROCEDURE getCoopsFromCo(IN c_name VARCHAR(75))
BEGIN 
	IF c_name IN (SELECT company_name FROM company) THEN
		SELECT coop_title,coop_desc,gpa_required,associated_major,wages
        FROM coop
        WHERE company = c_name
        ORDER BY wages DESC;
	END IF;
END//
DELIMITER ;


# See all co-ops for a given major (wages sorted high->low)
DROP PROCEDURE IF EXISTS getCoopsFromMajor;

DELIMITER //
CREATE PROCEDURE getCoopsFromMajor(IN m_title VARCHAR(75))
BEGIN
	IF m_title IN (SELECT title FROM major) THEN
		SELECT coop_title,coop_desc,gpa_required,associated_major,wages
        FROM coop
        WHERE associated_major = m_title
        ORDER BY wages DESC;
	END IF;
END//
DELIMITER ;


############################################

-- INSERT INIT DATA:

-- major title, credits required, college
CALL createMajor("Drumming", 200, "CAMD");
CALL createMajor("Business", 220, "DMSB");
CALL createMajor("Painting", 200, "CAMD");
CALL createMajor("Physics", 220, "CoE");
CALL createMajor("Finance", 200, "DMSB");
CALL createMajor("History", 220, "CSSH");
CALL createMajor("Computer Science", 200, "CCIS");

-- minor title, credits required, college
CALL createMinor("Spanish", 16, "CSSH");
CALL createMinor("English", 24, "CSSH"); 
CALL createMinor("Data Science", 20, "CCIS");
CALL createMinor("Computer Science", 24, "CCIS");
CALL createMinor("Business", 16, "DMSB");

-- student id, name, credits earned, gpa, college, major, minor, skill
CALL createStudent(367, "Carly Clarks", 56, 2.8, "DMSB", "Finance", "English", "logical thinking");
CALL createStudent(305, "Carly Clarks", 56, 2.8, "DMSB", "Finance", "English", "logical thinking"); 
CALL createStudent(20, "John Smith", 72, 4.0, "CSSH", "Computer Science", "Data Science", "programming");
CALL createStudent(306, "Jane Smith", 124, 3.9, "CSSH", "Drumming", "Computer Science", "creativity");
CALL createStudent(15, "Johnny Knoxville", 100, 3.8, "CCIS", "Computer Science", NULL, "logical thinking");
CALL createStudent(16, "Janey Smithers", 100, 4.0, "CCIS", "Data Science", "Spanish", "creativity");
CALL createStudent(394, "Mary Powers", 124, 3.5, "CAMD", "Graphic Design", NULL, "logical thinking");
CALL createStudent(253, "Brianna Boyd", 120, 4.0, "CSSH", "Business", NULL, "creativity");
CALL createStudent(209, "Mary Jane", 72, 3.4, "CoE", "Physics", NULL, "logical thinking");

-- coop id, title, description, gpa required, major, hourly wage, company, student id
CALL createPosition(296, "Investment Banker", "Reconcile bank statements", 3.5, "Business", 30, "MFS", 305);
CALL createPosition(307, "Bank Teller", "Tell the bank", 3.0, "Business", 20, "Amazon", 253);
CALL createPosition(2948, "Painter", "Paint walls", 3.0, "Painting", 19, "Clarkson Classics", 394);
CALL createPosition(3952, "Physicist", "Predict the spacetime continuum", 4.5, "Physics", 20, "NASA", 209);
CALL createPosition(1, "Software Developer", "Develop software in Python", 2.5, "Computer Science", 45, "Amazon", 20);
CALL createPosition(2, "Software Developer", "Cloud services", 3.0, "Computer Science", 50, "Google", 20);
CALL createPosition(3, "Software Developer", "Develop software in Java", 2.0, "Computer Science", 35, "Desktop Metal", 15);
CALL createPosition(4, "Soccer coach", "Coach kids in soccer", 3.0, "Business", 15, "Soccer Coaches Co.", 25); -- student doesn't exist, create


