class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.text :question
      t.text :answer
      t.belongs_to :parent, foreign_key: { to_table: :questions }

      t.timestamps
    end
  end
end
