WealthOZ201::Application.routes.draw do

  resources :budgets

  resources :ledgers do
    collection do
      get :report_balance
      get :report_plm
      get :report_plwu
      get :report_kpi

    end
  end

  resources :cut_off_wealths

  resources :future_reports, only: [:index] do
    collection do
      get :future_balance
      get :actual_budget
    end
  end

  resources :transparents, only: []  do
  collection do
      get :report_balance
      get :report_plm
      get :report_plwu
      get :report_kpi
      get :report_story
    end
  end
  match '/transparent',   to: 'transparents#report',   via: 'get'

  match '/report',   to: 'ledgers#report',   via: 'get'
  match '/wealthoz',   to: 'ledgers#wealthoz',   via: 'get'
  match '/wealth_index',   to: 'ledgers#wealth_index',   via: 'get'
  resources :fxes
  resource :group do
    resources :group_users, controller: 'groups/group_users', only: [:index] do
      member do
        get :approved
      end
    end
  end


  #resources :users
  resources :users do
    member do
      get :following, :followers
    end

  end
  resource :group_user

  resources :relationships, only: [:create, :destroy]

  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :projects
  resources :accounts do
    collection do
      get :check
    end
  end

  root  'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  match '/signup',  to: 'users#new',            via: 'get'
  match '/why',    to: 'static_pages#why',    via: 'get'
  match '/how',   to: 'static_pages#how',   via: 'get'
  match '/manage_groups',   to: 'static_pages#manage_groups',   via: 'get'

  match '/donate',   to: 'static_pages#donate',   via: 'get'

  match '/book',   to: 'static_pages#book',   via: 'get'
  match '/a2',   to: 'static_pages#a2',   via: 'get'
  match '/a3',   to: 'static_pages#a3',   via: 'get'


  match '/b1',   to: 'static_pages#b1',   via: 'get'
  match '/d1',   to: 'static_pages#d1',   via: 'get'
  match '/d2',   to: 'static_pages#d2',   via: 'get'

  match '/d4',   to: 'static_pages#d4',   via: 'get'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
