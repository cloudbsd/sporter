class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :code, index: true
      t.integer :province_code, index: true

      t.timestamps
    end
  end
end
