# frozen_string_literal: true

# Adicione um comentário de documentação para a classe DisciplinasController.
class DisciplinasController < ApplicationController
  before_action :set_disciplina, only: %i[edit update destroy]

  # GET /disciplinas or /disciplinas.json
  def index
    @disciplinas = Disciplina.all
  end

  # GET /disciplinas/1 or /disciplinas/1.json
  def show; end

  # GET /disciplinas/new
  def new
    @disciplina = Disciplina.new
  end

  # GET /disciplinas/1/edit
  def edit; end

  # POST /disciplinas or /disciplinas.json
  def create
    @disciplina = Disciplina.new(disciplina_params)

    respond_to do |format|
      if @disciplina.save
        format.html { redirect_to disciplinas_url, notice: 'Disciplina criada com sucesso!' }
        format.json { render :show, status: :created, location: @disciplina }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @disciplina.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /disciplinas/1 or /disciplinas/1.json
  def update
    respond_to do |format|
      if @disciplina.update(disciplina_params)
        format.html { redirect_to disciplina_url(@disciplina), notice: 'Disciplina atualizada com sucesso!' }
        format.json { render :show, status: :ok, location: @disciplina }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @disciplina.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disciplinas/1 or /disciplinas/1.json
  def destroy
    @disciplina.destroy!

    respond_to do |format|
      format.html { redirect_to disciplinas_url, status: :see_other, notice: 'Disciplina removida com sucesso!' }
      format.json { head :no_content }
    end
  end

  # GET /disciplinas/:id/turmas - AJAX endpoint para buscar turmas de uma disciplina
  def turmas
    @disciplina = Disciplina.find(params[:id])
    @turmas = @disciplina.turmas.includes(:professor)

    respond_to do |format|
      format.json do
        render json: @turmas.map { |turma|
          {
            id: turma.id,
            semestre: turma.semestre,
            professor_nome: turma.professor.name
          }
        }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_disciplina
    @disciplina = Disciplina.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def disciplina_params
    params.require(:disciplina).permit(:nome, :curso_id)
  end
end
