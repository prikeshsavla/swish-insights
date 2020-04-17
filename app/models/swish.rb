class Swish < ApplicationRecord
  belongs_to :user
  has_many :swish_reports, dependent: :destroy

end
