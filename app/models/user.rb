class User < ActiveRecord::Base
	validates :content, length: { maximum: 10 }
end
