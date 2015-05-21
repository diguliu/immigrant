class Localship < ActiveRecord::Base
  validates :name, :phasers, presence: true
end
