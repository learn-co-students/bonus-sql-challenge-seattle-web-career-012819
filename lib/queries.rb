# Write methods that return SQL queries for each part of the challeng here

# 1. Who did Jon Stewart have on the Daily Show the most?
def guest_with_most_appearances
  sql = <<-SQL
    select
      guest_name
    FROM
      daily_show_guests_raw
    group by
     guest_name
    order by count(*) desc
    limit 1
     ;
  SQL
  sql
end

# 2. What was the most popular profession of guest for each year Jon Stewart hosted the Daily Show?

# 3. What profession was on the show most overall?
def profession_most_visits
  sql = <<-SQL
    select
      o.name
    , count(*)
    from episodes e
    join guests g on g.id = e.guest_id
    join occupations o on o.id = g.occupation_id
    group by
      o.name
    order by
     count(*) desc
    limit 1
    ;
  SQL
  sql
end

# 4. How many people did Jon Stewart have on with the first name of Bill?
def ct_of_guests_named_bill
sql = <<-SQL
  select
    count(*)
  from guests
  where
    substr(name, 1, instr(name, " ")-1) = "Bill"
    ;
  SQL
  sql
end

# 5. What dates did Patrick Stewart appear on the show?
def patrick_stewart_dates
  sql = <<-SQL
      select
        e.aired_date
      from episodes e
      join guests g on g.id = e.guest_id
      where
        g.name = "Patrick Stewart"
      ;
    SQL
    sql
end

# 6. Which year had the most guests?
def year_with_most_guests
  sql = <<-SQL
        select
          e.aired_year
        from
          episodes e
        join guests g on g.id = e.guest_id
        where
          g.name not in ("no guest", "none", "(None)", "(no guest")
        group by
          e.aired_year
        order by
          count(*) desc
        limit 1
          ;
    SQL
    sql
end

# 7. What was the most popular "Group" for each year Jon Stewart hosted?
