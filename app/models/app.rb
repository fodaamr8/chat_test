class App < ApplicationRecord
  has_secure_token :access_token

  has_many :chats

  def as_json(options={})
    options[:except] ||= [:id]
    super(options)
  end
end
