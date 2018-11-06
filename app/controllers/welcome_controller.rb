class WelcomeController < ApplicationController
  def index
    flash[:alert] = "晚安！該睡了！"
  end
end
