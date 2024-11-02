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

  # 社員用ホーム画面
  get 'user/home', to: 'users#home', as: 'user_home'
  get 'user/:id', to: 'users#show', as: 'user_show'


  # 管理者用ホーム画面
  get 'admin/home', to: 'admins#home', as: 'admin_home'
  # 管理者用ユーザー詳細画面
  get 'admin/users/:id', to: 'admins#show_user', as: 'admin_user_show'

  # 勤怠管理DB作成処理
  post 'works/check_in', to: 'works#check_in'
  post 'works/check_out', to: 'works#check_out'

  # 勤怠管理DB作成処理
  post 'breaks/start_break', to: 'breaks#start_break'
  post 'breaks/end_break', to: 'breaks#end_break'

  # ルートページをログイン画面に設定
  root 'sessions#new'
end
