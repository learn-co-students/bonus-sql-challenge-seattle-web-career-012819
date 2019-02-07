require 'bundler'
require 'csv'
require 'sqlite3'
Bundler.require

# db = SQLite3::Database.new ":memory"
# open connection to extant database
db = SQLite3::Database.new "labs_database.db"
