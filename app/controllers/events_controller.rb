class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]

  def index
    @events = Event.all
    render json: @events
  end

  def show
    render json: @event
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      render json: @event, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  #TODO handle concurrence
  #1 - The  client must send only what is changed so the chance of overwriting with stale date is low
  #2 - We could use versioning with optimistic lock to change risks further
  #3 - If client cant manipulate stale data we could use pessimist locking  - would increase latency
  #4 - send to a queue in front of database and let a worker modify database - would decrease latency, worker would notify client
  #  or the client would later consult if request was successful. If no concurrence check is needed it will always be successful (since model is validated)
  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      head :no_content
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy

    head :no_content
  end

  private

    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :description, :start, :end, :number_of_days, :location, :published, :deleted)
    end
end
