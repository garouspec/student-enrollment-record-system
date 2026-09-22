-- =====================================================================
-- Student Enrollment, Grading and Record Management System
-- MySQL / MariaDB schema
-- Grading scale: 1.00 (highest) ... 3.00 (lowest passing), 5.00 (failed)
-- Exported from phpMyAdmin and cleaned for use on any machine.
-- =====================================================================

DROP DATABASE IF EXISTS student_records;
CREATE DATABASE student_records
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE student_records;

--
-- Database: `student_records`
--

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `attendance_id` int(11) NOT NULL,
  `es_id` int(11) NOT NULL,
  `attendance_date` date NOT NULL,
  `status` enum('PRESENT','ABSENT','LATE','EXCUSED') NOT NULL,
  `remarks` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `class_offerings`
--

CREATE TABLE `class_offerings` (
  `offering_id` int(11) NOT NULL,
  `term_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `teacher_id` int(11) DEFAULT NULL,
  `section` varchar(20) DEFAULT NULL,
  `schedule` varchar(100) DEFAULT NULL,
  `room` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `course_name` varchar(150) NOT NULL,
  `years_to_finish` tinyint(4) NOT NULL DEFAULT 4
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `curriculum`
--

CREATE TABLE `curriculum` (
  `curriculum_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `year_level` tinyint(4) NOT NULL,
  `semester` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `enrollment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `term_id` int(11) NOT NULL,
  `year_level` tinyint(4) NOT NULL,
  `status` enum('ENROLLED','DROPPED','COMPLETED') NOT NULL DEFAULT 'ENROLLED',
  `date_enrolled` date NOT NULL DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `enrollment_subjects`
--

CREATE TABLE `enrollment_subjects` (
  `es_id` int(11) NOT NULL,
  `enrollment_id` int(11) NOT NULL,
  `offering_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

CREATE TABLE `grades` (
  `grade_id` int(11) NOT NULL,
  `es_id` int(11) NOT NULL,
  `midterm_grade` decimal(3,2) DEFAULT NULL,
  `final_grade` decimal(3,2) DEFAULT NULL,
  `remarks` enum('PASSED','FAILED','INCOMPLETE','DROPPED') DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `school_terms`
--

CREATE TABLE `school_terms` (
  `term_id` int(11) NOT NULL,
  `school_year` varchar(9) NOT NULL,
  `semester` tinyint(4) NOT NULL,
  `is_current` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `student_no` varchar(20) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) NOT NULL,
  `birthdate` date DEFAULT NULL,
  `gender` enum('MALE','FEMALE','OTHER') DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `contact_no` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `guardian_name` varchar(100) DEFAULT NULL,
  `guardian_contact` varchar(20) DEFAULT NULL,
  `course_id` int(11) NOT NULL,
  `year_level` tinyint(4) NOT NULL DEFAULT 1,
  `status` enum('ACTIVE','INACTIVE','GRADUATED','DROPPED') NOT NULL DEFAULT 'ACTIVE',
  `date_registered` date NOT NULL DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `subject_id` int(11) NOT NULL,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(150) NOT NULL,
  `units` decimal(3,1) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `role` enum('ADMIN','REGISTRAR','TEACHER') NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_academic_records`
-- (See below for the actual view)
--
CREATE TABLE `v_academic_records` (
`student_id` int(11)
,`student_no` varchar(20)
,`student_name` varchar(105)
,`course_code` varchar(20)
,`term_id` int(11)
,`school_year` varchar(9)
,`semester` tinyint(4)
,`enrollment_id` int(11)
,`year_level` tinyint(4)
,`subject_code` varchar(20)
,`subject_name` varchar(150)
,`units` decimal(3,1)
,`midterm_grade` decimal(3,2)
,`final_grade` decimal(3,2)
,`remarks` enum('PASSED','FAILED','INCOMPLETE','DROPPED')
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_attendance_summary`
-- (See below for the actual view)
--
CREATE TABLE `v_attendance_summary` (
`es_id` int(11)
,`total_days` bigint(21)
,`present_days` decimal(23,0)
,`absent_days` decimal(23,0)
,`late_days` decimal(23,0)
,`excused_days` decimal(23,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_cumulative_gwa`
-- (See below for the actual view)
--
CREATE TABLE `v_cumulative_gwa` (
`student_id` int(11)
,`total_units` decimal(25,1)
,`cumulative_gwa` decimal(29,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_term_gwa`
-- (See below for the actual view)
--
CREATE TABLE `v_term_gwa` (
`student_id` int(11)
,`term_id` int(11)
,`school_year` varchar(9)
,`semester` tinyint(4)
,`units_taken` decimal(25,1)
,`gwa` decimal(29,2)
);

-- --------------------------------------------------------

--
-- Structure for view `v_academic_records`
--
DROP TABLE IF EXISTS `v_academic_records`;

CREATE VIEW `v_academic_records`  AS SELECT `st`.`student_id` AS `student_id`, `st`.`student_no` AS `student_no`, concat(`st`.`last_name`,', ',`st`.`first_name`,if(`st`.`middle_name` is null or `st`.`middle_name` = '','',concat(' ',left(`st`.`middle_name`,1),'.'))) AS `student_name`, `c`.`course_code` AS `course_code`, `t`.`term_id` AS `term_id`, `t`.`school_year` AS `school_year`, `t`.`semester` AS `semester`, `e`.`enrollment_id` AS `enrollment_id`, `e`.`year_level` AS `year_level`, `sj`.`subject_code` AS `subject_code`, `sj`.`subject_name` AS `subject_name`, `sj`.`units` AS `units`, `g`.`midterm_grade` AS `midterm_grade`, `g`.`final_grade` AS `final_grade`, `g`.`remarks` AS `remarks` FROM (((((((`enrollment_subjects` `es` join `enrollments` `e` on(`e`.`enrollment_id` = `es`.`enrollment_id`)) join `students` `st` on(`st`.`student_id` = `e`.`student_id`)) join `courses` `c` on(`c`.`course_id` = `st`.`course_id`)) join `class_offerings` `o` on(`o`.`offering_id` = `es`.`offering_id`)) join `subjects` `sj` on(`sj`.`subject_id` = `o`.`subject_id`)) join `school_terms` `t` on(`t`.`term_id` = `e`.`term_id`)) left join `grades` `g` on(`g`.`es_id` = `es`.`es_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_attendance_summary`
--
DROP TABLE IF EXISTS `v_attendance_summary`;

CREATE VIEW `v_attendance_summary`  AS SELECT `attendance`.`es_id` AS `es_id`, count(0) AS `total_days`, sum(`attendance`.`status` = 'PRESENT') AS `present_days`, sum(`attendance`.`status` = 'ABSENT') AS `absent_days`, sum(`attendance`.`status` = 'LATE') AS `late_days`, sum(`attendance`.`status` = 'EXCUSED') AS `excused_days` FROM `attendance` GROUP BY `attendance`.`es_id` ;

-- --------------------------------------------------------

--
-- Structure for view `v_cumulative_gwa`
--
DROP TABLE IF EXISTS `v_cumulative_gwa`;

CREATE VIEW `v_cumulative_gwa`  AS SELECT `v_academic_records`.`student_id` AS `student_id`, sum(`v_academic_records`.`units`) AS `total_units`, round(sum(`v_academic_records`.`final_grade` * `v_academic_records`.`units`) / sum(`v_academic_records`.`units`),2) AS `cumulative_gwa` FROM `v_academic_records` WHERE `v_academic_records`.`final_grade` is not null AND `v_academic_records`.`remarks` in ('PASSED','FAILED') GROUP BY `v_academic_records`.`student_id` ;

-- --------------------------------------------------------

--
-- Structure for view `v_term_gwa`
--
DROP TABLE IF EXISTS `v_term_gwa`;

CREATE VIEW `v_term_gwa`  AS SELECT `v_academic_records`.`student_id` AS `student_id`, `v_academic_records`.`term_id` AS `term_id`, `v_academic_records`.`school_year` AS `school_year`, `v_academic_records`.`semester` AS `semester`, sum(`v_academic_records`.`units`) AS `units_taken`, round(sum(`v_academic_records`.`final_grade` * `v_academic_records`.`units`) / sum(`v_academic_records`.`units`),2) AS `gwa` FROM `v_academic_records` WHERE `v_academic_records`.`final_grade` is not null AND `v_academic_records`.`remarks` in ('PASSED','FAILED') GROUP BY `v_academic_records`.`student_id`, `v_academic_records`.`term_id`, `v_academic_records`.`school_year`, `v_academic_records`.`semester` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`attendance_id`),
  ADD UNIQUE KEY `es_id` (`es_id`,`attendance_date`);

--
-- Indexes for table `class_offerings`
--
ALTER TABLE `class_offerings`
  ADD PRIMARY KEY (`offering_id`),
  ADD UNIQUE KEY `term_id` (`term_id`,`subject_id`,`section`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `teacher_id` (`teacher_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`),
  ADD UNIQUE KEY `course_code` (`course_code`);

--
-- Indexes for table `curriculum`
--
ALTER TABLE `curriculum`
  ADD PRIMARY KEY (`curriculum_id`),
  ADD UNIQUE KEY `course_id` (`course_id`,`subject_id`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`enrollment_id`),
  ADD UNIQUE KEY `student_id` (`student_id`,`term_id`),
  ADD KEY `term_id` (`term_id`);

--
-- Indexes for table `enrollment_subjects`
--
ALTER TABLE `enrollment_subjects`
  ADD PRIMARY KEY (`es_id`),
  ADD UNIQUE KEY `enrollment_id` (`enrollment_id`,`offering_id`),
  ADD KEY `offering_id` (`offering_id`);

--
-- Indexes for table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`grade_id`),
  ADD UNIQUE KEY `es_id` (`es_id`),
  ADD KEY `updated_by` (`updated_by`);

--
-- Indexes for table `school_terms`
--
ALTER TABLE `school_terms`
  ADD PRIMARY KEY (`term_id`),
  ADD UNIQUE KEY `school_year` (`school_year`,`semester`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`),
  ADD UNIQUE KEY `student_no` (`student_no`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`subject_id`),
  ADD UNIQUE KEY `subject_code` (`subject_code`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `class_offerings`
--
ALTER TABLE `class_offerings`
  MODIFY `offering_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `curriculum`
--
ALTER TABLE `curriculum`
  MODIFY `curriculum_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `enrollment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `enrollment_subjects`
--
ALTER TABLE `enrollment_subjects`
  MODIFY `es_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `grade_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `school_terms`
--
ALTER TABLE `school_terms`
  MODIFY `term_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `subject_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`es_id`) REFERENCES `enrollment_subjects` (`es_id`) ON DELETE CASCADE;

--
-- Constraints for table `class_offerings`
--
ALTER TABLE `class_offerings`
  ADD CONSTRAINT `class_offerings_ibfk_1` FOREIGN KEY (`term_id`) REFERENCES `school_terms` (`term_id`),
  ADD CONSTRAINT `class_offerings_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`),
  ADD CONSTRAINT `class_offerings_ibfk_3` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `curriculum`
--
ALTER TABLE `curriculum`
  ADD CONSTRAINT `curriculum_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `curriculum_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`) ON DELETE CASCADE;

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `school_terms` (`term_id`);

--
-- Constraints for table `enrollment_subjects`
--
ALTER TABLE `enrollment_subjects`
  ADD CONSTRAINT `enrollment_subjects_ibfk_1` FOREIGN KEY (`enrollment_id`) REFERENCES `enrollments` (`enrollment_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `enrollment_subjects_ibfk_2` FOREIGN KEY (`offering_id`) REFERENCES `class_offerings` (`offering_id`);

--
-- Constraints for table `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`es_id`) REFERENCES `enrollment_subjects` (`es_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
