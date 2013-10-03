class CreateVehicleImages < ActiveRecord::Migration
  def change
    create_table :vehicle_images do |t|
      t.references :vehicle
      t.string :author_names
      t.string :caption
      t.string :image_type
      t.string :low_res_url
      t.string :medium_res_url
      t.string :high_res_url
    end
    add_index :vehicle_images, :vehicle_id
    add_column :vehicles, :style_id, :integer
  end
end
