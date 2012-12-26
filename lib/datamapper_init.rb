## Creates a default environment for DataMapper and preps it for use
#require 'data_mapper'

## Set up the logger
DataMapper::Logger.new($stdout, :warning)


## TODO: If you are not using PostGRES, change this. It is based on Postgres.app from Heroku
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/bareapp")
