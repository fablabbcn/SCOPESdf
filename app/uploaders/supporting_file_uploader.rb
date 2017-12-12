# frozen_string_literal: true
class SupportingFileUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
   storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "supporting_files/#{model.class.to_s.underscore}/#{model.id}"
  end

  process resize_to_limit: [1024, 1024]

  version :thumbnail do
    process resize_to_fill: [270, 202]
    process convert: "jpg"
  end

  version :thumbnail2x do
    process resize_to_fill: [540, 404]
    process convert: "jpg"
  end

  version :medium do
    process resize_to_fill: [720, 540]
    process convert: "jpg"
    #process :optimize
  end

  version :medium2x do
    process resize_to_fill: [1440, 1080]
    process convert: "jpg"
    #process :optimize
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
