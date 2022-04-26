import pymysql

## TUPLE CREATION FUNCTIONS

# creation menu
def createTuples(cnx):
  cmenu = "Which table will you insert into?\n"
  cmenu += "1. Majors\n2. Minors\n3. Students\n"
  cmenu += "4. Co-Op Position\n5. Back to main menu\n"
  print(cmenu)
  create = int(input("Enter the table number: "))

  # input handling
  while create < 1 and create > 5:
    print("Invalid table number. Try again\n")
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
    return

  return

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


# create a major
def createMajor(cnx):
  print("Now creating a new major:\n")
  title = input("Enter the title of the major: ")
  creditsReq = input("Enter the number of credits needed (can be left blank): ")
  college = input("Enter the college (can be left blank): ")
    # cur = cnx.cursor()
    
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

  
def readTuples(cnx):
  return


def updateTuples(cnx):
  return


# deletion menu
def deleteTuples(cnx):
  dmenu = "Which table would you like to delete from?\n"
  dmenu += "1. Co-op Positions\n2. Majors\n3. Students\n4. Back to main menu.\n"
  print(dmenu)
  delete = int(input("Enter the table number: "))
  
  # input handling
  while delete < 1 and delete > 4:
    print("Invalid table number. Try again\n")
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
  student = input("Enter the student id of the student you wish to delete: ")

  student = repr(student)
  stmt_create = "call removeStudent({})".format(student)
  execute(stmt_create,cnx)
  return


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
    menu = "\nWelcome to SalaryCalc! Choose an operation to perform:\n"
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
   

