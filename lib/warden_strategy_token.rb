## Warden Strategy - Token
##
## Adds the Token strategy to Warden. Uses redis/AuthenticationTokens

Warden::Strategies.add(:token) do
  def valid?
    puts "Token valid?"
    # puts "Token authenticate with params:#{params}"

    if params["authToken"]
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
    # puts "Token authenticate with params:#{params}"

    if AuthenticationTokens.instance.validate_token(request, params["authToken"])
      success!(User.first(:email => 'exacttarget'))
    else
      fail!("Token Authentication Failed")
    end
  end
end