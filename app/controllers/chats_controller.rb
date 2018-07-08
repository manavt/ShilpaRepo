class ChatsController < ApplicationController
  # caches_page :index
  def index
    @user = User.all
  end
end
