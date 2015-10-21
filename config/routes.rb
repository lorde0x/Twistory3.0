Rails.application.routes.draw do
	get 'home/index' => 'feeds#home'
	root to: 'feeds#home'
	resources :feeds
	resources :users, path: '/portal'
	resources :portals, path: '/#portal'
	
	devise_for :admins
	
	devise_scope :admin do
		authenticated :admin do
			get 'admins/sign_out' => 'devise/sessions#destroy'
		end

		unauthenticated do
			get 'admins/sign_in' => 'devise/sessions#new'
		end
	end
	
	devise_for :users
	
	devise_scope :user do
		authenticated :user do
			get '/users' => 'devise/registrations#edit'
			get 'users/sign_out' => 'devise/sessions#destroy'
			root to: 'feeds#index', as: :authenticated_root
		end
		unauthenticated do
			get 'users/sign_in' => 'devise/sessions#new'
			get '/users' => 'devise/registrations#new'
			root to: 'feeds#home', as: :unauthenticated_root
		end
	end
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
