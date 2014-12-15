# coding: utf-8
require "digest/md5"
module UsersHelper
  # 生成用户 login 的链接，user 参数可接受 user 对象或者 字符串的 login
  def user_name_tag(user,options = {})
    return "匿名" if user.blank?

    if user.is_a? String
      login = user
      name = login
    else
      login = user.login
      name = user.name
    end

    name ||= login
    options['data-name'] = name

    link_to(login, user_path(login.downcase), options)
  end

  def user_avatar_tag(user, size = :normal, opts = {})
  	rand_img = "avatar/default_#{size}_user.jpg"
    
    if user.blank?
      return image_tag(rand_img)
    end

    if user[:avatar].present? && user.avatar_file_exist?
        img = image_tag(user.avatar_url(size))
    else
    	img = image_tag(asset_path(rand_img))
    end
      raw img
  end

end
