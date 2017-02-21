group = Group.create(name:  'Probna'  , fx_id: 20)

user1 = User.create(name:  'Proben1'  , email: 'test@abv.bg' ,password: 12345678 , group_id: group , )
user2 = User.create(name:  'Proben2'  , email: 'proben2@abv.bg' ,password: 12345678 , group_id: group , )

project1 = Project.create(name: 'Proekt1', percent_owned: 100, group_id: group )
project2 = Project.create(name: 'Proekt2', percent_owned: 100, group_id: group )

acc1 = Account.create(name: 'Cash', group_id: group, fs_id: 1  )
acc2 = Account.create(name: 'Bank Cash', group_id: group, fs_id: 1  )
acc3 = Account.create(name: 'Car', group_id: group, fs_id: 1  )
acc4 = Account.create(name: 'Bike', group_id: group, fs_id: 1  )
acc5 = Account.create(name: 'Phone', group_id: group, fs_id: 1  )
acc6 = Account.create(name: 'Appartment', group_id: group, fs_id: 1  )
acc7 = Account.create(name: 'Investments', group_id: group, fs_id: 1  )
acc8 = Account.create(name: 'Bank Loan', group_id: group, fs_id: 2  )
acc9 = Account.create(name: 'Credit card', group_id: group, fs_id: 2  )
acc10 = Account.create(name: 'Zaem Priqteli', group_id: group, fs_id: 2  )
acc11 = Account.create(name: 'Zaplata', group_id: group, fs_id: 3  )
acc12 = Account.create(name: 'Other Income', group_id: group, fs_id: 3  )
acc13 = Account.create(name: 'Revaluation Income', group_id: group, fs_id: 3  )
acc14 = Account.create(name: 'Revaluation Expense', group_id: group, fs_id: 4  )
acc15 = Account.create(name: 'Food', group_id: group, fs_id: 4  )
acc16 = Account.create(name: 'Drehi', group_id: group, fs_id: 4  )
acc17 = Account.create(name: 'Internet and phone', group_id: group, fs_id: 4  )
acc18 = Account.create(name: 'Fuel', group_id: group, fs_id: 4  )
acc19 = Account.create(name: 'Other Expenses', group_id: group, fs_id: 4  )

tr1 = Ledger.create(group_id: group, account_id: acc1, post_date: Date.new(2014, 1, 1), ammount: 1000, text: 'Opening Balance')
tr2 = Ledger.create(group_id: group, account_id: acc2, post_date: Date.new(2014, 1, 1), ammount: 3000, text: 'Opening Balance')
tr3 = Ledger.create(group_id: group, account_id: acc3, post_date: Date.new(2014, 1, 1), ammount: 13000, text: 'Opening Balance')
tr4 = Ledger.create(group_id: group, account_id: acc4, post_date: Date.new(2014, 1, 1), ammount: 1000, text: 'Opening Balance')
tr5 = Ledger.create(group_id: group, account_id: acc5, post_date: Date.new(2014, 1, 1), ammount: 800, text: 'Opening Balance')
tr6 = Ledger.create(group_id: group, account_id: acc6, post_date: Date.new(2014, 1, 1), ammount: 100000, text: 'Opening Balance')
tr7 = Ledger.create(group_id: group, account_id: acc7, post_date: Date.new(2014, 1, 1), ammount: 5000, text: 'Opening Balance')
tr8 = Ledger.create(group_id: group, account_id: acc8, post_date: Date.new(2014, 1, 1), ammount: -93000, text: 'Opening Balance')
tr9 = Ledger.create(group_id: group, account_id: acc9, post_date: Date.new(2014, 1, 1), ammount: -4000, text: 'Opening Balance')
tr10 = Ledger.create(group_id: group, account_id: acc10, post_date: Date.new(2014, 1, 1), ammount: -1000, text: 'Opening Balance')


tr11 = Ledger.create(group_id: group, account_id: acc11, post_date: Date.new(2014, 1, 5), ammount: 1000, text: 'Sample')
tr12 = Ledger.create(group_id: group, account_id: acc11, post_date: Date.new(2014, 2, 5), ammount: 1000, text: 'Sample')
tr13 = Ledger.create(group_id: group, account_id: acc11, post_date: Date.new(2014, 3, 5), ammount: 1000, text: 'Sample')
tr14 = Ledger.create(group_id: group, account_id: acc11, post_date: Date.new(2014, 4, 5), ammount: 1000, text: 'Sample')
tr15 = Ledger.create(group_id: group, account_id: acc11, post_date: Date.new(2014, 5, 5), ammount: 1200, text: 'Sample')
tr16 = Ledger.create(group_id: group, account_id: acc11, post_date: Date.new(2014, 6, 5), ammount: 1000, text: 'Sample')

tr10 = Ledger.create(group_id: group, account_id: acc15, post_date: Date.new(2014, 1, 5), ammount: -500, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc15, post_date: Date.new(2014, 2, 5), ammount: -600, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc15, post_date: Date.new(2014, 3, 5), ammount: -300, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc15, post_date: Date.new(2014, 4, 5), ammount: -400, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc15, post_date: Date.new(2014, 5, 5), ammount: -300, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc15, post_date: Date.new(2014, 6, 5), ammount: -500, text: 'Sample')

tr10 = Ledger.create(group_id: group, account_id: acc16, post_date: Date.new(2014, 1, 5), ammount: -100, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc16, post_date: Date.new(2014, 2, 5), ammount: -100, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc16, post_date: Date.new(2014, 3, 5), ammount: -200, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc16, post_date: Date.new(2014, 4, 5), ammount: -140, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc16, post_date: Date.new(2014, 5, 5), ammount: -130, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc16, post_date: Date.new(2014, 6, 5), ammount: -300, text: 'Sample')

tr10 = Ledger.create(group_id: group, account_id: acc18, post_date: Date.new(2014, 1, 5), ammount: -100, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc18, post_date: Date.new(2014, 2, 5), ammount: -200, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc18, post_date: Date.new(2014, 3, 5), ammount: -100, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc18, post_date: Date.new(2014, 4, 5), ammount: -200, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc18, post_date: Date.new(2014, 5, 5), ammount: -120, text: 'Sample')
tr10 = Ledger.create(group_id: group, account_id: acc18, post_date: Date.new(2014, 6, 5), ammount: -300, text: 'Sample')














