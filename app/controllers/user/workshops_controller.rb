class User::WorkshopsController < User::BaseController
  
  before_action :set_workshop, only: [:show, :edit, :update, :destroy]

  def index
    @workshops = current_user.owner_workshops
    respond_with(@workshops)
  end

  def show
    respond_with(@workshop)
  end

  def new
    @workshop = Workshop.new
    respond_with(@workshop)
  end

  def edit
  end

  def create
    @workshop = current_user.owner_workshops.build(workshop_params)
    @workshop.save
    respond_with(@workshop)
  end

  def update
    @workshop.update(workshop_params)
    respond_with(@workshop)
  end

  def destroy
    @workshop.destroy
    respond_with(@workshop)
  end

  private
    def set_workshop
      @workshop = current_user.owner_workshops.find(params[:id])
    end

    def workshop_params
      params.require(:workshop).permit(:user_id, :description, :details, :start_date, :end_date, :vacancies_number, :value, :prerequisite, :goal, :target_audience, :term, :image)
    end
end
