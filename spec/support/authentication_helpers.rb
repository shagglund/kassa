module AuthenticationHelpers
  def login_admin
    before(:each) do
      login_user
      current_user.admin = true
      current_user.save!
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      sign_in user
    end
  end
end