class HomeController < ApplicationController

  def index
    if user_signed_in?
      @toys = current_user.toys
      render 'home'
    end
  end

end
