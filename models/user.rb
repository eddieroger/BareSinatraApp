## User.
##
## The basic user model used to authenticate.

class User < ActiveRecord::Base
  include BCrypt

  has_secure_password

  has_many :apiTokens


  def to_s
    return "User: #{self.display_name}"
  end #to_s

  def display_name
    if self.first_name
      return self.first_name
    else
      return self.username
    end
  end #display_name

  def self.authenticate(username, password, remember_me)
    return nil unless (user = first(:username => username, :approved => true))
    if user.password == password # ? user : nil
      if remember_me
        user.generate_remember_token!
      end
      return user
    else
      return nil
    end

  end

end

## Make sure the database model matches this one. NOTE: This is not destructive
# DataMapper.auto_upgrade!

# include DataMapper::Resource

  # # Required stuff
  # property :id,           Serial
  # property :email,        String,       :required => true, :unique => true
  # property :password,     BCryptHash,   :required => true, :length => 6..255

  # # Optional stuff
  # property :first_name,   String
  # property :last_name,    String
  # property :admin,        Boolean,      :default => false
  # property :approved,     Boolean,      :default => false

  # # System stuff
  # property :remember_token,  String
  # property :created_at,   DateTime

  # has 1, :apiToken # Changing to has_many instead of has_one

    # def generate_remember_token!
  #   self.remember_token = SecureRandom.uuid
  #   self.save

  #   return self.remember_token
  # end #generate_remember_token!

  # def invalidate_remember_token!
  #   self.remember_token = nil
  #   self.save
  # end #invalidate_remember_token!

    # def password_required?
  #   new? or dirty_attributes.has_key?(:password)
  # end