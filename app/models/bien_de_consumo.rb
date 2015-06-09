class BienDeConsumo < ActiveRecord::Base
	belongs_to :clase
	has_many :items_stock
	has_many :depositos

	validates :nombre, presence: true, uniqueness: true	
	validates :clase, presence: true 
	validates :stock_minimo, presence: true 

	validates_length_of :codigo, :minimum => 4, :maximum => 4, :allow_blank => false	   
	validates_numericality_of :codigo, :only_integer => true, :allow_nil => true, 
    :message => "admite solo numeros."

    validates_uniqueness_of :codigo, scope: :clase_id, :message => "de Item ya existe para esa Clase"     
  	validates_uniqueness_of :nombre, scope: :clase_id, :message => "de Item ya existe para esa Clase"     
end
