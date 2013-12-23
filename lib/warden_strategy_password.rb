## Warden Strategy - Password
##
## Adds the Password strategy to Warden. Uses the User model.

Warden::Strategies.add(:password) do
  def valid?
    puts "Password valid?"
    # puts "Password authenticate with params: #{params}"

    if params["username"] && params["password"]
      # puts "YES!"
      return true
    else
      # puts "NO!"
      return false
    end
  end

  def authenticate!
    puts "Params: #{params}"
    user = User.find_by(username: params["username"]).try(:authenticate, params["password"])
    # user = User.authenticate(params["username"], params["password"], false)
    puts "User: #{user}"
    if user
      puts "YES"
      success!(user)
    else
      puts "NO"
      fail!("Password Authentication Failed")
    end
  end
end