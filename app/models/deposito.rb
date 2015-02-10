class Deposito < ActiveRecord::Base
  belongs_to :area
  has_many :items_stock

  validates :nombre, presence: true
end
