class UserController < ApplicationController
  before_action :authenticate_user!

  def search
    safe_text = params[:search] #unneeded. PgSearch already makes sure text is safe
    destructured = current_user.search_destructured(safe_text)
    @albums = destructured[0]
    @artists = destructured[1]
    @songs = destructured[2]
    render 'search_destructured'
  end

  private
   def favorites_params
    params.require(:user).permit(:user_id, :search)
   end
end
