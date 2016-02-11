class IngresoManualAStock < ActiveRecord::Base
	has_many :items_stock

	accepts_nested_attributes_for :items_stock,
                                reject_if: proc { |attributes| attributes['bien_id'].blank? },
                                allow_destroy: true
end
