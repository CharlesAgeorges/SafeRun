class PositionsController < ApplicationController
  def create
    @run = current_user.runs.find(params[:run_id])
    @position = @run.positions.create(position_params)
    render json: @position
  end

  private

  def position_params
    params.require(:position).permit(:latitude, :longitude)
  end
end
