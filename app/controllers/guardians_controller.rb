class GuardiansController < ApplicationController
   before_action :authenticate_user!
   before_action :set_guardian, only: [:show, :edit, :update, :destroy]

  def index
    @guardians = current_user.guardians
  end

  def show
  end

  def new
    @guardian = Guardian.new
  end

  def create
    @guardian = current_user.guardians.new(guardian_params)

    if @guardian.save
      redirect_to profile_path(anchor: "guardians"), notice: "Votre Guardian a bien été créé !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @guardian.update(guardian_params)
      redirect_to profile_path(anchor: "guardians"), notice: "Votre Guardian a bien été mis à jour !"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @guardian.destroy
    redirect_to profile_path(anchor: "guardians"), notice: "Votre Guardian a bien été supprimé !"
  end

  private

  def set_guardian
    @guardian = current_user.guardians.find(params[:id])
  end

  def guardian_params
    params.require(:guardian).permit(:name, :phone_number)
  end
end
