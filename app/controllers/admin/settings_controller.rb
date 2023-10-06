class Admin::SettingsController < ApplicationController

  def index

    @chamber = current_chamber
    @default_settings = YAML.load_file( Rails.root.join('config', 'scenerios', "#{@chamber.scenerio}.yml") )['chamber_settings']

    @page_title = @chamber.name
    @page_description = "Settings Management"

  end

  def mass_update

    if params[:commit] == 'Save Settings'
      params['settings'].each_pair do |key, value|
        current_chamber.setting(key,value)
      end
      display_message("Settings Saved")
    elsif params[:commit] == 'Restore Settings'
      current_chamber.restore_chamber_settings
      display_message("Settings Restored")
    end

    redirect_to( admin_settings_path )

  end
#
#   def export
#     chamber_settings = @current_chamber.chamber_settings.collect do |chamber_setting|
#       {
#         'name'  => chamber_setting.name,
#         'value' => chamber_setting.value
#       }
#     end
#
#     send_data YAML.dump({ 'chamber_settings' => chamber_settings }), :filename => 'chamber_settings.yml'
#   end
#
#   def init
#     @current_chamber.load_chamber_settings( @current_chamber.scenerio )
#
#     display_message("Settings have been reloaded",:attention)
#     redirect_to( admin_settings_path )
#   end

end
