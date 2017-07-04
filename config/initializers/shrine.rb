require 'shrine'

Shrine.plugin :activerecord
Shrine.plugin :direct_upload
Shrine.plugin :backgrounding

require "shrine/storage/s3"

s3_options = {
  access_key_id:     ENV.fetch("S3_ACCESS_KEY_ID"),
  secret_access_key: ENV.fetch("S3_SECRET_ACCESS_KEY"),
  region:            ENV.fetch("S3_REGION"),
  bucket:            ENV.fetch("S3_BUCKET"),
}
Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
  store: Shrine::Storage::S3.new(prefix: "store", **s3_options),
}

Shrine::Attacher.promote do |data|
  Rails.logger.info "Shrine promoting file scheduled"
  ::Cas::Images::PromoteJob.perform_async(data)
end

Shrine::Attacher.delete do |data|
  Rails.logger.info "Shrine deleting file scheduled"
  ::Cas::Images::DeleteJob.perform_async(data)
end
