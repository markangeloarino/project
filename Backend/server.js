const express = require('express');
const mariadb = require('mariadb');
const bcrypt = require('bcrypt');
const cors = require('cors'); 

const app = express();
app.use(express.json());
app.use(cors()); 

// Connect to your local XAMPP/HeidiSQL database
const pool = mariadb.createPool({
     host: 'localhost', 
     user: 'root', 
     password: '', 
     database: 'neis_db'
});

// TEST ROUTE
app.get('/', (req, res) => {
    res.send("NEIS Backend Server is running!");
});

// ==========================================
// MODULE 1: JOB SEEKER AUTHENTICATION
// ==========================================

app.post('/api/register', async (req, res) => {
    const { firstName, lastName, email, password } = req.body;
    let conn;
    try {
        conn = await pool.getConnection();
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        await conn.query(
            "INSERT INTO job_seekers (first_name, last_name, email, password_hash) VALUES (?, ?, ?, ?)",
            [firstName, lastName, email, hashedPassword]
        );
        res.status(201).json({ message: "Account created successfully!" });
    } catch (err) {
        res.status(500).json({ error: "Registration failed: " + err.message });
    } finally {
        if (conn) conn.release();
    }
});

app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;
    let conn;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query("SELECT * FROM job_seekers WHERE email = ?", [email]);
        
        if (rows.length === 0) return res.status(404).json({ error: "User not found" });

        const user = rows[0];
        const validPassword = await bcrypt.compare(password, user.password_hash);
        if (!validPassword) return res.status(401).json({ error: "Invalid password" });

        delete user.password_hash; 
        res.status(200).json({ message: "Login successful", user: user });
    } catch (err) {
        res.status(500).json({ error: "Login failed" });
    } finally {
        if (conn) conn.release();
    }
});

// ==========================================
// MODULE 2: METRO PESO ASSISTED ENTRY
// ==========================================

// POST: Submit a new job application
app.post('/api/applications', async (req, res) => {
    const { seeker_id, vacancy_id } = req.body;

    if (!seeker_id || !vacancy_id) {
        return res.status(400).json({ error: "Missing seeker ID or vacancy ID." });
    }

    let conn;
    try {
        conn = await pool.getConnection();
        const result = await conn.query(
            "INSERT INTO job_applications (seeker_id, vacancy_id) VALUES (?, ?)",
            [seeker_id, vacancy_id]
        );
        res.status(201).json({ message: "Application submitted successfully!", applicationId: result.insertId.toString() });
    } catch (err) {
        // Error 1062 is MariaDB's code for a duplicate entry (because of our UNIQUE KEY)
        if (err.code === 'ER_DUP_ENTRY') {
            res.status(409).json({ error: "You have already applied for this position." });
        } else {
            res.status(500).json({ error: "Database error: " + err.message });
        }
    } finally {
        if (conn) conn.release();
    }
});

// Start the server
app.listen(3000, () => {
    console.log('NEIS Node Backend running on http://localhost:3000');
});


// Fetch all active job vacancies for the public board
app.get('/api/vacancies', async (req, res) => {
    let conn;
    try {
        conn = await pool.getConnection();
        // Fetch jobs and sort them so the newest ones are at the top
        const rows = await conn.query("SELECT * FROM job_vacancies ORDER BY date_posted DESC");
        res.status(200).json(rows);
    } catch (err) {
        res.status(500).json({ error: "Failed to fetch job vacancies: " + err.message });
    } finally {
        if (conn) conn.release();
    }
});

