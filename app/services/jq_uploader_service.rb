class JqUploaderService
  include Rails.application.routes.url_helpers

  # this extends from carrierwave so please ONLY pass carrier wave objects to here!!

  def self.convert_to_jq_upload(carrier_item, lesson_id, symb)
    name = carrier_item.path.split("/").last
    thumbnail =  carrier_item.url.to_s
    json_obj = {
        "name" => name,
        "size" => carrier_item.size,
        "url" => carrier_item.url,
        "thumbnail_url" => carrier_item.url,
        "delete_url" => "/lessons/#{lesson_id}/delete_file/?name=#{name}&attr=#{symb}",
        "delete_type" => "DELETE"
    }
    json_obj
  end

  def self.convert_to_jq_upload_step(carrier_item, lesson_id, step_id, symb)
    name = carrier_item.path.split("/").last
    thumbnail =  carrier_item.url.to_s
    json_obj = {
        "name" => name,
        "size" => carrier_item.size,
        "url" => carrier_item.url,
        "thumbnail_url" => carrier_item.url,
        "delete_url" => "/lessons/#{lesson_id}/#{step_id}/delete_file/?name=#{name}&attr=#{symb}",
        "delete_type" => "DELETE"
    }
    json_obj
  end


end