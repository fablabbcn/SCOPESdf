class UserService
  # http://jacopretorius.net/2014/03/adding-custom-fields-to-your-devise-user-model-in-rails-4.html
  # https://stackoverflow.com/questions/3546289/override-devise-registrations-controller

  class << self

    def makeUser
      @user = User.first


      # PAGE TWO ONLY

    end

  end
end
