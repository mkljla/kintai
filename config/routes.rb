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


  resources :users, only: [:index, :show, :new, :create, :destroy, :edit, :update] do
    collection do
      get 'home', to: 'users#home', as: 'home'
    end

    resources :works, only: [:index, :show, :create, :update]
    resources :breaks, only: [:index, :show, :create, :update]

  end


  post 'toggle_admin_mode', to: 'admin#toggle_admin_mode'



  # namespace :admin do
  #   root to: 'users#index'
  #   # ユーザー管理
  #   resources :users, only: [:index, :show, :edit, :update, :new, :create, :destroy] do
  #     # ユーザーの勤務履歴関連
  #     resources :works, only: [:index, :edit, :update]
  #   end
  # end


  # # 勤怠管理DB作成処理
  # resources :works, only: [:show, :new, :create, :destroy, :edit, :update]

  # # 勤怠管理DB作成処理
  # resources :breaks, only: [:show, :new, :create, :destroy, :edit, :update]

  # ルートページをログイン画面に設定
  root 'sessions#new'
end
