# This +RESTful+ controller is used to orchestrate and control the flow of 
# the application relating to +GeoViewer+ objects.
class Admin::GeoViewersController < Admin::AdminController

  # The +create+ action needs the parent +Node+ object to link the new +GeoViewer+ content node to.
  prepend_before_filter :find_parent_node,      :only => [ :new, :create ]

  # The +show+, +edit+ and +update+ actions need a +GeoViewer+ object to act upon.
  before_filter :find_geo_viewer,               :only => [ :show, :edit, :update, :previous ]

  before_filter :set_commit_type,               :only => [ :create, :update ]

  before_filter :set_search_scopes

  layout false

  require_role [ 'admin', 'final_editor' ]

  # * GET /geo_viewers/:id
  # * GET /geo_viewers/:id.xml
  def show       
    respond_to do |format|
      format.html { render :partial => 'show', :locals => { :record => @geo_viewer }, :layout => 'admin/admin_show' }
      format.xml  { render :xml => @geo_viewer }
    end
  end  

  # * GET /admin/geo_viewers/new
  def new
    @geo_viewer = GeoViewer.new(params[:geo_viewer])
    @geo_viewer.filter_settings = @geo_viewer.filter_settings.class == Hash ? @geo_viewer.filter_settings : {}
    @geo_viewer.filter_settings[:permit_product_type] ||= []
    @geo_viewer.filter_settings[:permit_phase]        ||= []

    respond_to do |format|
      format.html { render :template => 'admin/shared/new', :locals => { :record => @geo_viewer }}
    end
  end

  # * GET /admin/geo_viewers/:id/edit
  def edit
    @geo_viewer.attributes = params[:geo_viewer]

    respond_to do |format|
      format.html { render :template => 'admin/shared/edit', :locals => { :record => @geo_viewer }}
    end
  end

  # * POST /admin/geo_viewers
  # * POST /admin/geo_viewers.xml
  def create
    @geo_viewer        = GeoViewer.new(params[:geo_viewer])
    @geo_viewer.parent = @parent_node

    respond_to do |format|
      if @commit_type == 'preview' && @geo_viewer.valid?
        format.html { render :template => 'admin/shared/create_preview', :locals => { :record => @geo_viewer }, :layout => 'admin/admin_preview' }
        format.xml  { render :xml => @geo_viewer, :status => :created, :location => @geo_viewer }
      elsif @commit_type == 'save' && @geo_viewer.save
        format.html { render :template => 'admin/shared/create' }
        format.xml  { head :ok }
      else
        format.html { render :template => 'admin/shared/new', :locals => { :record => @geo_viewer }, :status => :unprocessable_entity }
        format.xml  { render :xml => @geo_viewer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # * PUT /admin/geo_viewers/:id
  # * PUT /admin/geo_viewers/:id.xml
  def update
    @geo_viewer.attributes = params[:geo_viewer]

    respond_to do |format|
      if @commit_type == 'preview' && @geo_viewer.valid?
        format.html {
          find_images_and_attachments
          render :template => 'admin/shared/update_preview', :locals => { :record => @geo_viewer }, :layout => 'admin/admin_preview'
        }
        format.xml  { render :xml => @geo_viewer, :status => :created, :location => @geo_viewer }
      elsif @commit_type == 'save' && @geo_viewer.save
        format.html { render :template => 'admin/shared/update' }
        format.xml  { head :ok }
      else
        format.html { render :template => 'admin/shared/edit', :locals => { :record => @geo_viewer }, :status => :unprocessable_entity }
        format.xml  { render :xml => @geo_viewer.errors, :status => :unprocessable_entity }
      end
    end
  end

protected

  # Finds the +GeoViewer+ object corresponding to the passed in +id+ parameter.
  def find_geo_viewer
    @geo_viewer = GeoViewer.find(params[:id]).current_version
  end

  def set_default_search_scopes
    @search_scopes.unshift([I18n.t('geo_viewers.filter_settings.parent_section'), "node_#{(@parent_node || @node.parent).id}"]) if @node || @parent_node
    @search_scopes.unshift([I18n.t('geo_viewers.filter_settings.all'), 'all'])
  end
end
