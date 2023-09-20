class PendingSellerTransactionsController < ApplicationController
    def index
        render json: PendingSellerTransaction.all
    end
end
