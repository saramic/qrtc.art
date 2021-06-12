class AddCodeToLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :code, :string
    add_index :locations, :code, unique: true
  end
end
