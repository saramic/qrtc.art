class CreateLocationsAndVisits < ActiveRecord::Migration[6.1]
  def change
    create_table :locations, id: :uuid do |t|
      t.string :name
      t.string :address
      t.decimal :latitude, precision: 10, scale: 6, default: 0
      t.decimal :longitude, precision: 10, scale: 6, default: 0
      t.column :status, :integer, default: 0

      t.timestamps
    end

    create_table :visits, id: :uuid do |t|
      t.belongs_to :location, foreign_key: true, null: false, type: :uuid, index: true
      t.jsonb :meta_data, null: false, default: {}

      t.datetime :created_at, null: false
    end
  end
end
