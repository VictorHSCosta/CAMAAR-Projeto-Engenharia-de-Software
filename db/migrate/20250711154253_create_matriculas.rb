# frozen_string_literal: true

class CreateMatriculas < ActiveRecord::Migration[8.0]
  def change
    create_table :matriculas do |t|
      t.references :user, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
  end
end
