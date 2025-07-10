require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "secret123",
      name: "Test User",
      matricula: "123456",
      role: 1
    )
  end

  before(:each) do
    assign(:user, user)
    allow(view).to receive(:current_user).and_return(user)
    allow(view).to receive(:user_signed_in?).and_return(true)
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(user), "post" do
      assert_select "input[name=?]", "user[email]"

      assert_select "input[name=?]", "user[password]"

      assert_select "input[name=?]", "user[name]"

      assert_select "input[name=?]", "user[matricula]"

      assert_select "input[name=?]", "user[role]"
    end
  end
end
