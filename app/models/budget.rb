class Budget < ActiveRecord::Base
  belongs_to :account
  belongs_to :group
  default_scope -> { order('created_at DESC') }

  validates :group_id, :wunit, :ammount, presence: true

end
