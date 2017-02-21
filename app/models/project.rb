class Project < ActiveRecord::Base
  
  belongs_to :group
  default_scope -> { order('name DESC') }
  validates :name, presence: true,                    
                   length: { maximum: 25 }             
  
  validates :group_id, presence: true
end
