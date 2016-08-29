class PagesSerializer < ActiveModel::Serializer
  attributes :id, :name, :settings, :layout, :is_deleted
end