// PUT: Update an existing job vacancy
app.put('/api/vacancies/:id', async (req, res) => {
    const vacancyId = req.params.id;
    const { 
        job_title, employer_name, years_experience, salary, 
        vacancies_count, employment_type, industry, location, 
        job_description, qualifications, application_deadline, job_location_type,
        status, employer_career_link // NEW: Added link field
    } = req.body;

    let conn;
    try {
        conn = await pool.getConnection();
        const query = `
            UPDATE job_vacancies SET 
            job_title = ?, employer_name = ?, years_experience = ?, salary = ?, 
            vacancies_count = ?, employment_type = ?, industry = ?, location = ?, 
            job_description = ?, qualifications = ?, application_deadline = ?, job_location_type = ?,
            status = ?, employer_career_link = ? 
            WHERE vacancy_id = ?
        `;
        const values = [
            job_title, employer_name, years_experience, salary, 
            vacancies_count, employment_type, industry, location, 
            job_description, qualifications, application_deadline, job_location_type, 
            status, employer_career_link || null, vacancyId // NEW: Update link
        ];
        
        await conn.query(query, values);
        res.status(200).json({ message: "Job updated successfully!" });
    } catch (err) {
        res.status(500).json({ error: "Failed to update vacancy: " + err.message });
    } finally {
        if (conn) conn.release();
    }
});

// ============================= // 
//           JOB POSTING         // 
// ============================= // 


// DELETE: Remove a job vacancy (Close the posting)
app.delete('/api/vacancies/:id', async (req, res) => {
    const vacancyId = req.params.id;
    let conn;
    try {
        conn = await pool.getConnection();
        // Note: Because of ON DELETE CASCADE in your applications table, 
        // deleting a vacancy will also safely delete its pending applications.
        const result = await conn.query("DELETE FROM job_vacancies WHERE vacancy_id = ?", [vacancyId]);
        
        if (result.affectedRows > 0) {
            res.status(200).json({ message: "Job posting successfully closed/deleted." });
        } else {
            res.status(404).json({ error: "Job vacancy not found." });
        }
    } catch (err) {
        res.status(500).json({ error: "Failed to delete vacancy: " + err.message });
    } finally {
        if (conn) conn.release();
    }
});



 
// ==========================================
// MODULE 1: EMPLOYER
// ==========================================

// POST: Register a new Employer (Metro PESO Staff)
app.post('/api/employers', async (req, res) => {
    const { 
        company_name, industry, website, contact_person, 
        email, phone, address, logo_url, status,
        company_description // NEW: Added company description
    } = req.body;

    if (!company_name || !industry || !contact_person || !email) {
        return res.status(400).json({ error: "Missing required employer fields." });
    }

    let conn;
    try {
        conn = await pool.getConnection();
        const result = await conn.query(
            "INSERT INTO employers (company_name, industry, website, contact_person, email, phone, address, logo_url, status, company_description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            [
                company_name, industry, website || null, contact_person, 
                email, phone, address, logo_url || null, status || 'Active',
                company_description || '' // NEW: Passed to query
            ]
        );
        res.status(201).json({ message: "Employer registered successfully!" });
    } catch (err) {
        if (err.code === 'ER_DUP_ENTRY') {
            res.status(409).json({ error: "An employer with this email already exists." });
        } else {
            res.status(500).json({ error: "Database error: " + err.message });
        }
    } finally {
        if (conn) conn.release();
    }
});

// PUT: Update an existing Employer
app.put('/api/employers/:id', async (req, res) => {
    const employerId = req.params.id;
    const { 
        company_name, industry, website, contact_person, 
        email, phone, address, logo_url, status, company_description 
    } = req.body;

    let conn;
    try {
        conn = await pool.getConnection();
        const query = `
            UPDATE employers SET 
            company_name = ?, industry = ?, website = ?, contact_person = ?, 
            email = ?, phone = ?, address = ?, logo_url = ?, status = ?, company_description = ?
            WHERE employer_id = ?
        `;
        await conn.query(query, [
            company_name, industry, website || null, contact_person, 
            email, phone, address, logo_url || null, status || 'Active', 
            company_description || '', employerId
        ]);
        res.status(200).json({ message: "Employer updated successfully!" });
    } catch (err) {
        res.status(500).json({ error: "Failed to update employer: " + err.message });
    } finally {
        if (conn) conn.release();
    }
});

