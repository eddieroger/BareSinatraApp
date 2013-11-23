## User.
##
## The basic user model used to authenticate.

class User
  include DataMapper::Resource

  # Required stuff
  property :id,           Serial
  property :email,        String,       :required => true, :unique => true
  property :password,     BCryptHash,   :required => true, :length => 6..255

  # Optional stuff
  property :first_name,   String
  property :last_name,    String
  property :admin,        Boolean,      :default => false
  property :approved,     Boolean,      :default => false

  # System stuff
  property :remember_token,  String
  property :created_at,   DateTime

  attr_accessor :password_confirmation
  validates_confirmation_of :password, :if => :password_required?

  validates_with_block :password_confirmation do
    if password_required? && self.password_confirmation.length < 6
      return [false, "Password must be more than"]
    else
      return true
    end
  end

  def to_s
    return "User: #{self.display_name}"
  end #to_s

  def username
    self.email
  end

  def display_name
    if self.first_name
      return self.first_name
    else
      return self.email
    end
  end #display_name

  def password_required?
    new? or dirty_attributes.has_key?(:password)
  end

  def self.authenticate(email, password, remember_me)
    puts "User#authenticate!"
    return nil unless (user = first(:email => email, :approved => true))
    if user.password == password # ? user : nil
      if remember_me
        user.generate_remember_token!
      end
      return user
    else
      return nil
    end

  end

  def generate_remember_token!
    self.remember_token = SecureRandom.uuid
    self.save

    return self.remember_token
  end #generate_remember_token!

  def invalidate_remember_token!
    self.remember_token = nil
    self.save
  end #invalidate_remember_token!
end

## Make sure the database model matches this one. NOTE: This is not destructive
DataMapper.auto_upgrade!