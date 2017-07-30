CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                             # required
  config.fog_credentials = {
      provider:              'AWS',                           # required
      aws_access_key_id:     "#{ENV['AWS_ACCESS_KEY_ID']}",   # required
      aws_secret_access_key: "#{ENV['AWS_SECRET_ACCESS_KEY']}",   # required
      region:                "#{ENV['AWS_REGION']}",                     # optional, defaults to 'us-east-1'
      host:                  "#{ENV['AWS_S3_HOST']}",         # optional, defaults to nil
      endpoint:              "#{ENV['AWS_S3_ENDPOINT']}"      # optional, defaults to nil
  }
  config.fog_directory  = "#{ENV['AWS_S3_FOG_DIRECTORY']}"    # required
  config.fog_public     = false                               # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.day.to_i}" } # optional, defaults to {}
  config.fog_authenticated_url_expiration = 6000

  config.ignore_integrity_errors = false
  config.ignore_processing_errors = false
  config.ignore_download_errors = false
end
# https://stackoverflow.com/questions/20003263/rails-carrierwave-fog-speed-optimisation