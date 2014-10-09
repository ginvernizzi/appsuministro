class User < ActiveRecord::Base
	validates :content, length: { maximum: 50 }
end
