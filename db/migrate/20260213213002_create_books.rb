class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :serial_number
      t.string :title
      t.string :author

      t.timestamps
    end
    add_index :books, :serial_number, unique: true
  end
end
