class ContractInfosController < ApplicationController

  before_action :verify_auth, only: %i[index confirm_transaction complete_transaction create destroy update]

  def show
    @contract = ContractInfo.find_by(id: params[:id])
    render json: { message: 'success', contract_info: @contract }, status: :ok
  end

  def update
    @contract = ContractInfo.find_by(id: params[:id])
    if @contract.update(contract_update_params)
      render json: { message:"succesully saved contract"}, status: :ok
    else
      render json: { message:"failed to save contract"}, status: :unprocessable_entity
    end

  end

  def destroy
  end

  private

  def contract_params
    params.permit(:payment_terms, id)
  end

  def contract_update_params
    params.permit(:product_name)
  end
end
