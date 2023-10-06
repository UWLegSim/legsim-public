unless Rails.env == 'production'
  ActiveMerchant::Billing::Base.mode = :test
end
