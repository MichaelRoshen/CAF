# coding: utf-8
class Background::ApplicationController < ApplicationController
  layout "background"
  before_filter :require_user
  before_filter :require_admin
  # before_filter :set_active_menu

  def require_admin
    if not true
      render_404
    end
  end
  
  # def set_active_menu
  #   @current = ["/" + ["cpanel",controller_name].join("/")]
  # end
  
end
