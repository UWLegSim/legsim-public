class Chamber < ActiveRecord::Base

  validates_presence_of :name, :message => "Chamber must have a name."
  validates_presence_of :course_id, :message => "Chamber must have a Course."
  validates_presence_of :scenerio, :message => "Chamber must have a scenerio."

  belongs_to :course
  has_many :legislative_types
  has_many :legislation, :through => :legislative_types

  has_many :introduced_legislation, -> { where(status: 'introduced') }, through: :legislative_types, source: :legislation
  has_many :referred_legislation,   -> { where(status: 'referred') },   through: :legislative_types, source: :legislation

  has_many :contents

  has_many :chamber_settings
  has_many :letters

  has_many :chamber_roles, -> { order(:last_name) }
  has_many :members, -> { order(:last_name) }
  has_many :administrators, -> { order(:last_name) }
  has_many :executives, -> { order(:last_name) }
  has_many :instructors, -> { order(:last_name) }

  has_many :tutorials, -> { order(:position) }
  has_many :instructions, -> { order(:position) }

  has_many :groups
  has_one  :floor
  has_many :parties
  has_many :committees
  has_many :caucuses
  has_many :sections
  has_many :votes
  has_many :leadership_nominations

  has_many :referrals, :through => :groups

  has_many :constituencies
  has_many :survey_questions

  has_many :authorization_codes

  def legislative_type_for_special_rule
    LegislativeType.find( setting('special_rule_legislative_type_id') )
  end

  def member_authorization_code
    authorization_codes.member.first
  end
#   has_one  :member_authorization_code, -> {where(chamber_role_type: 'Member')}, :class_name => 'AuthorizationCode'
#   has_one  :administrator_authorization_code, -> {where(chamber_role_type: 'Administrator')},  :class_name => 'AuthorizationCode'

  after_create :generate_authorization_codes
  after_create :initialize_from_config
  after_create :initialize_content_from_config
  after_create :create_floor

  def generate_authorization_codes
    ['Member','Administrator','Executive','Instructor'].each do |chamber_role_type|
      self.authorization_codes.create!( :chamber_role_type => chamber_role_type )
    end
  end

  def create_floor
    self.floor = Floor.create!(
      name: name,
      abbr: 'Floor',
      chamber: self
    )
  end

  def title
    name
  end

  def course_title
    "#{course.title} - #{name}"
  end

  def scenerio_title
    case scenerio
      when 'us_house_of_representatives' then 'US House of Representatives'
      when 'us_senate' then 'US Senate'
    end
  end

  def unassigned_users
    course.users.reject do |user|
      true if user.chamber_role( self )
    end
  end

  def reinitalize

    chamber_settings.destroy_all
    clear_settings_cache

    committees.destroy_all
    parties.destroy_all
    constituencies.destroy_all
    survey_questions.destroy_all
    legislative_types.destroy_all
    leadership_nominations.destroy_all

    initialize_from_config

    contents.destroy_all
    instructions.destroy_all
    tutorials.destroy_all

    initialize_content_from_config

  end

  def restore_chamber_settings
    chamber_settings.destroy_all
    load_chamber_settings
  end

  def load_chamber_settings( default_chamber_settings = false )

    default_chamber_settings = YAML.load_file( Rails.root.join('config', 'scenerios', "#{scenerio}.yml") )['chamber_settings'] unless default_chamber_settings

    default_chamber_settings.each do |chamber_setting|
      chamber_settings.create!(:name => chamber_setting['name'], :value => chamber_setting['default'])
    end

  end

  def initialize_from_config

    data = YAML.load_file( Rails.root.join('config', 'scenerios', "#{scenerio}.yml") )

    load_chamber_settings

    data['committees'].each do |committee_data|
      committees.create!( committee_data  )
    end

    data['parties'].each do |party_data|
      parties.create!( party_data  )
    end

    data['constituencies'].each do |constituency_data|
      constituencies.create!( constituency_data  )
    end

    data['survey_questions'].each do |survey_question_data|
      survey_questions.create!( survey_question_data  )
    end

    data['legislative_types'].each do |legislative_type_data|
      legislative_types.create!( legislative_type_data  )
    end

    load_special_settings( data['special_settings'] ) if data['special_settings']

  end

  def load_special_settings( special_settings )

    if special_settings['rules_committee']
      committee = committees.find_by_name( special_settings['rules_committee'] )
      committee.setting('can_draft_special_rule',1)
    end

    if special_settings['rules_legislation_type']
      legislative_type = legislative_types.find_by_name( special_settings['rules_legislation_type'] )
      setting('special_rule_legislative_type_id',legislative_type.id)
    end

  end

  def initialize_content_from_config

    data = YAML.load_file( Rails.root.join('config', 'scenerios', "#{scenerio}_content.yml") )

    data['tutorials'].each do |tutorial_data|
      tutorials.create!( tutorial_data  )
    end

    data['instructions'].each do |instruction_data|
      instructions.create!( instruction_data  )
    end

    data['contents'].each do |content_data|
      contents.create!( content_data  )
    end

  end

  def load_committees( scenerio )

    committees.destroy_all

    data = YAML.load_file( Rails.root.join('config', 'scenerios', scenerio, 'committees.yml') )

    data['committees'].each do |committee_data|
      committees.create!( committee_data  )
    end

  end

  def load_contents( scenerio )

    contents.destroy_all

    data = YAML.load_file( Rails.root.join('config', 'scenerios', scenerio, 'contents.yml') )
    data['contents'].each do |content_data|
      contents.create!( content_data  )
    end

  end


  def load_constituencies( scenerio )

    constituencies.destroy_all

    data = YAML.load_file( Rails.root.join('config', 'scenerios', scenerio, 'constituencies.yml') )
    data['constituencies'].each do |constituency_data|
      constituencies.create!( constituency_data  )
    end

  end

  def load_survey_questions( scenerio )

    survey_questions.destroy_all

    data = YAML.load_file( Rails.root.join('config', 'scenerios', scenerio, 'survey_questions.yml') )
    data['survey_questions'].each do |survey_question_data|
      survey_questions.create!( survey_question_data  )
    end

  end

  def load_legislative_types( scenerio )

    legislative_types.destroy_all

    data = YAML.load_file( Rails.root.join('config', 'scenerios', scenerio, 'legislative_types.yml') )
    data['legislative_types'].each do |legislative_type_data|
      legislative_types.create!( legislative_type_data  )
    end

  end

  def export_content
    {
      'tutorials'    => tutorials.collect    {|t| {'title' => t.title, 'summary' => t.summary, 'position' => t.position, 'content' => t.content } },
      'instructions' => instructions.collect {|i| {'title' => i.title, 'summary' => i.summary, 'position' => i.position, 'content' => i.content } },
      'contents'     => contents.collect     {|c| {'reference' => c.reference, 'copy' => c.copy} }
    }
  end

#   def setting?( name )
#
#     @settings = {} unless @settings
#
#     unless @settings[name]
#       setting = chamber_settings.find_by_name( name )
#       @settings[name] = (setting == 'true') ? true : false
#     end
#
#     @settings[name]
#
#   end

  def setting( name, value = nil )

    @settings = {} unless @settings
    @settings[name] = chamber_settings.find_or_create_by(name: name) unless @settings[name]

    if value
      value = nil if value == 'false'
      @settings[name].value = value
      @settings[name].save
    end

    @settings[name].value

  end

  def clear_settings_cache
    @settings = {}
  end

end
