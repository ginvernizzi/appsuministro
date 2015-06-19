class Clase < ActiveRecord::Base
  belongs_to :partida_parcial

  has_many :bienes_de_consumo, -> { where("bienes_de_consumo.fecha_de_baja IS NULL") }

  validates :codigo, presence: true
  validates :nombre, presence: true 

  validates :partida_parcial, presence: true 
  
  validates_length_of :codigo, :minimum => 5, :maximum => 5, :allow_blank => false
  validates_numericality_of :codigo, :only_integer => true, :allow_nil => true, 
    :message => "admite solo numeros."  

  #validates :codigo, :uniqueness => {:message => 'existente para la Partida Parcial', :scope => :partida_parcial_id, if :fecha_de_baja?}
  #validates :nombre, :uniqueness => {:message => 'existente para la Partida Parcial', :scope => :partida_parcial_id, if :fecha_de_baja?}

  #validates_uniqueness_of :codigo, scope: :partida_parcial_id, :message => "de clase ya existe para esa partida parcial", :if => :valFecha_baja?0  
  #validates_uniqueness_of :nombre, scope: :partida_parcial_id, :message => "de clase ya existe para esa partida parcial", :if => :valFecha_baja?

  validates_uniqueness_of :codigo, scope: :partida_parcial_id, :message => "de clase ya existe para esa partida parcial", conditions: -> { where('fecha_de_baja: IS NULL') }
  validates_uniqueness_of :nombre, scope: :partida_parcial_id, :message => "de clase ya existe para esa partida parcial", conditions: -> { where('fecha_de_baja: IS NULL') }


  def valFecha_baja?
      if fecha_de_baja? 
        puts "TRUEEEEEEEEEEEE"
        return true # skip the validation        
      else 
        puts "FAAAAALSEEEEEEE"
        return false # run the validation
      end
  end

  before_destroy :check_for_bienes_de_consumo

	def tiene_items_asociados
	  if self.bienes_de_consumo.count > 0 		
	   self.errors[:base] << "No se puede dar de baja el item mientras tenga elementos asociados"
	   return true
	  end
	end  
end
