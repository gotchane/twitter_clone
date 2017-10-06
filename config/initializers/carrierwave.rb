CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.secrets.aws_access_key_id,
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
      region: Rails.application.secrets.aws_region,
      path_style: true
    }
    config.fog_public = true
    config.fog_attributes = {'Cache-Control' => 'public, max-age=86400'}
    config.remove_previously_stored_files_after_update = false
    config.fog_directory = Rails.application.secrets.aws_s3_bucket
  else
    config.storage = :file
  end
end
