class PublicRunsController < ApplicationController
  def index
    @runs = Run.publicly_visible
  end

  def show
    @run = Run.publicly_visible.find(params[:id])
  end
end
