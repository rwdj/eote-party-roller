Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'roller', to: 'dice_pools#roller'
  post 'roller', to: 'dice_pools#roll'
  get 'rolls', to: 'dice_pools#index'

  mount ActionCable.server => '/cable'
end
