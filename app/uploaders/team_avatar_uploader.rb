# coding: utf-8
class TeamAvatarUploader < BaseUploader
  version :small do
    process resize_to_fill: [48, 48]
  end

  version :normal do
    process resize_to_fill: [72, 72]
  end

  version :big do
    process resize_to_fill: [96, 96]
  end

  version :large do
    process resize_to_fill: [320, 360]
  end

  def filename
    if super.present?
      "avatar/#{model.id}.jpg"
    end
  end

  def extension_white_list
    %w(jpg jpeg png)
  end
end

