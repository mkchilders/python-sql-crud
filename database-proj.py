import pymysql

## UTILITY

# executes the given statement
def execute(stmt,cnx):
  try:
    cur = cnx.cursor()
    cur.execute(stmt)

    for row in cur.fetchall():
      print(row)

    cur.close()
    cnx.commit()
    print("Success! Returning to main menu...\n")
    return
    
  except pymysql.Error as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))
    print("Returning to main menu...\n\n")
    return
  

## TUPLE CREATION FUNCTIONS

# creation menu
def createTuples(cnx):
  cmenu = "\nWhich table will you insert into?\n"
  cmenu += "1. Majors\n2. Minors\n3. Students\n"
  cmenu += "4. Co-Op Position\n5. Back to main menu\n"
  print(cmenu)
  create = int(input("Enter the table number: "))

  # input handling
  while create < 1 and create > 5:
    print("Invalid entry. Try again\n")
    print(cmenu)
    create = int(input("Enter the table number: "))

  if create == 1:
    print("Inserting into the Majors table.\n")
    createMajor(cnx)
  elif create == 2:
    print("Inserting into the Minors table.\n")
    createMinor(cnx)
  elif create == 3:
    print("Inserting into the Students table.\n")
    createStudent(cnx)
  elif create == 4:
    print("Inserting into the Co-op Positions table.\n")
    createPosition(cnx)
  elif create == 5:
    print("Returning to main menu...\n")
    end = True

  return


# create a major
def createMajor(cnx):
  print("Now creating a new major:\n")
  title = input("Enter the title of the major: ")
  creditsReq = input("Enter the number of credits needed (can be left blank): ")
  college = input("Enter the college (can be left blank): ")
    
  title = repr(title)
  creditsReq = repr(creditsReq)
  college = repr(college)

  stmt_create = "call createMajor({},{},{})".format(title,creditsReq,college)
  execute(stmt_create,cnx)
  return


# create a minor
def createMinor(cnx):
  print("Now creating a new minor:\n")
  title = input("Enter the title of the minor: ")
  creditsReq = input("Enter the number of credits needed (can be left blank): ")
  college = input("Enter the college (can be left blank): ")
    
  title = repr(title)
  creditsReq = repr(creditsReq)
  college = repr(college)

  stmt_create = "call createMinor({},{},{})".format(title,creditsReq,college)
  execute(stmt_create,cnx)
  return


# create a student
def createStudent(cnx):
  print("Now creating a new student (all fields except their id are optional):\n")
  id = input("Enter their id number: ")
  name = input("Enter their name: ")
  credits = input("Enter their number of course credits: ")
  gpa = input("Enter their GPA: ")
  college = input("Enter their college :")
  major = input("Enter their major: ")
  minor = input("Enter their minor: ")
  skill = input("Enter their special skill: ")  

  id = repr(id)
  name = repr(name)
  credits = repr(credits)
  gpa = repr(gpa)
  college = repr(college)
  major = repr(major)
  minor = repr(minor)
  skill = repr(skill)

  stmt_create = "call createStudent({},{},{},{},{},{},{},{})".format(id,name,credits,gpa,college,major,minor,skill)
  execute(stmt_create,cnx)
  return


# create a position
def createPosition(cnx):
  print("Now creating a new position:\n")
  coopNo = input("Enter a new co-op id: ")
  title = input("Enter the job title: ")
  desc = input("Enter the description: ")
  gpa = input("Enter the GPA requirement: ")
  major = input("Enter the associated major: ")
  wage = input("Enter the wage (as an integer): ")
  company = input("Enter the company's name: ")
  student = input("Enter the student's id: ")

  coopNo = repr(coopNo)
  title = repr(title)
  desc = repr(desc)
  gpa = repr(gpa)
  major = repr(major)
  wage = repr(wage)
  company = repr(company)
  student = repr(student)

  stmt_create = "call createPosition({},{},{},{},{},{},{},{})".format(coopNo,title,desc,gpa,major,wage,company,student)
  execute(stmt_create,cnx)
  return


## TUPLE READ FUNCTIONS