// DELETE: Remove an Employer (With Validation Check)
app.delete('/api/employers/:id', async (req, res) => {
    const employerId = req.params.id;
    let conn;
    try {
        conn = await pool.getConnection();
        
        // 1. Get the employer's company name first
        const empRows = await conn.query("SELECT company_name FROM employers WHERE employer_id = ?", [employerId]);
        if (empRows.length === 0) {
            return res.status(404).json({ error: "Employer not found." });
        }
        const companyName = empRows[0].company_name;

        // 2. Check if they have any existing job postings
        const jobRows = await conn.query("SELECT COUNT(*) as count FROM job_vacancies WHERE employer_name = ?", [companyName]);
        
        if (jobRows[0].count > 0) {
            // Block deletion if jobs exist
            return res.status(400).json({ error: "Cannot delete this employer because they have existing job postings. Close or delete their jobs first." });
        }

        // 3. Safe to delete
        await conn.query("DELETE FROM employers WHERE employer_id = ?", [employerId]);
        res.status(200).json({ message: "Employer successfully deleted." });
    } catch (err) {
        res.status(500).json({ error: "Failed to delete employer: " + err.message });
    } finally {
        if (conn) conn.release();
    }
});

// GET: Fetch all registered employers
app.get('/api/employers', async (req, res) => {
    let conn;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query("SELECT * FROM employers ORDER BY registered_at DESC");
        res.status(200).json(rows);
    } catch (err) {
        res.status(500).json({ error: "Failed to fetch employers: " + err.message });
    } finally {
        if (conn) conn.release();
    }
});


// ==========================================
// MODULE 3: JOB SEEKER PROFILE & TRACKING
// ==========================================

// GET: Fetch all applications for a specific job seeker
app.get('/api/applications/seeker/:id', async (req, res) => {
    const seekerId = req.params.id;
    let conn;
    try {
        conn = await pool.getConnection();
        const query = `
            SELECT a.application_id, a.status, a.applied_at, 
                   v.job_title, v.employer_name, v.location
            FROM job_applications a
            JOIN job_vacancies v ON a.vacancy_id = v.vacancy_id
            WHERE a.seeker_id = ?
            ORDER BY a.applied_at DESC
        `;
        const rows = await conn.query(query, [seekerId]);
        res.status(200).json(rows);
    } catch (err) {
        res.status(500).json({ error: "Failed to fetch applications: " + err.message });
    } finally {
        if (conn) conn.release();
    }
});

// PUT: Update Job Seeker Profile (Skills & Contact)
app.put('/api/seekers/:id', async (req, res) => {
    const seekerId = req.params.id;
    const { contact_number, skills } = req.body;
    let conn;
    try {
        conn = await pool.getConnection();
        await conn.query(
            "UPDATE job_seekers SET contact_number = ?, skills = ? WHERE seeker_id = ?",
            [contact_number || null, skills || null, seekerId]
        );
        res.status(200).json({ message: "Profile updated successfully!" });
    } catch (err) {
        res.status(500).json({ error: "Failed to update profile: " + err.message });
    } finally {
        if (conn) conn.release();
    }
});


 


// ==========================================
// JOB SEEKER AUTHENTICATION
// ==========================================
app.post('/api/register', async (req, res) => {
    const { firstName, lastName, email, password } = req.body;
    let conn;
    try {
        conn = await pool.getConnection();
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        await conn.query(
            "INSERT INTO job_seekers (first_name, last_name, email, password_hash) VALUES (?, ?, ?, ?)",
            [firstName, lastName, email, hashedPassword]
        );
        res.status(201).json({ message: "Account created successfully!" });
    } catch (err) {
        res.status(500).json({ error: "Registration failed: " + err.message });
    } finally {
        if (conn) conn.release();
    }
});

app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;
    let conn;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query("SELECT * FROM job_seekers WHERE email = ?", [email]);
        if (rows.length === 0) return res.status(404).json({ error: "User not found" });
        const user = rows[0];
        const validPassword = await bcrypt.compare(password, user.password_hash);
        if (!validPassword) return res.status(401).json({ error: "Invalid password" });
        delete user.password_hash; 
        res.status(200).json({ message: "Login successful", user: user });
    } catch (err) {
        res.status(500).json({ error: "Login failed" });
    } finally {
        if (conn) conn.release();
    }
});

