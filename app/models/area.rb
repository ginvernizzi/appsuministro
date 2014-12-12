class Area < ActiveRecord::Base
	has_many :depositos

	validates :nombre, presence: true
	validates :responsable, presence: true
end
