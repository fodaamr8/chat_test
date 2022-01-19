class Chat < ApplicationRecord

  scope :for_app, ->(app_id) { where(app_id: app_id) }
  # scope :for_app, ->(access_token) { joins(:app).where(apps:{access_token: access_token}) }

  belongs_to :app
  has_many :messages

  def as_json(options={})
    options[:except] ||= [:id]
    super(options)
  end
end
