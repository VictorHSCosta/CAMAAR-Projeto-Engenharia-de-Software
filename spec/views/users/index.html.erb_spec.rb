require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    admin_user = FactoryBot.create(:user, role: 0)
    assign(:users, [
             FactoryBot.create(:user),
             FactoryBot.create(:user)
           ])
    allow(view).to receive(:current_user).and_return(admin_user)
    allow(view).to receive(:user_signed_in?).and_return(true)
  end

  it "renders a list of users" do
    render
    # Verifica se a página contém elementos de usuários
    expect(rendered).to match(/E-mail/)
    expect(rendered).to match(/Nome/)
    expect(rendered).to match(/Matrícula/)
    expect(rendered).to match(/Tipo/)
  end
end
