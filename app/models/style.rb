class Style < ActiveRecord::Base
  belongs_to :vehicle
  has_many :vehicle_images
end
