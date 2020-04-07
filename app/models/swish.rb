class Swish < ApplicationRecord
  belongs_to :user
  has_many :swish_categories, dependent: :destroy
end
