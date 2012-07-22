Sellerauction::Application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :users, ActiveAdmin::Devise.config.merge(:controllers=>
    {:sessions=>"active_admin/devise/sessions",
     :passwords=>"active_admin/devise/passwords",
     :registrations=>"active_admin/devise/registrations"}
  )
end
