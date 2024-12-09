Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # to (コントローラー名)(実行するアクション)


  # ログイン画面
  get 'login', to: 'sessions#new'          # ログインフォームを表示
  post 'login', to: 'sessions#create'      # ログイン処理
  delete 'logout', to: 'sessions#destroy'  # ログアウト処理


  resources :users, only: [:show] do
    collection do
      get 'home', to: 'users#home', as: 'home'
    end

    resources :works, only: [:index, :show, :create, :update]
    resources :breaks, only: [:index, :show, :create, :update]

  end

  # 管理者専用の操作
  namespace :admin do
    resources :users, only: [:index, :new, :create, :destroy, :edit, :update]
  end

  post 'reset_demo_data', to: 'application#reset_demo_data'

  # 管理者モードの切り替え
  post 'toggle_admin_mode', to: 'admin#toggle_admin_mode'

  # ルートページをログイン画面に設定
  root 'sessions#new'
end
