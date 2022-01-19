module Api
  class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token

    #get all messages for specific chat by application token and chat number paginated required
    def getMessages
      params.require(:page)
      params.require(:per_page)

      app = App.find_by(access_token: params[:access_token])

      if app.nil?
        render json: {status: 'ERROR' , message: 'Invalid Token' , data: [] } , status: :unprocessable_entity
        return
      end

      chat = Chat.where(app_id: app.id , number:params[:chat_number]).first

      if chat.nil?
        render json: {status: 'ERROR' , message: 'Invalid Chat Number' , data: [] } , status: :unprocessable_entity
        return
      end

      messages = Message.for_chat(chat.id).page(params[:page]).per(params[:per_page]).order('number DESC')
      render json: {status: 'SUCCESS' , data: messages } , status: :ok
    end

    # search on all messages elasticsearch for specific chat
    def searchOnMessage
      params.require(:search_text)
      page = params[:page].nil? ? 1 : params[:page].to_i
      per_page = params[:per_page].nil? ? 5 : params[:per_page].to_i

      app = App.find_by(access_token: params[:access_token])

      if app.nil?
        render json: {status: 'ERROR' , message: 'Invalid Token' , data: [] } , status: :unprocessable_entity
        return
      end

      chat = Chat.where(app_id: app.id , number:params[:chat_number]).first

      if chat.nil?
        render json: {status: 'ERROR' , message: 'Invalid Chat Number' , data: [] } , status: :unprocessable_entity
        return
      end

      # Message.create_index!
      Message.__elasticsearch__.import
      message = Message.es_search(params[:search_text] , page , per_page).records.for_chat(chat.id)
      render json: {status: 'SUCCESS' , data: message , search_text:  params[:search_text]} , status: :ok
    end

    # def createMessage
    #   params.require(:message)
    #
    #   app = App.find_by(access_token: params[:access_token])
    #
    #   if app.nil?
    #     render json: {status: 'ERROR' , message: 'Invalid Token' , data: [] } , status: :unprocessable_entity
    #     return
    #   end
    #
    #   chat = Chat.where(app_id: app.id , number:params[:chat_number]).first
    #
    #   if chat.nil?
    #     render json: {status: 'ERROR' , message: 'Invalid Chat Number' , data: [] } , status: :unprocessable_entity
    #     return
    #   end
    #
    #   messageNextNumber = chat.next_message_number + 1
    #
    #   message = Message.create(chat_id: chat.id , number: messageNextNumber , message: params[:message])
    #   if !message.nil?
    #     countMessage = Message.where(chat_id: chat.id).maximum("number")
    #
    #     chat.update(messages_count: countMessage , next_message_number: messageNextNumber)
    #   end
    #
    #   render json: {status: 'SUCCESS' , data: messageNextNumber } , status: :ok
    # end

    def createMessageOnQueue # create message and set the creation action on queue to handle the many request creation
      params.require(:message)

      app = App.find_by(access_token: params[:access_token])

      if app.nil?
        render json: {status: 'ERROR' , message: 'Invalid Token' , data: [] } , status: :unprocessable_entity
        return
      end

      chat = Chat.where(app_id: app.id , number:params[:chat_number]).first

      if chat.nil?
        render json: {status: 'ERROR' , message: 'Invalid Chat Number' , data: [] } , status: :unprocessable_entity
        return
      end

      messageNextNumber = chat.next_message_number + 1

      CreateMessageJob.perform_later(chat.id , messageNextNumber ,  params[:message])

      chat.update(next_message_number: messageNextNumber)

      render json: {status: 'SUCCESS' , data: messageNextNumber } , status: :ok
    end
  end
end