// ==========================================
// ADMIN / STAFF MODULE
// ==========================================
app.post('/api/staff/login', async (req, res) => {
    const { email, password } = req.body;
    let conn;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query("SELECT * FROM peso_staff WHERE email = ?", [email]);
        if (rows.length === 0) return res.status(404).json({ error: "Staff member not found" });
        const staff = rows[0];
        const validPassword = await bcrypt.compare(password, staff.password_hash);
        if (!validPassword) return res.status(401).json({ error: "Invalid password" });
        delete staff.password_hash; 
        res.status(200).json({ message: "Staff login successful", user: staff });
    } catch (err) {
        res.status(500).json({ error: "Login failed" });
    } finally {
        if (conn) conn.release();
    }
});

app.get('/api/admin/applications', async (req, res) => {
    let conn;
    try {
        conn = await pool.getConnection();
        const query = `
            SELECT a.application_id, a.status, a.applied_at, 
                   v.job_title, v.employer_name, 
                   s.first_name, s.last_name, s.email, s.contact_number
            FROM job_applications a
            JOIN job_vacancies v ON a.vacancy_id = v.vacancy_id
            JOIN job_seekers s ON a.seeker_id = s.seeker_id
            ORDER BY a.applied_at DESC
        `;
        const rows = await conn.query(query);
        res.status(200).json(rows);
    } catch (err) {
        res.status(500).json({ error: "Failed to fetch all applications" });
    } finally {
        if (conn) conn.release();
    }
});

app.put('/api/admin/applications/:id/status', async (req, res) => {
    const appId = req.params.id;
    const { status } = req.body; // e.g., 'Approved', 'Rejected', 'Hired'
    let conn;
    try {
        conn = await pool.getConnection();
        await conn.query("UPDATE job_applications SET status = ? WHERE application_id = ?", [status, appId]);
        res.status(200).json({ message: "Status updated successfully!" });
    } catch (err) {
        res.status(500).json({ error: "Failed to update status" });
    } finally {
        if (conn) conn.release();
    }
});

// ==========================================
// JOB VACANCIES & EMPLOYERS
// ==========================================
app.get('/api/vacancies', async (req, res) => {
    let conn;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query("SELECT * FROM job_vacancies ORDER BY date_posted DESC");
        res.status(200).json(rows);
    } catch (err) { res.status(500).json({ error: err.message }); } finally { if (conn) conn.release(); }
});

