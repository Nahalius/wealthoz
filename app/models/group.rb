class Group < ActiveRecord::Base
  belongs_to :fx
  has_one  :fs
  has_many :group_users
  has_many :users, through: :group_users
  has_many :projects, dependent: :destroy
  has_many :accounts
  has_many :ledgers
  has_many :budgets

  validates :name, presence: true,
                   length: { maximum: 25 },
                   uniqueness: { case_sensitive: false }

  default_scope -> { order('name DESC') }

  after_create :create_default_accounts

  def to_s
    name
  end


  def create_default_accounts
    default_accounts = [
      {name: 'Property',  fs_id: 1},
      {name: 'Vehicles',  fs_id: 1},
      {name: 'Furniture',  fs_id: 1},
      {name: 'Electronics',  fs_id: 1},
      {name: 'Loans granted',  fs_id: 1},
      {name: 'Investments in companies',  fs_id: 1},
      {name: 'Receivables',  fs_id: 1},
      {name: 'Savings account',  fs_id: 1},
      {name: 'Cash ',  fs_id: 1},
      {name: 'Cash - bank',  fs_id: 1},
      {name: 'Payables',  fs_id: 2},
      {name: 'Loans received',  fs_id: 2},
      {name: 'Bank loans',  fs_id: 2},
      {name: 'Credit cards',  fs_id: 2},
      {name: 'Salary/wage',  fs_id: 3},
      {name: 'Interest income',  fs_id: 3},
      {name: 'Rent income',  fs_id: 3},
      {name: 'Income from sold assets',  fs_id: 3},
      {name: 'Other income',  fs_id: 3},
      {name: 'Revaluation account income',  fs_id: 3},
      {name: 'Food expense',  fs_id: 4},
      {name: 'Clothing expense',  fs_id: 4},
      {name: 'Education expense',  fs_id: 4},
      {name: 'Parking expenses',  fs_id: 4},
      {name: 'Healthcare expenses',  fs_id: 4},
      {name: 'Repairs',  fs_id: 4},
      {name: 'Fuel expense',  fs_id: 4},
      {name: 'Transport expenses',  fs_id: 4},
      {name: 'Revaluation account expense',  fs_id: 4},
      {name: 'Entertainment Expenses',  fs_id: 4},
      {name: 'Phone, internet, cable TV expense',  fs_id: 4},
      {name: 'Electricity expense',  fs_id: 4},
      {name: 'Water expense',  fs_id: 4},
      {name: 'Heating expense',  fs_id: 4},
      {name: 'Cosmetics expenses',  fs_id: 4},
      {name: 'Home expenses',  fs_id: 4},
      {name: 'Social security expenses',  fs_id: 4},
      {name: 'Book value of sold assets',  fs_id: 4},
      {name: 'Interest expense',  fs_id: 4},
      {name: 'Other expenses and fees',  fs_id: 4},
      {name: 'Taxes',  fs_id: 4},
      {name: 'Retained Earnings',  fs_id: 5}
    ]

    ActiveRecord::Base.transaction { self.accounts.create(default_accounts) }
  end

end
