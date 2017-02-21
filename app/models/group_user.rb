class GroupUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  enum status: [ :pending, :approved, :declined ]

end
