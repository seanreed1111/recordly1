class UserController < ApplicationController
  before_action :authenticate_user!

  def search
    safe_text = params[:search]
    @results = current_user.search(safe_text) #uses PgSearch
  end

  private
   def favorites_params
    params.require(:user).permit(:user_id, :search)
   end
end
