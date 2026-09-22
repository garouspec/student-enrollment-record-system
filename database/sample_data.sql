USE student_records;

-- Users (password for all = 'admin123', hashed with SHA-256 for testing only.
-- In the Java app, switch to BCrypt before submitting.)
INSERT INTO users (username, password_hash, full_name, role) VALUES
('admin',     SHA2('admin123', 256), 'System Administrator', 'ADMIN'),
('registrar', SHA2('admin123', 256), 'Maria Registrar',      'REGISTRAR'),
('teacher1',  SHA2('admin123', 256), 'Juan Dela Cruz',       'TEACHER'),
('teacher2',  SHA2('admin123', 256), 'Ana Reyes',            'TEACHER');

-- Courses
INSERT INTO courses (course_code, course_name, years_to_finish) VALUES
('BSIT', 'Bachelor of Science in Information Technology', 4),
('BSCS', 'Bachelor of Science in Computer Science', 4);

-- Subjects
INSERT INTO subjects (subject_code, subject_name, units) VALUES
('IT101',   'Introduction to Computing',        3.0),
('IT102',   'Computer Programming 1',           3.0),
('IT103',   'Database Systems',                 3.0),
('MATH101', 'College Algebra',                  3.0),
('STAT101', 'Elementary Statistics',            3.0),
('NET101',  'Networking Fundamentals',          3.0);

-- Curriculum for BSIT (course_id = 1)
INSERT INTO curriculum (course_id, subject_id, year_level, semester) VALUES
(1, 1, 1, 1), (1, 2, 1, 1), (1, 4, 1, 1),
(1, 3, 2, 1), (1, 5, 2, 1), (1, 6, 2, 1);

-- Terms
INSERT INTO school_terms (school_year, semester, is_current) VALUES
('2025-2026', 2, FALSE),
('2026-2027', 1, TRUE);

-- Students
INSERT INTO students
(student_no, first_name, middle_name, last_name, birthdate, gender, address,
 contact_no, email, guardian_name, guardian_contact, course_id, year_level)
VALUES
('2025-0001', 'Chae',  'M', 'Santos',  '2005-03-14', 'FEMALE', 'Taguig City',
 '09171234567', 'chae@example.com',  'Rosa Santos', '09179876543', 1, 2),
('2025-0002', 'Miguel', NULL, 'Garcia', '2005-07-02', 'MALE', 'Pasig City',
 '09181234567', 'miguel@example.com', 'Pedro Garcia', '09189876543', 1, 2);

-- Class offerings for 2026-2027 sem 1 (term_id = 2)
INSERT INTO class_offerings (term_id, subject_id, teacher_id, section, schedule, room) VALUES
(2, 3, 3, 'A', 'MWF 8:00-9:00',  'Lab 1'),
(2, 5, 4, 'A', 'TTh 10:00-11:30', 'Rm 204'),
(2, 6, 3, 'A', 'MWF 1:00-2:00',  'Lab 2');

-- Enroll both students in term 2 (2026-2027 sem 1)
INSERT INTO enrollments (student_id, term_id, year_level) VALUES
(1, 2, 2), (2, 2, 2);

INSERT INTO enrollment_subjects (enrollment_id, offering_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2), (2, 3);

-- Grades (1.0 best, 3.0 lowest passing, 5.0 failed)
INSERT INTO grades (es_id, midterm_grade, final_grade, remarks) VALUES
(1, 1.50, 1.25, 'PASSED'),
(2, 1.75, 1.75, 'PASSED'),
(3, 2.00, 2.00, 'PASSED'),
(4, 2.50, 3.00, 'PASSED'),
(5, 5.00, 5.00, 'FAILED'),
(6, 2.25, NULL, 'INCOMPLETE');

-- Attendance sample
INSERT INTO attendance (es_id, attendance_date, status) VALUES
(1, '2026-09-14', 'PRESENT'),
(1, '2026-09-16', 'LATE'),
(1, '2026-09-18', 'PRESENT'),
(4, '2026-09-14', 'PRESENT'),
(4, '2026-09-16', 'ABSENT'),
(4, '2026-09-18', 'EXCUSED');
