module MessageSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name "es_message_#{Rails.env}"  # index name that will create on elasticsearch service

    settings do
      mappings dynamic: false do
        indexes :message, type: :text, analyzer: :english  # fields that will search on it
      end
    end

  end

  class_methods do
    def create_index!
      client = __elasticsearch__.client
      client.indices.delete index: self.index_name rescue nil
      client.indices.create(index: self.index_name,
                            body: {
                              settings: self.settings.to_hash,
                              mappings: self.mappings.to_hash
                            })
    end

    def es_search(query , page , per_page)
      __elasticsearch__.search({
                                 from: per_page * (page-1),
                                 size: per_page,
                                 query: {
                                   multi_match: {
                                     fields: %w(message),
                                     # fields: ['message'],
                                     type: 'cross_fields',
                                     query: query,
                                     operator: 'and'
                                   }
                                 }
                               })
    end
  end
end