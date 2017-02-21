class Account < ActiveRecord::Base

  belongs_to :group
  belongs_to :fs
  has_many :ledgers
  has_many :budgets
  validates :name, presence: true,
                   length: { maximum: 35 }

 default_scope -> { order('name DESC') }

  def self.to_csv(options = {})
  CSV.generate(options) do |csv|
    csv << column_names
    all.each do |account|
      csv << account.attributes.values_at(*column_names)
    end
  end
 end
end
