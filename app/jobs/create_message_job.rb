class CreateMessageJob < ApplicationJob
  queue_as :default

  def perform(chat_id , messageNextNumber , message)
    message = Message.create(chat_id: chat_id , number: messageNextNumber , message: message)
    if !message.nil?
      chat = Chat.find(chat_id)
      chat.update(messages_count: messageNextNumber)
    end
  end
end
