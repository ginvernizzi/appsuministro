class BienDeConsumo < ActiveRecord::Base
	validates :nombre, presence: true
	validates :codigo, presence: true

	has_many :items_stock
	has_many :depositos
end
