class TransactionRecordsController < ApplicationController
  def index
    @transaction_records = TransactionRecord.all
  end
end
