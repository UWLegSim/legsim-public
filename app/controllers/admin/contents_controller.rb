class Admin::ContentsController < ApplicationController

  def index
    @chamber = current_chamber

    @page_title = @chamber.name
    @page_description = "Content Management"
  end

  def new
    @content = Content.new(
      :reference => params['reference'],
      :altered   => false,
      :chamber   => @current_chamber
    )
  end

  def edit
    @content = Content.find( params[:id] )
    @content.altered = true
  end

  def create
    @content = Content.new( content_params )
    if @content.save
      display_message("Content Created")
      redirect_to( edit_admin_content_path( @content ) )
    else
      render(:action => :new)
    end
  end

  def update
    @content = Content.find( params[:id] )
    if @content.update(content_params)
      display_message("Content Updated")
      redirect_to( edit_admin_content_path( @content ) )
    else
      render(:action => :edit)
    end
  end

  def export
    contents = @current_chamber.contents.collect do |content|
      {
        'reference' => content.reference,
        'copy' => content.copy
      }
    end

    send_data YAML.dump({ 'contents' => contents }), :filename => 'contents.yml'
  end

  def init
    @current_chamber.load_contents( @current_chamber.scenerio )

    display_message("Contents have been reloaded",:attention)
    redirect_to( admin_contents_path )
  end

  def content_params
    params.require(:content).permit!
  end
end
