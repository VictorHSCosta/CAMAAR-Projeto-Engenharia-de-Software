# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password',
        matricula: '12345',
        role: 'admin'
      )
      expect(user).to be_valid
    end

    it 'is invalid without a name' do
      user = User.new(email: 'test@example.com', password: 'password', matricula: '12345')
      expect(user).not_to be_valid
    end

    it 'is invalid without an email' do
      user = User.new(name: 'Test User', password: 'password', matricula: '12345')
      expect(user).not_to be_valid
    end

    it 'is invalid with duplicate email' do
      User.create!(name: 'User 1', email: 'test@example.com', password: 'password', matricula: '12345', role: 'admin')
      user = User.new(name: 'User 2', email: 'test@example.com', password: 'password', matricula: '67890', role: 'professor')
      expect(user).not_to be_valid
    end
  end

  describe 'enums' do
    it 'defines correct roles' do
      expect(User.roles.keys).to include('admin', 'professor', 'coordenador')
    end
  end

  describe 'associations' do
    let(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'password', matricula: '12345', role: 'admin') }

    it 'can have many created templates' do
      template = Template.create!(titulo: 'Test Template', publico_alvo: 1, criado_por: user)
      expect(user.templates.count).to eq(1)
      expect(user.templates.first).to eq(template)
    end
  end
end
