class AvatarUploader < CarrierWave::Uploader::Base

  # remove cached tempfiles straight after :store
  after :store, :clean_cached_files

  # initialize with custom cache_id without override initialize
  def self.new_with_cache_id(id)
    CarrierWave.clean_cached_files!(60 * 60) # clean 1 hour old cached files
    instance = new
    instance.instance_variable_set(:@cache_id, id)
    instance
  end

  # TODO - resize and make thumbs?? read docs

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "avatars/#{model.class.to_s.underscore}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  private

  # remove public/uploads/temp/{avatar_cache_id}
  def clean_cached_files(*args)
    return unless model && model.respond_to?(:avatar_cache) && model.avatar_cache
    return unless File.directory?(File.dirname Rails.public_path.join(cache_dir, model.avatar_cache))
    FileUtils.rm_rf File.dirname(Rails.public_path.join(cache_dir, model.avatar_cache))
  end

end
