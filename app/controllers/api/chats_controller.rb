module Api
  class ChatsController < ApplicationController
    skip_before_action :verify_authenticity_token

    # get all chats
    def getChats
      app = App.find_by(access_token: params[:access_token])

      if app.nil?
        render json: {status: 'ERROR' , message: 'Invalid Token' , data: [] } , status: :unprocessable_entity
        return
      end

      chats = Chat.for_app(app.id).order('number DESC')
      render json: {status: 'SUCCESS' , data: chats } , status: :ok
    end

    # get single chat by chat number and application token
    def getChatById
      app = App.find_by(access_token: params[:access_token])

      if app.nil?
        render json: {status: 'ERROR' , message: 'Invalid Token' , data: [] } , status: :unprocessable_entity
        return
      end


      chat = Chat.for_app(app.id).find_by(number: params[:number])
      render json: {status: 'SUCCESS' , data: chat } , status: :ok
    end

    # create new chat on specific application and generate new number for it and return the creation object
    def createChat
      app = App.find_by(access_token: params[:access_token])

      if app.nil?
        render json: {status: 'ERROR' , message: 'Invalid Token' , data: [] } , status: :unprocessable_entity
        return
      end

      chatNextNumber = Chat.where(app_id: app.id).maximum("number")
      if chatNextNumber.nil?
        chatNextNumber = 1;
      else
        chatNextNumber = chatNextNumber + 1
      end

      chat = Chat.create(app_id: app.id , number: chatNextNumber )
      if !chat.nil?
        app.update(chats_count: chatNextNumber)
        render json: {status: 'SUCCESS' , data: chat } , status: :ok
      else
        render json: {status: 'ERROR' , data: chat.errors } , status: :unprocessable_entity
      end
    end

  end
end