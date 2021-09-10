class TransactionRecordsController < ApplicationController
  def index
    @transaction_records = current_user.transaction_records
  end
end
