class AuthorizationCode < ActiveRecord::Base

  belongs_to :chamber
  scope :member, -> { where(chamber_role_type: 'Member') }

  before_create :set_code

  def set_code
    self.code = generate_code( Time.now.to_s )
  end

  def generate_code( salt )
    hash = Digest::MD5.hexdigest( salt )
    if AuthorizationCode.find_by_code( hash )
      generate_code( hash )
    else
      hash
    end
  end

  def create_chamber_role( user )

    chamber_role_type.constantize.create!(
      :first_name => user.first_name,
      :last_name  => user.last_name,
      :chamber    => chamber,
      :user       => user
    )

  end

end
