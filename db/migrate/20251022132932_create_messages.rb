class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.string :username

      t.timestamps
    end
  end
end
