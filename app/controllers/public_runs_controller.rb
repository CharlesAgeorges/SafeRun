class PublicRunsController < ApplicationController
  def index
    @runs = Run.safe_run
  end

  def show
    @run = Run.find(params[:id])
    if @run.user == current_user
      redirect_to run_path(@run)
    else
      @run = Run.safe_run.find(params[:id])
    end
  end
end