# read menu
def readTuples(cnx):
  rmenu = "What would you like to read from the database?\n"
  rmenu += "1. Read top 10 highest paying co-ops\n"
  rmenu += "2. Read top 10 majors by average co-op salary\n"
  rmenu += "3. Read majors with the lowest 10 average salaries\n"
  rmenu += "4. Get average co-op salary by major\n"
  rmenu += "5. Get average co-op salary by college\n"
  rmenu += "6. Get average co-op salary by company\n"
  rmenu += "7. Get all co-ops from a given company\n"
  rmenu += "8. Get all co-ops with a given associated major\n"
  rmenu += "9. Return to main menu\n"
  print(rmenu)
  r = int(input("Enter the number: "))

  while r < 1 and r > 9:
    print("Invalid entry. Try again\n")
    print(rmenu)
    r = int(input("Enter the number: "))

  if r == 1:
    highestPayCoops(cnx)
  elif r == 2:
    topMajors(cnx)
  elif r == 3:
    lowestMajors(cnx)
  elif r == 4:
    getMajorAvg(cnx)
  elif r == 5:
    getCollegeAvg(cnx)
  elif r == 6:
    avgWageCompany(cnx)
  elif r == 7:
    getCoopsFromCo(cnx)
  elif r == 8:
    getCoopsFromMajor(cnx)
  elif r == 9:
    print("Returning to main menu...\n")
    return

def highestPayCoops(cnx):
  print("These are the top 10 highest paying co-ops:\n")
  stmt_create = "call highestPayCoops()"
  execute(stmt_create,cnx)
  return

def topMajors(cnx):
  print("These are the top 10 highest paying majors:\n")
  stmt_create = "call topMajors()"
  execute(stmt_create,cnx)
  return

def lowestMajors(cnx):
  print("These are the 10 lowest paying majors:\n")
  stmt_create = "call lowestMajors()"
  execute(stmt_create,cnx)
  return

def getMajorAvg(cnx):
  print("Getting average salary by major...\n")
  title = input("Enter the major title: ")

  title = repr(title)
  
  stmt_create = "call getMajorAvg({})".format(title)
  execute(stmt_create,cnx)
  return

def getCollegeAvg(cnx):
  print("Getting average salary by college...\n")
  col = input("Enter the name of the college: ")

  col = repr(col)

  stmt_create = "call getCollegeAvg({})".format(col)
  execute(stmt_create,cnx)
  return

def avgWageCompany(cnx):
  print("Getting average wage for a company...\n")
  com = input("Enter the name of the company: ")

  com = repr(com)

  stmt_create = "call avgWageCompany({})".format(com)
  execute(stmt_create,cnx)
  return

def getCoopsFromCo(cnx):
  print("Getting all co-ops for a company...\n")
  com = input("Enter the name of the company: ")
              
  com = repr(com)

  stmt_create = "call getCoopsFromCo({})".format(com)
  execute(stmt_create,cnx)
  return

def getCoopsFromMajor(cnx):
  print("Getting all co-ops for a major...\n")
  maj = input("Enter the name of the major: ")

  maj = repr(maj)

  stmt_create = "call getCoopsFromMajor({})".format(maj)
  execute(stmt_create,cnx)
  return
  

## TUPLE UPDATE FUNCTIONS

# update menu
def updateTuples(cnx):
  umenu = "\nWhat would you like to update?\n"
  umenu += "1. A Student's Credits\n2. A Student's Major\n"
  umenu += "3. A College's Phone Number\n"
  umenu += "4. Give a Co-Op to a Student\n"
  umenu += "5. A Student's Minor\n6. Back to main menu.\n"
  print(umenu)
  upd = int(input("Enter the table number: "))

  # input handling
  while upd < 1 and upd > 6:
    print("Invalid entry. Try again\n")
    print(umenu)
    upd = int(input("Enter the table number: "))

  if upd == 1:
    print("Updating the Credits a Student has earned.\n")
    updateCredits(cnx)
  elif upd == 2:
    print("Changing a Student's Major.\n")
    updateMajor(cnx)
  elif upd == 3:
    print("Changing a college's phone number.\n")
    updatePhone(cnx)
  elif upd == 4:
    print("Giving a Co-Op to a Student.\n")
    updateStudent(cnx)
  elif upd == 5:
    print("Changing a student's minor.\n")
    updateMinor(cnx)
  elif upd == 6:
    print("Returning to main menu...\n")
    return


def updateCredits(cnx):
  print("Now updating credits...\n")
  id = input("Enter the id of the student you want to update: ")
  credits = input("Enter the number of credits you want the student to have: ")

  id = repr(id)
  credits = repr(credits)

  stmt_create = "call changeCredits({},{})".format(id,credits)
  execute(stmt_create,cnx)
  return

  
