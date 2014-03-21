module AuthenticationHelpers
  def login_admin
    login_user
    before(:each) do
      current_user.admin = true
      current_user.save!
    end
  end

  def login_user
    let(:current_user){FactoryGirl.create(:user)}
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in current_user
    end
  end
end