Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :restaurants do
        collection do
          post 'import'
          match 'import', to: 'restaurants#import_options', via: :options
        end
        resources :menus do
          resources :menu_items
        end
      end
    end
  end
end
