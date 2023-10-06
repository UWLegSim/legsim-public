class System::PaymentsController < SystemController

  def refund
    payment = User.find( params[:user_id] ).payments.find( params[:id] )
    credentials_key = Rails.env == 'production' ? :production : :testing

    gateway = ActiveMerchant::Billing::ElavonGateway.new(
      :login => Rails.application.credentials.elavon[credentials_key][:login], 
      :user => Rails.application.credentials.elavon[credentials_key][:user],
      :password => Rails.application.credentials.elavon[credentials_key][:password]
    )

    response = gateway.refund(nil, payment.transaction_id)

    if response.success?
      payment.update( status: 'Refunded' )
      redirect_to system_user_path(payment.user), notice: "Payment has been refunded."
    else
      raise StandardError, response.message
    end
  end

  private

  def user_params
    params.require(:payment).permit!
  end
end
