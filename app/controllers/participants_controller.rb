class ParticipantsController < ApplicationController
  load_and_authorize_resource skip_load_resource only: [:create] 
  before_action :set_participant, only: [:show, :edit, :update, :destroy]
  
  # GET /participants
  # GET /participants.json
  def index
    unless ( params[:organization_id].blank? )
      @organization = Organization.find(params[:organization_id])
      @participants = @organization.participants
    else
      @participants = Participant.all
    end

    @participants = @participants.paginate(:page => params[:page]).per_page(20)
  end

  def lookup
    # Process request if barcode is present
    participant = Participant.find_by_card params[:card_number]
    
    unless participant.blank?
      render json: { :id => participant.id, :name => participant.name }
    else
      render json: :nothing, status: :unprocessable_entity
    end
  end

  # GET /participants/1
  # GET /participants/1.json
  def show
    @memberships = @participant.memberships.all
  end

  # GET /participants/new
  # GET /participants/new.json
  def new
    @participant = Participant.new
  end

  # GET /participants/new
  # GET /participants/new.json
  def new_user_and_participant
    @participant = Participant.new
  end

  # GET /participants/1/edit
  def edit
  end

  # POST /participants
  # POST /participants.json
  def create
    @participant = Participant.new(participant_create_params)
    @participant.save
    respond_with(@participant)
  end

  # PUT /participants/1
  # PUT /participants/1.json
  def update
    @participant.update_attributes(participant_update_params)
    respond_with(@participant)
  end

  # DELETE /participants/1
  # DELETE /participants/1.json
  def destroy
    @participant.destroy
    respond_with(@participant)
  end

  private
  def set_participant
    @participant = Participant.find(params[:id])
  end

  def participant_create_params
    params.require(:participant).permit(:andrewid, :phone_number, :has_signed_waiver, :has_signed_hardhat_waiver)
  end

  def participant_update_params
    params.require(:participant).permit(:phone_number, :has_signed_waiver, :has_signed_hardhat_waiver)
  end
end

