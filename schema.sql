PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS researchers (
  researcher_id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  department TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS research_projects (
  project_id INTEGER PRIMARY KEY AUTOINCREMENT,
  project_code TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  principal_investigator_id INTEGER NOT NULL,
  start_date TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'Active',
  FOREIGN KEY (principal_investigator_id) REFERENCES researchers(researcher_id)
);

CREATE TABLE IF NOT EXISTS specimen_types (
  type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  type_name TEXT NOT NULL UNIQUE,
  description TEXT
);

CREATE TABLE IF NOT EXISTS storage_locations (
  location_id INTEGER PRIMARY KEY AUTOINCREMENT,
  location_code TEXT NOT NULL UNIQUE,
  room TEXT NOT NULL,
  storage_condition TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS samples (
  sample_id INTEGER PRIMARY KEY AUTOINCREMENT,
  sample_code TEXT NOT NULL UNIQUE,
  sample_name TEXT NOT NULL,
  type_id INTEGER NOT NULL,
  project_id INTEGER NOT NULL,
  collected_by INTEGER NOT NULL,
  collection_date TEXT NOT NULL,
  received_date TEXT NOT NULL,
  quantity REAL NOT NULL DEFAULT 1,
  unit TEXT NOT NULL DEFAULT 'sample',
  location_id INTEGER,
  status TEXT NOT NULL DEFAULT 'Registered',
  notes TEXT DEFAULT '',
  FOREIGN KEY (type_id) REFERENCES specimen_types(type_id),
  FOREIGN KEY (project_id) REFERENCES research_projects(project_id),
  FOREIGN KEY (collected_by) REFERENCES researchers(researcher_id),
  FOREIGN KEY (location_id) REFERENCES storage_locations(location_id)
);

CREATE TABLE IF NOT EXISTS sample_events (
  event_id INTEGER PRIMARY KEY AUTOINCREMENT,
  sample_id INTEGER NOT NULL,
  event_type TEXT NOT NULL,
  event_date TEXT NOT NULL,
  performed_by INTEGER NOT NULL,
  details TEXT DEFAULT '',
  FOREIGN KEY (sample_id) REFERENCES samples(sample_id) ON DELETE CASCADE,
  FOREIGN KEY (performed_by) REFERENCES researchers(researcher_id)
);

CREATE VIEW IF NOT EXISTS v_sample_registry AS
SELECT s.sample_id, s.sample_code, s.sample_name, st.type_name,
       rp.project_code, rp.title AS project_title, r.full_name AS collected_by,
       s.collection_date, s.received_date, s.quantity, s.unit,
       sl.location_code, s.status
FROM samples s
JOIN specimen_types st ON st.type_id=s.type_id
JOIN research_projects rp ON rp.project_id=s.project_id
JOIN researchers r ON r.researcher_id=s.collected_by
LEFT JOIN storage_locations sl ON sl.location_id=s.location_id;

CREATE VIEW IF NOT EXISTS v_project_sample_counts AS
SELECT rp.project_id, rp.project_code, rp.title,
       COUNT(s.sample_id) AS sample_count
FROM research_projects rp
LEFT JOIN samples s ON s.project_id=rp.project_id
GROUP BY rp.project_id, rp.project_code, rp.title;

CREATE VIEW IF NOT EXISTS v_storage_inventory AS
SELECT sl.location_id, sl.location_code, sl.room, sl.storage_condition,
       COUNT(s.sample_id) AS sample_count
FROM storage_locations sl
LEFT JOIN samples s ON s.location_id=sl.location_id
GROUP BY sl.location_id, sl.location_code, sl.room, sl.storage_condition;
