# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password,:cc_name,:cc_exp_month,:cc_exp_year,:cc_number,:cc_cvc]
