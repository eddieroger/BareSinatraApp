## Set up the logger
## Silenced. Uncomment this line to get a lot of verbosity.
#DataMapper::Logger.new($stdout, :info)


## TODO: If you are not using PostGRES, change this. It is based on Postgres.app from Heroku
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/appstore")
