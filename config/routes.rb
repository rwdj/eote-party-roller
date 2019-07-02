Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'dice_pools#index', as: 'roller'
  get 'gm', to: 'dice_pools#gm_index', as: 'dm_roller'
  post 'roll.js', to: 'dice_pools#roll'

  mount ActionCable.server => '/cable'
end
