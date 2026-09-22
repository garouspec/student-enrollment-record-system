# Student Enrollment, Grading and Record Management System

A desktop application built in Java (NetBeans, Swing) with a MySQL/MariaDB
backend, for managing student registration, enrollment, subjects and courses,
grading, attendance, academic records, report cards, and transcripts.

**Course:** Computer Programming 4

**Group Members:**
- Dumagcao, Lance Matthew R.
- Isidro, Carlo S.
- Trinidad, Anthony Ruiz O.

## Tech Stack
- Java (Swing, NetBeans IDE)
- MySQL / MariaDB (JDBC)
- Git / GitHub for version control

## Project Structure
```
student-enrollment-record-system/
├── src/
│   ├── model/     -> data classes (Student, Subject, Course, Enrollment, Grade, Attendance)
│   ├── dao/       -> database access classes (all SQL lives here)
│   ├── ui/        -> Swing forms (Login, MainWindow, Registration, Enrollment, Grading, Reports)
│   └── util/      -> shared helpers (DBConnection, validators)
├── database/
│   ├── schema.sql       -> full database schema
│   └── sample_data.sql  -> sample data for testing
├── docs/          -> ERD, diagrams, project documentation
├── build.xml
├── nbproject/
└── README.md
```

## Modules
- Student Registration
- Enrollment
- Subjects & Courses
- Grading
- Attendance
- Academic Records
- Report Cards
- Transcripts

## Setup Instructions

### 1. Clone the repository
```
git clone https://github.com/yourusername/student-enrollment-record-system.git
```

### 2. Set up the database
Import both SQL files into MySQL/MariaDB, in this order:
```
mysql -u root -p < database/schema.sql
mysql -u root -p < database/sample_data.sql
```
Or use phpMyAdmin's **Import** tab and select each file, `schema.sql` first.

### 3. Configure the database connection
Open `src/util/DBConnection.java` and update the connection details
(host, database name, username, password) to match your local MySQL setup.

### 4. Open in NetBeans
- **File → Open Project** and select the project folder.
- Make sure the MySQL Connector/J driver is added to the project's Libraries.
- Run the project (Login screen should appear).

## Grading Scale
1.00 (highest) to 3.00 (lowest passing grade), 5.00 (failed).

## Notes
- Don't commit real database passwords — keep local credentials out of Git.
- Only one person edits `schema.sql` at a time; others pull before making changes.
- See `database/schema.sql` for full table definitions and view logic used for
  report cards and transcripts.
