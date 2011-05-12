Lovecards::Application.routes.draw do

  resources :admins do as_routes end
  resources :messages do as_routes end
  resources :senders do as_routes end
  resources :recipients do as_routes end
  resources :letters do as_routes end

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
  
  match "/" => "senders#signup", :as => :signup, :via => 'get'
  match "/" => "senders#register", :as => :sign, :via => 'post'
  match "subscribe" => "senders#subscribe", :as => :subscribe
  match "pending" => "senders#pending", :as => :pending
  match "activate" => "senders#activate", :as => :activate
  match "activated" => "senders#activated", :as => :activated
  match "deliver" => "senders#deliver", :as => :deliver
  match "delivered" => "senders#delivered", :as => :delivered
  match "unsubscribe" => "senders#unsubscribe", :as => :unsubscribe

  match "login" => "senders#login_form", :as => :login, :via => 'get'
  match "login" => "senders#login", :via => 'post'
  match "home" => "senders#home", :as => :home
  match "logout" => "senders#logout", :as => :logout
  match "resend" => "senders#resend", :as => :resend 
  
  match "notify" => "senders#notify", :as => :notify
  
  match "admin" => "admins#dashboard", :as => :admin_dashboard
  match "admin/login" => "admins#login", :as => :admin_login
  match "admin/logout" => "admins#logout", :as => :admin_logout
  match "admin/resetpass" => "admins#password_reset", :as => :admin_reset
  match "admin/resetpassdo" => "admins#password_reset_do", :as => :admin_reset_do
  match "admin/manage/admins" => "admins#manage_admins", :as => :admin_manage_admins
  
  match "howitworks" => 'senders#works', :as => :works
  match "faq" => 'senders#faq', :as => :faq
  match "tellafriend" => 'senders#taf', :as => :taf
  match "contact" => 'senders#contact', :as => :contact
  match "about" => 'senders#about', :as => :about
  
  # root :to => "senders#index"
  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller/:action/:id(.:format)'
end
