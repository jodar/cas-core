Cas::Engine.routes.draw do
  devise_for :users,
    class_name: "Cas::User",
    module: :devise,
    controllers: { sessions: "cas/devise/sessions" },
    skip: :registrations

  resources :sections, only: [:index] do
    resources :contents, controller: 'sections/contents'
  end
  root 'sections#index'
end