// POST: Encode a new job vacancy (Assisted Entry)
app.post('/api/vacancies', async (req, res) => {
    const { 
        job_title, employer_name, years_experience, salary, 
        vacancies_count, employment_type, industry, location, 
        job_description, qualifications, application_deadline, job_location_type,
        status, employer_career_link // NEW: Added link field
    } = req.body;

    if (!job_title || !employer_name) {
        return res.status(400).json({ error: "Job title and Employer name are required." });
    }

    let conn;
    try {
        conn = await pool.getConnection();
        const query = `
            INSERT INTO job_vacancies 
            (job_title, employer_name, encoded_by_staff_id, years_experience, salary, vacancies_count, employment_type, industry, location, job_description, qualifications, application_deadline, job_location_type, status, employer_career_link) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;
        const values = [
            job_title, employer_name, 1, years_experience || 0, salary || 'Not specified', 
            vacancies_count || 1, employment_type || 'Full-time', industry || '', 
            location || '', job_description || '', qualifications || '', 
            application_deadline || null, job_location_type || 'Local', 
            status || 'Active', employer_career_link || null // NEW: Insert link
        ];
        
        const result = await conn.query(query, values);
        res.status(201).json({ message: "Job encoded successfully!", vacancyId: result.insertId.toString() });
    } catch (err) {
        res.status(500).json({ error: "Database error: " + err.message });
    } finally {
        if (conn) conn.release();
    }
});


// POST: Admin/Staff Login
app.post('/api/staff/login', async (req, res) => {
    const { email, password } = req.body;
    let conn;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query("SELECT * FROM peso_staff WHERE email = ?", [email]);
        
        if (rows.length === 0) return res.status(404).json({ error: "Account not found" });

        const user = rows[0];
        const validPassword = await bcrypt.compare(password, user.password_hash);
        if (!validPassword) return res.status(401).json({ error: "Invalid password" });

        delete user.password_hash; 
        
        // Returns the user object, which now includes the 'role' ('Admin' or 'Staff')
        res.status(200).json({ message: "Login successful", user: user });
    } catch (err) {
        res.status(500).json({ error: "Login failed" });
    } finally {
        if (conn) conn.release();
    }
});

 


const crypto = require('crypto'); // Add this at the top of server.js with your other requires

// ==========================================
// ADMIN MODULE - MANAGE STAFF (CRUD)
// ==========================================

// 1. CREATE Staff (Generates temporary password)
app.post('/api/admin/staff', async (req, res) => {
    const { name, email, role } = req.body;
    // Generate an 8-character random temporary password
    const tempPassword = crypto.randomBytes(4).toString('hex'); 
    
    let conn;
    try {
        conn = await pool.getConnection();
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(tempPassword, salt);

        await conn.query(
            "INSERT INTO peso_staff (name, email, password_hash, role) VALUES (?, ?, ?, ?)",
            [name, email, hashedPassword, role || 'Staff']
        );
        
        // In a real app, you would use NodeMailer here to send the tempPassword via email.
        res.status(201).json({ 
            message: "Staff created successfully!", 
            tempPassword: tempPassword // Sending back so Admin can see it for testing
        });
    } catch (err) {
        if (err.errno === 1062) res.status(409).json({ error: "Email already exists." });
        else res.status(500).json({ error: "Failed to create staff account." });
    } finally {
        if (conn) conn.release();
    }
});

// 2. READ All Staff
app.get('/api/admin/staff', async (req, res) => {
    let conn;
    try {
        conn = await pool.getConnection();
        // Fetch everyone except the current Admin to prevent self-deletion
        const rows = await conn.query("SELECT staff_id, name, email, role FROM peso_staff WHERE role != 'Admin' ORDER BY name ASC");
        res.status(200).json(rows);
    } catch (err) {
        res.status(500).json({ error: "Failed to fetch staff list." });
    } finally {
        if (conn) conn.release();
    }
});

// 3. UPDATE Staff Details
app.put('/api/admin/staff/:id', async (req, res) => {
    const staffId = req.params.id;
    const { name, email, role } = req.body;
    let conn;
    try {
        conn = await pool.getConnection();
        await conn.query(
            "UPDATE peso_staff SET name = ?, email = ?, role = ? WHERE staff_id = ?",
            [name, email, role, staffId]
        );
        res.status(200).json({ message: "Staff record updated successfully!" });
    } catch (err) {
        res.status(500).json({ error: "Failed to update staff record." });
    } finally {
        if (conn) conn.release();
    }
});

// 4. RESET Password
app.put('/api/admin/staff/:id/reset-password', async (req, res) => {
    const staffId = req.params.id;
    const tempPassword = crypto.randomBytes(4).toString('hex'); 
    
    let conn;
    try {
        conn = await pool.getConnection();
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(tempPassword, salt);

        await conn.query("UPDATE peso_staff SET password_hash = ? WHERE staff_id = ?", [hashedPassword, staffId]);
        
        res.status(200).json({ 
            message: "Password reset successful!", 
            tempPassword: tempPassword 
        });
    } catch (err) {
        res.status(500).json({ error: "Failed to reset password." });
    } finally {
        if (conn) conn.release();
    }
});

// 5. DELETE Staff
app.delete('/api/admin/staff/:id', async (req, res) => {
    const staffId = req.params.id;
    let conn;
    try {
        conn = await pool.getConnection();
        await conn.query("DELETE FROM peso_staff WHERE staff_id = ?", [staffId]);
        res.status(200).json({ message: "Staff account deleted successfully!" });
    } catch (err) {
        // Handle Foreign Key constraints if the staff member already encoded jobs
        if (err.errno === 1451) {
            res.status(400).json({ error: "Cannot delete this staff member because they have encoded job vacancies." });
        } else {
            res.status(500).json({ error: "Failed to delete staff account." });
        }
    } finally {
        if (conn) conn.release();
    }
});