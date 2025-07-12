# frozen_string_literal: true

# Model representing a user of the system
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enum para roles: 0 = admin, 1 = aluno, 2 = professor, 3 = coordenador
  enum :role, { admin: 0, aluno: 1, professor: 2, coordenador: 3 }

  # Associations
  has_many :templates, foreign_key: 'criado_por_id', dependent: :destroy
  has_many :formularios, foreign_key: 'coordenador_id', dependent: :destroy
  has_many :turmas, foreign_key: 'professor_id', dependent: :destroy
  has_many :matriculas, dependent: :destroy

  validates :name, presence: true
  validates :matricula, presence: true, uniqueness: true
  validates :role, presence: true
  
  # Validações opcionais para campos importados
  validates :curso, length: { maximum: 255 }, allow_blank: true
  validates :departamento, length: { maximum: 255 }, allow_blank: true
  validates :formacao, length: { maximum: 100 }, allow_blank: true

  before_save :downcase_email

  # Permite que apenas admins cadastrem novos usuários
  def self.can_register?(current_user = nil)
    current_user&.admin?
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
