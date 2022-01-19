config = {
  host:  ENV['ELASTICSEARCH_HOST'] || "elasticsearch",
}

Elasticsearch::Model.client = Elasticsearch::Client.new(config)