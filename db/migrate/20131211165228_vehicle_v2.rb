class VehicleV2 < ActiveRecord::Migration
  def up
    VehicleImage.delete_all
    Vehicle.delete_all
    add_column :vehicles, :driven_wheels, :string
    add_column :vehicles, :manufacturer, :string
    add_column :vehicles, :highway_mpg, :string
    add_column :vehicles, :city_mpg, :string
    add_column :vehicles, :category_epa, :string
    add_column :vehicles, :category_primary_body_type, :string
    add_column :vehicles, :category_vehicle_style, :string
    add_column :vehicles, :category_vehicle_type, :string

    remove_column :vehicles, :year
    remove_column :vehicles, :style_id
    remove_column :vehicles, :trim
    remove_column :vehicles, :name

    remove_column :vehicle_images, :vehicle_id
    add_column :vehicle_images, :style_id, :integer
    
    create_table :options do |t|
      t.string :category
      t.string :edmunds_id
      t.string :name
      t.string :description
      t.string :availability
      t.string :equipment_type
    end

    create_table :colors do |t|
      t.string :category
      t.string :edmunds_id
      t.string :name
      t.string :availability
      t.string :equipment_type
    end

    create_join_table :colors, :vehicles do |t|
      t.index [:color_id, :vehicle_id]
      t.index [:vehicle_id, :color_id]
    end

    create_join_table :options, :vehicles do |t|
      t.index [:option_id, :vehicle_id]
      t.index [:vehicle_id, :option_id]
    end

    create_table :styles do |t|
      t.references :vehicle
      t.string :edmunds_id
      t.string :name
      t.string :body
      t.string :model
      t.string :trim
      t.integer :year
    end
    
  end
 
  def down
    remove_column :vehicles, :driven_wheels
    remove_column :vehicles, :manufacturer
    remove_column :vehicles, :highway_mpg
    remove_column :vehicles, :city_mpg
    remove_column :vehicles, :category_epa
    remove_column :vehicles, :category_primary_body_type
    remove_column :vehicles, :category_vehicle_style
    remove_column :vehicles, :category_vehicle_type

    add_column :vehicles, :year, :integer
    add_column :vehicles, :style_id, :string
    add_column :vehicles, :trim, :string
    add_column :vehicles, :name, :string

    add_column :vehicle_images, :vehicle_id, :integer
    remove_column :vehicle_images, :style_id

    drop_table :styles
    drop_join_table :options, :vehicles
    drop_join_table :colors, :vehicles
    drop_table :colors
    drop_table :options
  end
end
