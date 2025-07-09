require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    assign(:user, User.create!(
      email: "Email",
      password: "secret123",
      name: "Name",
      matricula: "Matricula",
      role: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Matricula/)
    expect(rendered).to match(/2/)
  end
end
