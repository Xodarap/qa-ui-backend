class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.belongs_to :question, foreign_key: { to_table: :texts }
      t.belongs_to :answer, foreign_key: { to_table: :texts }
      t.belongs_to :parent, foreign_key: { to_table: :questions }, on_delete: :cascade

      t.timestamps
    end
  end
end
