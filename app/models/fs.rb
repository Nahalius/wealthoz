class Fs < ActiveRecord::Base
  belongs_to :group
  has_many :accounts
end
