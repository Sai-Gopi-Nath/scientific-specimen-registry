# PROJECT REPORT
## Scientific Research Sample and Laboratory Specimen Registry

### 1. Abstract
The Scientific Research Sample and Laboratory Specimen Registry is a relational database application for recording and tracking research samples. It organizes researchers, research projects, specimen categories, storage locations, samples, and sample events. A Flask web interface provides sample CRUD operations, searchable records, summary reports, and a transaction demonstration.

### 2. Problem statement
Research laboratories need a consistent method to identify collected specimens, associate them with projects and responsible researchers, record collection and receipt dates, and track storage and usage status. Scattered records can lead to duplication, missing information, and weak traceability.

### 3. Objectives
- Design a normalized relational schema.
- Enforce entity relationships using primary and foreign keys.
- Implement CRUD operations for sample records.
- Present useful joined views and summary reports.
- Demonstrate COMMIT and ROLLBACK.
- Provide a browser-based interface suitable for a project demonstration.

### 4. Tools
Python, Flask, SQLite, HTML, CSS, Jinja templates, GitHub and Render (optional deployment).

### 5. Entities
Researchers, Research_Projects, Specimen_Types, Storage_Locations, Samples and Sample_Events.

### 6. Relationship summary
- One researcher may collect many samples.
- One researcher may lead many projects.
- One project contains many samples.
- One specimen type classifies many samples.
- One storage location may contain many samples; location is optional while a sample is unassigned.
- One sample may have many event-history records.
- Each event is performed by one researcher.

### 7. Normalization
**1NF:** All fields store single/atomic values; repeating groups are separated into related tables.

**2NF:** Each table uses a single-column primary key, so non-key attributes depend on the whole key.

**3NF:** Researcher, project, type and storage attributes are stored in their own tables and referenced by foreign keys. In each entity table, non-key attributes depend on the key rather than on another non-key attribute. UNIQUE constraints protect business identifiers such as sample_code and project_code.

### 8. Implementation
The application initializes the SQLite schema and demonstration data on first run. The dashboard summarizes registry data. The Samples page supports searching, status filtering, insertion, editing and deletion. Reports aggregate sample counts by project, location and status. Database Views displays joined data from the `v_sample_registry` view. The transaction page demonstrates saved and cancelled event inserts.

### 9. Testing
- Add a sample with a unique sample code: expected to save successfully.
- Add a duplicate sample code: expected to fail due to the UNIQUE constraint.
- Edit an existing sample: expected fields are updated.
- Delete a sample: expected record is removed, subject to referential integrity.
- Search by code/name/project: expected matching records are returned.
- Run COMMIT: a transaction demo event is saved.
- Run ROLLBACK: the inserted event is cancelled.
- Open reports/views: totals are calculated from current database records.

### 10. Security and limitations
This is an academic demonstration, not a production laboratory information system. It does not implement user authentication, authorization, audit-grade immutable logs, encryption at rest, regulatory compliance, or clinical workflow controls. Do not enter real patient or sensitive research data. Public deployment should use a strong secret key, access controls, persistent database storage, backups and institutional review.

### 11. Conclusion
The project demonstrates relational schema design, referential integrity, normalization, CRUD, SQL views, reporting, and transaction control in a web-based registry.

### 12. References
- Python documentation: https://docs.python.org/3/
- Flask documentation: https://flask.palletsprojects.com/
- SQLite documentation: https://www.sqlite.org/docs.html
