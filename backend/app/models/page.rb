class Page < ActiveRecord::Base
	has_many :page_roles
	has_many :roles, :through => :page_roles
	validates :name, length: { minimum: 1, maximum: 100 }
	validates :settings, length: { minimum: 1 }
	validates :layout, length: { minimum: 1 }
end
