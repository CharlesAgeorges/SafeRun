class RunsController < ApplicationController
  before_action :set_run, only: %i[show end_run start_run pause_run resume_run destroy update]
  before_action :authenticate_user!
  def new
    @run = Run.new
  end

  def index
    @runs = current_user.runs.order(created_at: :desc)
  end

  def create
    @run = Run.new(run_params)
    @run.user = current_user
    @run.status = "planned"
    @run.started_at = nil

    if @run.save
      redirect_to @run, notice: "Course planifiée", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def update
    if @run.update(run_params)
      redirect_to @run, notice: "Run modifiée"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @run.destroy
    redirect_to runs_path, notice: "Run supprimée"
  end

  def edit
  end

  def start_run
    if @run.status == "planned"
      @run.update(
        status: "running",
        started_at: Time.current
      )
      redirect_to @run, notice: "Course démarrée"
    else
      redirect_to @run, alert: "Cette course ne peut pas être démarrée"
    end
  end

  def end_run
    if ["running", "paused"].include?(@run.status)
      @run.update(
        status: "ended",
        ended_at: Time.current
      )
      redirect_to @run, notice: "Run terminée"
    else
      redirect_to @run, alert: "Erreur lors de la fin de la run"
    end
  end

  def pause_run
    if @run.status == "running"
      @run.update(
        status: "paused",
        paused_at: Time.current
      )
      redirect_to @run, notice: "Course mise en pause"
    else
      redirect_to @run, alert: "Impossible de mettre en pause cette course."
    end
  end

  def resume_run
    if @run.status == "paused"
      pause_duration = (Time.current - @run.paused_at).to_i
      @run.update(
        status: "running",
        paused_duration: @run.paused_duration + pause_duration,
        paused_at: nil
      )
      redirect_to @run, notice: "Course reprise"
    else
      redirect_to @run, alert: "Cette course ne peut pas être reprise"
    end
  end

  private

  def set_run
    @run = current_user.runs.find(params[:id])
  end

  def run_params
    params.require(:run).permit(:duration, :distance, :start_point, :start_point_lat, :start_point_lng)
  end
end
