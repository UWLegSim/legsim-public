class LegislativeText < ActiveRecord::Base

  before_save :clear_invalid_unicode

  def clear_invalid_unicode
    self.primary_text = primary_text ? primary_text.encode('ascii', invalid: :replace, undef: :replace, replace:'') : nil
    self.secondary_text = secondary_text ? secondary_text.encode('ascii', invalid: :replace, undef: :replace, replace:'') : nil
  end
end
