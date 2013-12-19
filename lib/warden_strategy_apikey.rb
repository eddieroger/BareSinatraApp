## Warden Strategy - Token
##
## Adds the Token strategy to Warden. Uses redis/AuthenticationTokens

Warden::Strategies.add(:api) do
  def valid?

    if params["accessToken"]
      return true
    else
      return false
    end
  end

  def authenticate!
    # user = Datastore.for(:user).find_by_email(params["email"])
    # if user && user.authenticate(params["password"])
    #   success!(user)
    # puts "Token authenticate with params:#{params}"

    if ApiToken.authenticate(params["accessToken"])
      success!(User.new)
    else
      fail!("Token Authentication Failed")
    end
  end
end