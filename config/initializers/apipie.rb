Apipie.configure do |config|
  config.app_name                = "QaUi"
  config.api_base_url            = ""
  config.doc_base_url            = "/apipie"
  config.default_locale          = 'en'
  config.languages               = ['en']
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
