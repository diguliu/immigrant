class Native < ActiveRecord::Base
  validates :name, :document, presence: true
end
