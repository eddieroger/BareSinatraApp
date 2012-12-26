## User.
##
## The basic user model used to authenticate.

class User
  include DataMapper::Resource

  property :id,           Serial
  property :email,        String,       :required => true, :unique => true
  property :password,     BCryptHash,   :required => true
  property :created_at,   DateTime
  property :admin,        Boolean,      :default => false

  attr_accessor :password_confirmation
  validates_confirmation_of :password, :if => :password_changed?

  def username
    self.email
  end

  def password_changed?
    new? or dirty_attributes.has_key?(:password)
  end

  def self.authenticate(email, password)
    return nil unless (user = first(:email => email))
    user.password == password ? user : nil
  end
end

## Make sure the database model matches this one. NOTE: This is not destructive
DataMapper.auto_upgrade!