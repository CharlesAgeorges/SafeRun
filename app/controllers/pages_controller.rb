class PagesController < ApplicationController
  def home
    #if user_signed_in?
      #redirect_to profile_path
    #end
  end

  def profile
    @user = current_user
    @runs = @user.runs.order(created_at: :desc)
    @guardians = @user.guardians
    @badges = @user.badges
    @run_badges = @user.run_badges
  end
end
