/*
 * Student Registration Form
 * Handles: Add, Update, Delete, and List students (students table).
 *
 * NOTE FOR THE TEAM:
 * This file was rewritten by hand (not through the NetBeans GUI Design editor).
 * Please edit it only in the "Source" view. If you open the "Design" tab,
 * NetBeans may try to resync with the old .form file and could break this code.
 * If that happens, simply delete StudentRegistrationForm.form from the ui
 * package (Source view will still work fine without it).
 */
package ui;

import java.awt.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import util.DBConnection;

public class StudentRegistrationForm extends javax.swing.JFrame {

    private static final Logger logger = Logger.getLogger(StudentRegistrationForm.class.getName());

    // ----- form fields -----
    private JTextField txtStudentNo, txtFirstName, txtMiddleName, txtLastName;
    private JTextField txtBirthdate, txtAddress, txtContactNo, txtEmail;
    private JTextField txtGuardianName, txtGuardianContact;
    private JComboBox<ComboItem> cmbCourse;
    private JComboBox<Integer> cmbYearLevel;
    private JComboBox<String> cmbGender, cmbStatus;

    private JButton btnSave, btnUpdate, btnDelete, btnClear;
    private JTable tblStudents;
    private DefaultTableModel tableModel;

    // holds the student_id of the currently selected row (null = new record)
    private Integer selectedStudentId = null;

    public StudentRegistrationForm() {
        initComponents();
        loadCourses();
        loadStudents();
    }

    // Simple wrapper so the course combo box can display "BSIT - Bachelor of..."
    // while keeping the underlying course_id for saving.
    private static class ComboItem {
        int id;
        String label;
        ComboItem(int id, String label) { this.id = id; this.label = label; }
        @Override public String toString() { return label; }
    }

    private void initComponents() {
        setTitle("Student Registration");
        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setLayout(new BorderLayout(10, 10));

        JPanel formPanel = new JPanel(new GridBagLayout());
        formPanel.setBorder(BorderFactory.createEmptyBorder(15, 15, 15, 15));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(4, 4, 4, 4);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        txtStudentNo = new JTextField(15);
        txtFirstName = new JTextField(15);
        txtMiddleName = new JTextField(15);
        txtLastName = new JTextField(15);
        txtBirthdate = new JTextField(15);
        txtBirthdate.setToolTipText("Format: YYYY-MM-DD, e.g. 2005-06-21");
        txtAddress = new JTextField(15);
        txtContactNo = new JTextField(15);
        txtEmail = new JTextField(15);
        txtGuardianName = new JTextField(15);
        txtGuardianContact = new JTextField(15);
        cmbGender = new JComboBox<>(new String[]{"MALE", "FEMALE", "OTHER"});
        cmbStatus = new JComboBox<>(new String[]{"ACTIVE", "INACTIVE", "GRADUATED", "DROPPED"});
        cmbCourse = new JComboBox<>();
        cmbYearLevel = new JComboBox<>(new Integer[]{1, 2, 3, 4, 5});

        int row = 0;
        addField(formPanel, gbc, row++, "Student No:", txtStudentNo);
        addField(formPanel, gbc, row++, "First Name:", txtFirstName);
        addField(formPanel, gbc, row++, "Middle Name:", txtMiddleName);
        addField(formPanel, gbc, row++, "Last Name:", txtLastName);
        addField(formPanel, gbc, row++, "Birthdate:", txtBirthdate);
        addField(formPanel, gbc, row++, "Gender:", cmbGender);
        addField(formPanel, gbc, row++, "Address:", txtAddress);
        addField(formPanel, gbc, row++, "Contact No:", txtContactNo);
        addField(formPanel, gbc, row++, "Email:", txtEmail);
        addField(formPanel, gbc, row++, "Guardian Name:", txtGuardianName);
        addField(formPanel, gbc, row++, "Guardian Contact:", txtGuardianContact);
        addField(formPanel, gbc, row++, "Course:", cmbCourse);
        addField(formPanel, gbc, row++, "Year Level:", cmbYearLevel);
        addField(formPanel, gbc, row++, "Status:", cmbStatus);

        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        btnSave = new JButton("Save (New)");
        btnUpdate = new JButton("Update Selected");
        btnDelete = new JButton("Delete Selected");
        btnClear = new JButton("Clear Form");
        buttonPanel.add(btnSave);
        buttonPanel.add(btnUpdate);
        buttonPanel.add(btnDelete);
        buttonPanel.add(btnClear);

        gbc.gridx = 0; gbc.gridy = row; gbc.gridwidth = 2;
        formPanel.add(buttonPanel, gbc);

        tableModel = new DefaultTableModel(
                new Object[]{"ID", "Student No", "Name", "Course", "Year", "Status"}, 0) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        };
        tblStudents = new JTable(tableModel);
        tblStudents.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        JScrollPane tableScroll = new JScrollPane(tblStudents);
        tableScroll.setPreferredSize(new Dimension(400, 400));

