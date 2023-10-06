class Action < ActiveRecord::Base

  belongs_to :user

  scope :get, -> {where(request_type: 'get')}
  scope :post, -> {where(request_type: 'post')}

end
