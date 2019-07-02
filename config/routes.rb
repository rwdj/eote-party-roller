Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'dice_pools#roller', as: 'roller'
  post 'roll.js', to: 'dice_pools#roll'

  mount ActionCable.server => '/cable'
end
