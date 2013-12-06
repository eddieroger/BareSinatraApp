## Warden Strategy - Password
##
## Adds the Password strategy to Warden. Uses the User model.

Warden::Strategies.add(:password) do
  def valid?
    puts "Password valid?"
    # puts "Password authenticate with params:#{params}"

    if params["email"] && params["password"]
      puts "YES!"
      return true
    else
      puts "NO!"
      return false
    end
  end

  def authenticate!
    # user = Datastore.for(:user).find_by_email(params["email"])
    # if user && user.authenticate(params["password"])
    #   success!(user)
    # puts "Password authenticate with params:#{params}"

    user = User.authenticate(params['email'], params['password'], params['remember_me'])
    if user
      success!(user)
    else
      fail!("Password Authentication Failed")
    end
  end
end