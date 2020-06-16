# Parse the CSV and seed the database here! Run 'ruby db/seed' to execute this code.

# Create table, 1-to-1 with csv
# YEAR,GoogleKnowlege_Occupation,Show,Group,Raw_Guest_List
rows = db.execute <<-SQL
  create table daily_show_guests_raw (
    id INTEGER PRIMARY KEY
    , year TEXT
    , occupation TEXT
    , show_airing_date TEXT
    , occupation_group TEXT
    , guest_name TEXT
  );
SQL

# csv_import = CSV.read("daily_show_guests.csv")
csv_import = CSV.read("daily_show_guests.csv", headers: true)
csv_import.each do |row|
  db.execute "insert into daily_show_guests_raw (year, occupation, show_airing_date, occupation_group, guest_name) values (?, ?, ?, ?, ?)"
    , row.fields # equivalent to: [row['name'], row['age']]
end

occupations_create = <<-SQL
  CREATE TABLE occupations
  (
      id INTEGER PRIMARY KEY
    , name TEXT
    , occupation_group TEXT
  );
  INSERT INTO occupations (name, group)
  SELECT distinct
    occupation
  , occupation_group
  from
    daily_show_guests_raw
  group by
    occupation
  , occupation_group
  ;
  SQL

guests_create = <<-SQL
  CREATE TABLE guests
  (
      id INTEGER PRIMARY KEY
    , name TEXT
    , occupation_id INTEGER
  );
  INSERT INTO guests (name, occupation_id)
  SELECT distinct
    guest_name
  , o.id
  FROM
   daily_show_guests_raw d
  JOIN
   occupations o on o.name = d.occupation
  ;
  SQL
episodes_create = <<-SQL
  CREATE TABLE episodes
  (
      id INTEGER PRIMARY KEY
    , aired_date TEXT
    , aired_year TEXT
    , guest_id INTEGER
  );
  INSERT INTO episodes (aired_date, aired_year, guest_id)
  select
    d.show_airing_date
  , d.year
  , g.id
  from daily_show_guests_raw d
  join guests g on g.name = d.guest_name
  join occupations o on o.id = g.occupation_id and o.name = d.occupation
  SQL
