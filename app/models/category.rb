class Category < ApplicationRecord

has_many :swish_categories, dependent: :destroy

end
