## Warden Strategy - Rememberable
##
## Allows a user to opt to be remembered. Isn't that sweet?
## Inspired by http://stackoverflow.com/questions/4461984/remember-me-with-warden

Warden::Strategies.add(:cookie) do
  def valid?
    # puts "Remember Me?"

    if env['rack.cookies']['user.remember.token']
      # puts "YES"
      return true
    else
      # puts "NO"
      return false
    end # if
  end # valid?

  def authenticate!
    if 1
      success! user
    else
      fail! "Remember Me token authentication failed"
    end
  end #authenticate!
end #Warden::Strategies.add

Warden::Manager.after_authentication :scope => :user do |user, auth, opts|
  auth.env['rack.cookies']['user.remember.token'] = user.generate_remember_token!
end

Warden::Manager.before_logout :scope => :user do |user, auth, opts|
  user.invalidate_remember_token!
end