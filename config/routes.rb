Rails.application.routes.draw do

	as :user do 
		put '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
	end

  devise_for :users, controllers: {
  	registrations: 'registrations',
  	confirmation: 'confirmations',
  }
  root 'home#index'
end
