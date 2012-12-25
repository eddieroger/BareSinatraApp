## User.
##
## The basic user model used to authenticate.

require 'data_mapper'

class User
  include DataMapper::Resource

  property :id,           Serial
  property :email,        String
  property :password,     BCryptHash
  property :created_at,   DateTime

  attr_accessor :confirmation_password
  validates_confirmation_of :password, :if => :password_changed?

  def password_changed?
    new? or dirty_attributes.has_key?(:password)
  end

  def self.authenticate(username, password)
    return nil unless (user = first(:username => username))
    user.password == password ? user : nil
  end
end

## Make sure the database model matches this one. NOTE: This is not destructive
DataMapper.auto_upgrade!