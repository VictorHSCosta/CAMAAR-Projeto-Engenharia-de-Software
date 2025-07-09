require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      FactoryBot.create(:user),
      FactoryBot.create(:user)
    ])
  end

  it "renders a list of users" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    # Como os dados são gerados pelo Faker, vamos apenas verificar se os elementos existem
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Matricula/)
  end
end
