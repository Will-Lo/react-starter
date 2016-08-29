class Student < ActiveRecord::Base
	validates :name, length: { minimum: 1, maximum: 100 }
end
