# coding: utf-8
require 'will_paginate/array'
class UsersController < ApplicationController
  layout "no_wrapper"
  before_filter :find_user, only: [:show, :topics, :favorites, :notes]
  before_filter :validate_user

  #根目录下访问某用户主页的时候，如果找不到这个人，则跳转到404页面
  def validate_user
     render_404 if @user.nil?
  end

  def show
    @topics = @user.topics.limit(20)
    @replies = @user.replies.only(:topic_id, :body_html, :created_at).recent.includes(:topic).limit(10)   
  end

  protected
  def find_user
    # 处理 login 有大写字母的情况
    if params[:id] != params[:id].downcase
      redirect_to request.path.downcase, status: 301
      return
    end

    @user = User.find_login(params[:id])
  end

end
