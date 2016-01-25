class ContragentsController < ApplicationController
  def index
  end

  def create
    @contragent = Contragent.new(new_params)
    if @contragent.save 
      redirect_to @contragent, notice: "new contragent was created successfully"
    else
      redirect_to :back, alert: "some error occured while saving"
    end
  end

  def new
    @contragent = Contragent.new
    @contragent.build_contragent_profile
  end

  def edit
  end

  def show
    @contragent ||= Contragent.includes(:contragent_profile).find(params[:id])
  end

  def update
  end

  def destroy
  end

  #params
  def new_params
    params.require(:contragent).permit(:name, :corporate_form, 
                                        contragent_profile_attributes: [:address, :director, :bank_account,
                                                                        :postal_address, :contacts])
  end
end
