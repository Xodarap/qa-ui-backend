class CreateTexts < ActiveRecord::Migration[5.1]
  def change
    create_table :texts do |t|
    	t.string :type
      t.string :body
      t.boolean :expanded, default: false
      t.belongs_to :parent, foreign_key: { to_table: :texts }

      t.timestamps
    end
  end
end
