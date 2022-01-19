class Message < ApplicationRecord
  scope :for_chat, ->(chat_id) { where(chat_id: chat_id) }

  belongs_to :chat

  def as_json(options={})
    options[:except] ||= [:id]
    super(options)
  end

  include MessageSearchable  # class to handle elasticsearch
end
