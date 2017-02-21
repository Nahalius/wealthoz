class Ledger < ActiveRecord::Base
  belongs_to :account
  belongs_to :group
  default_scope -> { order('created_at DESC') }
  
  validates :group_id, :wunit, :ammount,:post_date, presence: true

end
