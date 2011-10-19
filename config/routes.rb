Lovecards::Application.routes.draw do

  root :to => "home#index"

  resources :senders, :only => [ :edit, :update, :show, :destroy ]
  resources :recipients 
  resources :letters

  # resources :messages 
  # Invites
  match '/invite' => 'invitations#invite', :as => :invite
  match '/thanks_to' => 'invitations#invited', :as => :invited
  match '/thanks_to/:name' => 'invitations#invited', :as => :invited_by

  # Oauth
  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/sign_in/:provider' => 'sessions#new', :as => :signin

  match '/locale/:lang' => 'sessions#locale', :as => :locale

  match 'newmail' => 'senders#newmail', :as => :new_mail
  match 'savemail' => 'senders#savemail', :as => :savemail
  
  # match "signup" => "senders#signup", :as => :signup, :via => 'get'
  match "signup" => "senders#register", :as => :signup
  
  match "subscribe" => "senders#subscribe", :as => :subscribe
  match "pending" => "senders#pending", :as => :pending
  match "activate" => "senders#activate", :as => :activate
  match "activated" => "senders#activated", :as => :activated
  match "deliver" => "senders#deliver", :as => :deliver
  match "delivered" => "senders#delivered", :as => :delivered
  match "unsubscribe" => "senders#unsubscribe", :as => :unsubscribe
  match "panic" => "senders#panic", :as => :panic
  match "/promote_on/:provider" => "senders#promote_on", :as => :promote_on
  match "promote" => "senders#promote", :as => :promote
  match "/activate/:feature" => "senders#activate_feature", :as => :activate_feature
  match "/deactivate/:feature" => "senders#deactivate_feature", :as => :deactivate_feature

  match "resend" => "senders#resend", :as => :resend 
  match "notify" => "senders#notify", :as => :notify

  match "howitworks" => 'home#works', :as => :works
  match "faq" => 'home#faq', :as => :faq
  match "tellafriend" => 'home#taf', :as => :taf
  match "contact" => 'home#contact', :as => :contact
  match "about" => 'home#about', :as => :about
  
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller/:action/:id(.:format)'
end
