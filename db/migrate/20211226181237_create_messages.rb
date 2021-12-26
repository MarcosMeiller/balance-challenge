class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.boolean :is_balanced, default: false
      t.timestamps
    end
  end
end
