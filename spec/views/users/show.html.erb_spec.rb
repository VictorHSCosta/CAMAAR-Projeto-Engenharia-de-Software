require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    assign(:user, User.create!(
      email: "Email",
      password_digest: "Password Digest",
      name: "Name",
      matricula: "Matricula",
      role: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Password Digest/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Matricula/)
    expect(rendered).to match(/2/)
  end
end
