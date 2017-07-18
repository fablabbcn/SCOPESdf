class UploadedFilesController < ApplicationController

  def index
    @pictures = Picture.all
    render :json => @pictures.collect { |p| p.to_jq_upload }.to_json
  end

  def create
    @picture = Picture.new(params[:picture])
    if @picture.save
      respond_to do |format|
        format.html {
          render :json => [@picture.to_jq_upload].to_json,
                 :content_type => 'text/html',
                 :layout => false
        }
        format.json {
          render :json => [@picture.to_jq_upload].to_json
        }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    render :json => true
  end



  def file_form_upload
    uploaded = file_params[:avatar]
    puts uploaded
    u = User.first
    u.attributes = file_params
    u.save!

    render :json => {status: "GUCCI"}, :status => 200
  end

end
