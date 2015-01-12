# coding: utf-8
class PhotosController < ApplicationController
  load_and_authorize_resource

  def create
    @photo = Photo.new
    @photo.image = params[:upload_file]
    @photo.user_id = current_user.id
    @photo.save
    msg = { success: true, msg: "上传成功", file_path: @photo.image.url}
    render json: msg
  end
end
