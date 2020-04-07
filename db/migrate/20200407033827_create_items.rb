class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string  :name,            null: false
      t.string  :details,         null: false
      t.integer :sales_status,    null: false
      t.integer :item_status,     null: false
      t.string  :brand
      t.integer :price,           null: false
      t.string :shipping_how_to
      t.integer :shipping_area,   null: false
      t.integer :shipping_cost,   null: false
      t.string  :shipping_bays,   null: false

      t.timestamps
    end
  end
end