def updateMajor(cnx):
  print("Now changing a Student's major...\n")
  id = input("Enter the id of the student you want to update: ")
  major = input("Enter the title of the major you want to give this student: ")

  id = repr(id)
  major = repr(major)

  stmt_create = "call changeMajor({},{})".format(id,major)
  execute(stmt_create,cnx)
  return


def updateMinor(cnx):
  print("Now changing a Student's minor...\n")
  id = input("Enter the id of the student you want to update: ")
  minor = input("Enter the title of the minor you want to give to this student: ")

  id = repr(id)
  minor = repr(minor)

  stmt_create = "call changeMinor({},{})".format(id,minor)
  execute(stmt_create,cnx)
  return
  

def updatePhone(cnx):
  print("Now updating a college's phone number...\n")
  college = input("Enter the name of the college: ")
  phone = input("Enter the phone number of the college: ")

  college = repr(college)
  phone = repr(phone)

  stmt_create = "call changePhone({},{})".format(college,phone)
  execute(stmt_create,cnx)
  return


def updateStudent(cnx):
  print("Now updating a student's co-op...\n")
  sid = input("Enter the id of the student you want to update: ")
  coid = input("Enter the id of the existing coop you want to give to the student: ")

  sid = repr(sid)
  coid = repr(coid)

  stmt_create = "call changeStudent({},{})".format(sid,coid)
  execute(stmt_create,cnx)
  return
  
          
## TUPLE DELETION FUNCTIONS

# deletion menu
def deleteTuples(cnx):
  dmenu = "\nWhich table would you like to delete from?\n"
  dmenu += "1. Co-op Positions\n2. Majors\n3. Students\n4. Back to main menu.\n"
  print(dmenu)
  delete = int(input("Enter the table number: "))
  
  # input handling
  while delete < 1 and delete > 4:
    print("Invalid entry. Try again\n")
    print(dmenu)
    delete = int(input("Enter the table number: "))

  if delete == 1:
    print("Deleting from the Co-Op Positions table.\n")
    deleteCoop(cnx)
  elif delete == 2:
    print("Deleting from the Majors table.\n")
    deleteMajor(cnx)
  elif delete == 3:
    print("Deleting from the Students table.\n")
    deleteStudent(cnx)
  elif delete == 4:
    print("Returning to main menu...\n")
    return


def deleteCoop(cnx):
  print("Now deleting a Co-op Position...\n")
  id = input("Enter the id of the Co-op you want to delete: ")

  id = repr(id)
  stmt_create = "call removeCoop({})".format(id)
  execute(stmt_create,cnx)
  return


def deleteMajor(cnx):
  print("Now deleting a Major...\n")
  major = input("Enter the name of the Major you wish to delete: ")

  major = repr(major)
  stmt_create = "call removeMajor({})".format(major)
  execute(stmt_create,cnx)
  return


def deleteStudent(cnx):
  print("Now deleting a Student...\n")
  student = int(input("Enter the student id of the student you wish to delete: "))  

  student = repr(student)
  stmt_create = "call removeStudent({})".format(student)
  execute(stmt_create,cnx)
  return


## MAIN

def main():
  userInput = input("Enter your username: ")
  pwInput = input("Enter your password: ")

  # connect to database, if possible
  try:
    cnx = pymysql.connect(host='localhost', user='root', password='cOdEgEAss', 
                          db='salaryCalc', charset='utf8mb4', 
                          cursorclass=pymysql.cursors.DictCursor)
    print("Connected successfully!")
  except pymysql.err.OperationalError as e:
    print('ERROR: %d: %s' % (e.args[0], e.args[1]))

  end = False
  while not end:
    menu = "\n------------------------------------------------------\n"
    menu += "\nWelcome to SalaryCalc! Choose an operation to perform:\n"
    menu += "1. Create tuples\n"
    menu += "2. Read tuples\n"
    menu += "3. Update tuples\n"
    menu += "4. Delete tuples\n"
    menu += "5. Quit\n"
    print(menu)
    op = int(input("Enter the number of the operation you want to perform: "))

    # checking inputs
    while op > 5 or op < 1:
      print('\nInvalid operation number. Try again.')
      print(menu)
      op = int(input("Enter the number of the operation you want to perform: "))

    if op == 5:
      end = True #quit
    if op == 1:
      createTuples(cnx)
    if op == 2:
      readTuples(cnx)
    if op == 3:
      updateTuples(cnx)
    if op == 4:
      deleteTuples(cnx)

  cnx.commit()
  cnx.close()
           

if __name__ == '__main__':
   main()
   

