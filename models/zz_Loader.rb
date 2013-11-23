## OK, this isn't really a model. But it's loaded with the models to make sure that DataMapper is up to date.
## Has to be after the models (hence, sort), but can't be in lib

DataMapper.finalize
DataMapper.auto_upgrade!
#DataMapper.auto_migrate!
