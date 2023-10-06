require 'digest/sha1'
require 'net/smtp'

class SystemUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable, :omniauthable, :registerable, :confirmable,
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:email]

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def title
    name
  end

  def send_activation_code

    message = <<END_OF_MESSAGE
From: no-reply@legsim.org
To: #{email}
Subject: LegSim Activation

Your account is ready, all you need to do is activate it by following this link:
#{activation_url}
END_OF_MESSAGE

  ##Net::SMTP.start('localhost') do |smtp|
 ##     smtp.send_message message, 'no-reply@legsim.org', email
## end
end

  def send_password_reset_code

    make_password_reset_code

    message = <<END_OF_MESSAGE
From: no-reply@legsim.org
To: #{email}
Subject: LegSim Password Reset

A request has been made to reset your password. To do so, follow this link and provide a new password:
#{password_reset_url}
END_OF_MESSAGE

    Net::SMTP.start('localhost') do |smtp|
      smtp.send_message message, 'no-reply@legsim.org', email
    end
  end

  def generate_random_password
    (0...8).collect { |n| ('a'..'z').to_a[rand(26)] }.join()
  end

  protected

    def activation_url
      "http://beta.legsim.org/system/activate/#{activation_code}"
    end

    def password_reset_url
      "http://beta.legsim.org/system/reset_password/#{password_reset_code}"
    end

    def make_password_reset_code
      self.password_reset_code = self.class.make_token
      save
    end

    def make_activation_code
      self.deleted_at = nil
      self.activation_code = self.class.make_token
      send_activation_code
    end

end
