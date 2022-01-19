Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace 'api' do
    scope '/apps' do
      get "get", to: "apps#getApps"
      get "find/:access_token", to: "apps#getAppById"
      post "create", to: "apps#createApp"
      put "update/:access_token", to: "apps#updateApp"
      # resources :apps

      scope '/:access_token/chats' do
        get "get", to: "chats#getChats"
        get "find/:number", to: "chats#getChatById"
        post "create", to: "chats#createChat"

        scope '/:chat_number/messages' do
          get "get", to: "messages#getMessages"
          get "search", to: "messages#searchOnMessage"
          post "create", to: "messages#createMessage"
          post "createOnQueue", to: "messages#createMessageOnQueue"
        end
      end
    end
  end
end
