class JqUploaderService
  include Rails.application.routes.url_helpers

  # this extends from carrierwave so please ONLY pass carrier wave objects to here!!

  def self.convert_to_jq_upload(carrier_item, lesson_id, symb)
    name = carrier_item.path.split("/").last
    thumbnail = '' unless carrier_item.respond_to?(:thumb)
      {
        "name" => name,
        "size" => carrier_item.size,
        "url" => carrier_item.url,
        "thumbnail_url" => thumbnail,
        "delete_url" => "/lessons/#{lesson_id}/file/?name=#{name}&attr=#{symb}",
        "delete_type" => "DELETE"
    }
  end


end