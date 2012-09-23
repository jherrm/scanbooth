class WelcomeController < ApplicationController
  def index
    @user = User.new
  end

  def thanks
  end
end
