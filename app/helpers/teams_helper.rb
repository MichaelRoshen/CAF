# coding: utf-8
require "digest/md5"
module TeamsHelper
  # 生成用户 login 的链接，user 参数可接受 user 对象或者 字符串的 login
  def team_name_tag(team,options = {})
    return "匿名" if team.blank?

    options['data-name'] = name

    link_to(name, team_path(name.downcase), options)
  end

  def team_avatar_tag(team, size = :normal, opts = {})
  	rand_img = "avatar/default_#{size}_team.jpg"
    
    if team.blank?
      return image_tag(rand_img)
    end

    if team[:avatar].present? && team.avatar_file_exist?
        img = image_tag(team.avatar_url(size))
    else
    	img = image_tag(asset_path(rand_img),size: "320x360")
    end
      raw img
  end

end
