ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database =>  "#{ROOT}/db/time_daily.sqlite3"
)