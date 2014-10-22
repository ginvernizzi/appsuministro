class BienDeConsumo < ActiveRecord::Base
	validates :nombre, presence: true
	validates :codigo, presence: true
end
