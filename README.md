# Scientific Research Sample and Laboratory Specimen Registry

A responsive DBMS project built with Flask and SQLite. Includes a dashboard inspired by the requested reference image, sample CRUD, master-data listings, joined SQL views, reports, activity events, and a COMMIT/ROLLBACK demonstration.

## Features
- Dashboard summary cards, recent samples, activity, specimen-type distribution and status bars
- Create, read, update and delete sample records
- Search samples by code/name/project and filter by status
- Researchers, projects, specimen types and storage location pages
- SQL views: `v_sample_registry`, `v_project_sample_counts`, `v_storage_inventory`
- Reports by project, storage location and status; print/save as PDF
- Transaction demonstration using COMMIT and ROLLBACK
- SQLite foreign keys and referential integrity
- Responsive layout for desktop and mobile
- Render deployment configuration (`render.yaml`)

## Run on your computer for testing
1. Extract the ZIP.
2. Open this folder in VS Code.
3. In the terminal, run:
   - Windows: `py -m venv .venv`
   - Windows CMD: `.venv\Scripts\activate.bat`
   - Install: `python -m pip install -r requirements.txt`
   - Start: `python app.py`
4. Open `http://127.0.0.1:5000`.

If PowerShell blocks activation, use Command Prompt terminal and `.venv\Scripts\activate.bat`, or run `.venv\Scripts\python.exe -m pip install -r requirements.txt` and `.venv\Scripts\python.exe app.py` without activating.

## Publish it as a website (public URL)
This package includes `render.yaml` for deployment to Render:
1. Create/sign in to your Render account.
2. Put this project in a GitHub repository you control.
3. In Render, choose **New + → Blueprint** and connect the repository.
4. Confirm the service settings and deploy.
5. Open the HTTPS URL Render provides.

Important: deploying requires your own hosting account and authorization. The project package does not itself create a public URL. The default SQLite database is stored on the service filesystem; on free/ephemeral hosting it may reset on redeploy or restart. For persistent public use, attach a persistent disk or migrate to a managed PostgreSQL database and update the app configuration.

## Database initialization
The app creates `registry.db` and seeds demonstration data automatically on first run. The SQL schema is in `schema.sql`. Delete `registry.db` only if you intentionally want to reset the local demo database.

## ER model
- Researchers(researcher_id PK, full_name, email UNIQUE, department)
- Research_Projects(project_id PK, project_code UNIQUE, title, principal_investigator_id FK, start_date, status)
- Specimen_Types(type_id PK, type_name UNIQUE, description)
- Storage_Locations(location_id PK, location_code UNIQUE, room, storage_condition)
- Samples(sample_id PK, sample_code UNIQUE, sample_name, type_id FK, project_id FK, collected_by FK, collection_date, received_date, quantity, unit, location_id FK nullable, status, notes)
- Sample_Events(event_id PK, sample_id FK, event_type, event_date, performed_by FK, details)

## Functional dependencies and 3NF
- researcher_id → full_name, email, department; email → researcher_id, full_name, department (email is unique)
- project_id → project_code, title, principal_investigator_id, start_date, status; project_code → project_id, title, principal_investigator_id, start_date, status
- type_id → type_name, description; type_name → description
- location_id → location_code, room, storage_condition; location_code → room, storage_condition
- sample_id → sample_code, sample_name, type_id, project_id, collected_by, collection_date, received_date, quantity, unit, location_id, status, notes; sample_code → the remaining sample attributes
- event_id → sample_id, event_type, event_date, performed_by, details

The design is in 3NF because each table represents one entity/event, attributes depend on the key, and researcher/project/type/location details are referenced through foreign keys rather than repeated in Samples.

## Screenshots for submission
Run the application, open each page and take screenshots of:
1. Dashboard
2. Samples list and Add Sample form
3. Edit sample and delete confirmation
4. Researchers and projects
5. Reports and Database Views
6. Transaction COMMIT and ROLLBACK messages
7. ER diagram and database schema in your SQL editor

## Suggested viva points
- Primary key uniquely identifies a row; foreign key maintains referential integrity.
- CRUD means Create, Read, Update and Delete.
- A view is a saved query that presents derived data.
- COMMIT persists transaction changes; ROLLBACK cancels uncommitted changes.
- 3NF reduces duplication and update anomalies.

## Login and registration (added)

- Open `/register` to create an account using your name, email and password.
- Passwords are stored as Werkzeug password hashes, not plain text. Passwords must be at least 8 characters.
- After registration, the user is signed in and redirected to the dashboard.
- Existing registry pages require a signed-in session. Use **Sign out** in the top bar to end the session.
- The `users` table is created automatically on startup, so you do not need to edit or delete an existing `registry.db` file.

### Run locally on Windows

From the inner `scientific_specimen_registry_complete` project folder (the folder containing `app.py` and `requirements.txt`), open Command Prompt and run:

```cmd
..\.venv\Scripts\python.exe -m pip install -r requirements.txt
..\.venv\Scripts\python.exe app.py
```

If your virtual environment is located in this project folder instead of its parent folder, use `.venv\Scripts\python.exe` instead of `..\.venv\Scripts\python.exe`. Then visit `http://127.0.0.1:5000/register`.

### Before public deployment

Set a strong, private `SECRET_KEY` environment variable on the hosting service. Do not publish your secret key. For a public site with durable records, configure persistent storage for SQLite or use a managed database; a host's temporary filesystem can be reset. This project is an academic demo and should not store real sensitive medical or human-subject data without a proper security and compliance review.
