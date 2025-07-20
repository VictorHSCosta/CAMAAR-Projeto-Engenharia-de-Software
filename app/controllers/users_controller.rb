# frozen_string_literal: true

# Adicione um comentário de documentação para a classe UsersController.
class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  before_action :ensure_admin!, except: %i[edit update]

  # GET /users or /users.json
  def index
    @users = User.order(:name)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    # Permite que usuários editem apenas seu próprio perfil, ou admins editem qualquer um
    return if current_user.admin? || @user == current_user

    redirect_to root_path, alert: I18n.t('messages.access_denied')
  end

  # POST /users or /users.json
  def create
    @user = build_user_with_password
    save_user_and_respond
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    clean_password_params_if_blank
    update_user_and_respond
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: I18n.t('messages.user_destroyed') }
      format.json { head :no_content }
    end
  end

  # POST /users/adicionar_disciplina_aluno
  def adicionar_disciplina_aluno
    return redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?

    @user = User.find(params[:user_id])
    @turma = Turma.find(params[:turma_id])

    # Verificar se o aluno já está matriculado nesta turma
    if @user.matriculas.exists?(turma_id: @turma.id)
      redirect_to edit_user_path(@user), alert: 'Este aluno já está matriculado nesta turma.'
      return
    end

    @matricula = @user.matriculas.create!(turma: @turma)

    redirect_to edit_user_path(@user),
                notice: "Aluno matriculado na disciplina #{@turma.disciplina.nome} - #{@turma.semestre}."
  end

  # DELETE /users/remover_disciplina_aluno
  def remover_disciplina_aluno
    return redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?

    @matricula = Matricula.find(params[:matricula_id])
    @user = @matricula.user
    disciplina_nome = @matricula.turma.disciplina.nome
    semestre = @matricula.turma.semestre

    @matricula.destroy!

    redirect_to edit_user_path(@user),
                notice: "Matrícula removida da disciplina #{disciplina_nome} - #{semestre}."
  end

  # POST /users/adicionar_disciplina_professor
  def adicionar_disciplina_professor
    return redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?

    @user = User.find(params[:user_id])
    @disciplina = Disciplina.find(params[:disciplina_id])
    semestre = params[:semestre]

    # Verificar se já existe uma turma para este professor nesta disciplina no semestre
    if @disciplina.turmas.exists?(professor_id: @user.id, semestre: semestre)
      redirect_to edit_user_path(@user), alert: 'Este professor já leciona esta disciplina neste semestre.'
      return
    end

    @turma = @disciplina.turmas.create!(
      professor: @user,
      semestre: semestre
    )

    redirect_to edit_user_path(@user),
                notice: "Professor adicionado à disciplina #{@disciplina.nome} - #{semestre}."
  end

  # DELETE /users/remover_disciplina_professor
  def remover_disciplina_professor
    return redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?

    @turma = Turma.find(params[:turma_id])
    @user = @turma.professor
    disciplina_nome = @turma.disciplina.nome
    semestre = @turma.semestre

    @turma.destroy!

    redirect_to edit_user_path(@user),
                notice: "Professor removido da disciplina #{disciplina_nome} - #{semestre}."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def build_user_with_password
    user = User.new(user_params)
    user.password = generate_temp_password if user.password.blank?
    user
  end

  def save_user_and_respond
    respond_to do |format|
      if @user.save
        format.html do
          redirect_to users_path, notice: "Usuário criado com sucesso! Senha temporária: #{@user.password}"
        end
        format.json { render json: @user, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def clean_password_params_if_blank
    return if user_params[:password].present?

    params[:user].delete(:password)
    params[:user].delete(:password_confirmation)
  end

  def update_user_and_respond
    respond_to do |format|
      if @user.update(user_params.except(:password, :password_confirmation).compact)
        format.html { redirect_to users_path, notice: I18n.t('messages.user_updated') }
        format.json { render json: @user, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Gera senha temporária
  def generate_temp_password
    SecureRandom.hex(4)
  end

  # Only allow a list of trusted parameters through.
  def user_params
    if current_user&.admin?
      # Administradores podem editar todos os campos incluindo role e curso
      params.expect(user: %i[email password password_confirmation name matricula role curso])
    else
      # Usuários normais não podem editar role, mas podem editar curso
      params.expect(user: %i[email password password_confirmation name matricula curso])
    end
  end
end