        add(formPanel, BorderLayout.WEST);
        add(tableScroll, BorderLayout.CENTER);

        btnSave.addActionListener(e -> saveStudent());
        btnUpdate.addActionListener(e -> updateStudent());
        btnDelete.addActionListener(e -> deleteStudent());
        btnClear.addActionListener(e -> clearForm());
        tblStudents.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting()) fillFormFromSelectedRow();
        });

        pack();
        setLocationRelativeTo(null);
    }

    private void addField(JPanel panel, GridBagConstraints gbc, int row, String label, JComponent field) {
        gbc.gridx = 0; gbc.gridy = row; gbc.gridwidth = 1; gbc.weightx = 0;
        panel.add(new JLabel(label), gbc);
        gbc.gridx = 1; gbc.weightx = 1;
        panel.add(field, gbc);
    }

    // ---------- Data loading ----------

    private void loadCourses() {
        cmbCourse.removeAllItems();
        String sql = "SELECT course_id, course_code, course_name FROM courses ORDER BY course_code";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("course_id");
                String label = rs.getString("course_code") + " - " + rs.getString("course_name");
                cmbCourse.addItem(new ComboItem(id, label));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to load courses", e);
            JOptionPane.showMessageDialog(this, "Failed to load courses: " + e.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void loadStudents() {
        tableModel.setRowCount(0);
        String sql = "SELECT s.student_id, s.student_no, s.first_name, s.middle_name, s.last_name, "
                + "c.course_code, s.year_level, s.status "
                + "FROM students s JOIN courses c ON s.course_id = c.course_id "
                + "ORDER BY s.last_name, s.first_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String fullName = rs.getString("last_name") + ", " + rs.getString("first_name")
                        + (rs.getString("middle_name") != null ? " " + rs.getString("middle_name") : "");
                tableModel.addRow(new Object[]{
                        rs.getInt("student_id"),
                        rs.getString("student_no"),
                        fullName,
                        rs.getString("course_code"),
                        rs.getInt("year_level"),
                        rs.getString("status")
                });
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to load students", e);
            JOptionPane.showMessageDialog(this, "Failed to load students: " + e.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    // ---------- CRUD actions ----------

    private void saveStudent() {
        if (!validateForm()) return;
        String sql = "INSERT INTO students (student_no, first_name, middle_name, last_name, birthdate, "
                + "gender, address, contact_no, email, guardian_name, guardian_contact, course_id, "
                + "year_level, status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bindStudentFields(ps);
            ps.executeUpdate();
            JOptionPane.showMessageDialog(this, "Student registered successfully.");
            clearForm();
            loadStudents();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to save student", e);
            JOptionPane.showMessageDialog(this, "Failed to save student: " + e.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void updateStudent() {
        if (selectedStudentId == null) {
            JOptionPane.showMessageDialog(this, "Select a student from the table first.",
                    "No Selection", JOptionPane.WARNING_MESSAGE);
            return;
        }
        if (!validateForm()) return;
        String sql = "UPDATE students SET student_no=?, first_name=?, middle_name=?, last_name=?, "
                + "birthdate=?, gender=?, address=?, contact_no=?, email=?, guardian_name=?, "
                + "guardian_contact=?, course_id=?, year_level=?, status=? WHERE student_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bindStudentFields(ps);
            ps.setInt(15, selectedStudentId);
            ps.executeUpdate();
            JOptionPane.showMessageDialog(this, "Student updated successfully.");
            clearForm();
            loadStudents();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to update student", e);
            JOptionPane.showMessageDialog(this, "Failed to update student: " + e.getMessage(),
                    "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void deleteStudent() {
        if (selectedStudentId == null) {
            JOptionPane.showMessageDialog(this, "Select a student from the table first.",
                    "No Selection", JOptionPane.WARNING_MESSAGE);
            return;
        }
        int confirm = JOptionPane.showConfirmDialog(this,
                "Delete this student? This cannot be undone.",
                "Confirm Delete", JOptionPane.YES_NO_OPTION);
        if (confirm != JOptionPane.YES_OPTION) return;

        String sql = "DELETE FROM students WHERE student_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, selectedStudentId);
            ps.executeUpdate();
            JOptionPane.showMessageDialog(this, "Student deleted.");
            clearForm();
            loadStudents();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to delete student", e);
            JOptionPane.showMessageDialog(this, "Failed to delete student: " + e.getMessage()
                    + "\n(This can happen if the student already has enrollment or grade records.)",
                    "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    // binds the 14 student fields (student_no ... status) into a PreparedStatement,
    // used by both INSERT and UPDATE (UPDATE additionally sets param 15 = student_id)
    private void bindStudentFields(PreparedStatement ps) throws SQLException {
        ps.setString(1, txtStudentNo.getText().trim());
        ps.setString(2, txtFirstName.getText().trim());
        String middle = txtMiddleName.getText().trim();
        if (middle.isEmpty()) ps.setNull(3, Types.VARCHAR); else ps.setString(3, middle);
        ps.setString(4, txtLastName.getText().trim());

        String bday = txtBirthdate.getText().trim();
        if (bday.isEmpty()) ps.setNull(5, Types.DATE); else ps.setDate(5, java.sql.Date.valueOf(bday));

        ps.setString(6, (String) cmbGender.getSelectedItem());

        String addr = txtAddress.getText().trim();
        if (addr.isEmpty()) ps.setNull(7, Types.VARCHAR); else ps.setString(7, addr);

        String contact = txtContactNo.getText().trim();
        if (contact.isEmpty()) ps.setNull(8, Types.VARCHAR); else ps.setString(8, contact);

        String email = txtEmail.getText().trim();
        if (email.isEmpty()) ps.setNull(9, Types.VARCHAR); else ps.setString(9, email);

        String gname = txtGuardianName.getText().trim();
        if (gname.isEmpty()) ps.setNull(10, Types.VARCHAR); else ps.setString(10, gname);

        String gcontact = txtGuardianContact.getText().trim();
        if (gcontact.isEmpty()) ps.setNull(11, Types.VARCHAR); else ps.setString(11, gcontact);

        ComboItem course = (ComboItem) cmbCourse.getSelectedItem();
        ps.setInt(12, course.id);
        ps.setInt(13, (Integer) cmbYearLevel.getSelectedItem());
        ps.setString(14, (String) cmbStatus.getSelectedItem());
    }

    private boolean validateForm() {
        if (txtStudentNo.getText().trim().isEmpty()
                || txtFirstName.getText().trim().isEmpty()
                || txtLastName.getText().trim().isEmpty()) {
            JOptionPane.showMessageDialog(this,
                    "Student No, First Name and Last Name are required.",
                    "Missing Information", JOptionPane.WARNING_MESSAGE);
            return false;
        }
        if (cmbCourse.getSelectedItem() == null) {
            JOptionPane.showMessageDialog(this,
                    "No course found. Make sure the courses table has data.",
                    "Missing Information", JOptionPane.WARNING_MESSAGE);
            return false;
        }
        String bday = txtBirthdate.getText().trim();
        if (!bday.isEmpty()) {
            try {
                java.sql.Date.valueOf(bday);
            } catch (IllegalArgumentException ex) {
                JOptionPane.showMessageDialog(this,
                        "Birthdate must be in YYYY-MM-DD format (e.g. 2005-06-21), or left blank.",
                        "Invalid Date", JOptionPane.WARNING_MESSAGE);
                return false;
            }
        }
        return true;
    }

    private void fillFormFromSelectedRow() {
        int viewRow = tblStudents.getSelectedRow();
        if (viewRow < 0) return;
        int studentId = (int) tableModel.getValueAt(viewRow, 0);
        selectedStudentId = studentId;

        String sql = "SELECT * FROM students WHERE student_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    txtStudentNo.setText(rs.getString("student_no"));
                    txtFirstName.setText(rs.getString("first_name"));
                    txtMiddleName.setText(rs.getString("middle_name"));
                    txtLastName.setText(rs.getString("last_name"));
                    Date bday = rs.getDate("birthdate");
                    txtBirthdate.setText(bday != null ? bday.toString() : "");
                    cmbGender.setSelectedItem(rs.getString("gender"));
                    txtAddress.setText(rs.getString("address"));
                    txtContactNo.setText(rs.getString("contact_no"));
                    txtEmail.setText(rs.getString("email"));
                    txtGuardianName.setText(rs.getString("guardian_name"));
                    txtGuardianContact.setText(rs.getString("guardian_contact"));
                    cmbStatus.setSelectedItem(rs.getString("status"));
                    cmbYearLevel.setSelectedItem(rs.getInt("year_level"));
                    int courseId = rs.getInt("course_id");
                    for (int i = 0; i < cmbCourse.getItemCount(); i++) {
                        if (cmbCourse.getItemAt(i).id == courseId) {
                            cmbCourse.setSelectedIndex(i);
                            break;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to load selected student", e);
        }
    }

    private void clearForm() {
        selectedStudentId = null;
        txtStudentNo.setText("");
        txtFirstName.setText("");
        txtMiddleName.setText("");
        txtLastName.setText("");
        txtBirthdate.setText("");
        txtAddress.setText("");
        txtContactNo.setText("");
        txtEmail.setText("");
        txtGuardianName.setText("");
        txtGuardianContact.setText("");
        cmbGender.setSelectedIndex(0);
        cmbStatus.setSelectedIndex(0);
        cmbYearLevel.setSelectedIndex(0);
        tblStudents.clearSelection();
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ReflectiveOperationException | javax.swing.UnsupportedLookAndFeelException ex) {
            logger.log(Level.SEVERE, null, ex);
        }
        java.awt.EventQueue.invokeLater(() -> new StudentRegistrationForm().setVisible(true));
    }
}