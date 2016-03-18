# This +RESTful+ controller is used to orchestrate and control the flow of
# the application relating to +GeoViewer+ objects.
class Admin::GeoViewersController < Admin::AdminController
  # The +create+ action needs the parent +Node+ object to link the new
  # +GeoViewer+ content node to.
  prepend_before_filter :find_parent_node, only: [:new, :create]

  # The +show+, +edit+ and +update+ actions need a +GeoViewer+ object to act
  # upon.
  before_filter :find_geo_viewer, only: [:show, :edit, :update, :previous]

  before_filter :set_commit_type, only: [:create, :update]

  before_filter :filter_parameters_for_viewer_type, only: :create

  before_filter :set_search_scopes

  layout false

  require_role %w(admin final_editor)

  # * GET /geo_viewers/:id
  # * GET /geo_viewers/:id.xml
  def show
    @actions << { url: { action: :index, controller: :pins }, text: 'Pins', method: :get }

    respond_to do |format|
      format.html { render partial: 'show', locals: { record: @geo_viewer }, layout: 'admin/admin_show' }
      format.xml  { render xml: @geo_viewer }
    end
  end

  # * GET /admin/geo_viewers/new
  def new
    @geo_viewer = GeoViewer.new(permitted_attributes)
    @geo_viewer.filter_settings = @geo_viewer.filter_settings.class == Hash ? @geo_viewer.filter_settings : {}
    @geo_viewer.filter_settings[:permit_product_type] ||= []
    @geo_viewer.filter_settings[:permit_phase] ||= []
    find_available_geo_viewer_placeables

    respond_to do |format|
      format.html { render template: 'admin/shared/new', locals: { record: @geo_viewer } }
    end
  end

  # * GET /admin/geo_viewers/:id/edit
  def edit
    @geo_viewer.attributes = permitted_attributes
    find_available_geo_viewer_placeables if @geo_viewer.combined_viewer?

    respond_to do |format|
      format.html { render template: 'admin/shared/edit', locals: { record: @geo_viewer } }
    end
  end

  # * POST /admin/geo_viewers
  # * POST /admin/geo_viewers.xml
  def create
    @geo_viewer        = GeoViewer.new(permitted_attributes)
    @geo_viewer.parent = @parent_node

    respond_to do |format|
      if @commit_type == 'preview' && @geo_viewer.valid?
        format.html { render template: 'admin/shared/create_preview', locals: { record: @geo_viewer }, layout: 'admin/admin_preview' }
        format.xml  { render xml: @geo_viewer, status: :created, location: @geo_viewer }
      elsif @commit_type == 'save' && @geo_viewer.save
        format.html { render 'admin/shared/create' }
        format.xml  { head :ok }
      else
        find_available_geo_viewer_placeables
        format.html { render template: 'admin/shared/new', locals: { record: @geo_viewer }, status: :unprocessable_entity }
        format.xml  { render xml: @geo_viewer.errors, status: :unprocessable_entity }
      end
    end
  end

  # * PUT /admin/geo_viewers/:id
  # * PUT /admin/geo_viewers/:id.xml
  def update
    @geo_viewer.attributes = permitted_attributes

    respond_to do |format|
      if @commit_type == 'preview' && @geo_viewer.valid?
        format.html do
          find_images_and_attachments
          render template: 'admin/shared/update_preview', locals: { record: @geo_viewer }, layout: 'admin/admin_preview'
        end
        format.xml  { render xml: @geo_viewer, status: :created, location: @geo_viewer }
      elsif @commit_type == 'save' && @geo_viewer.save
        format.html { render 'admin/shared/update' }
        format.xml  { head :ok }
      else
        find_available_geo_viewer_placeables if @geo_viewer.combined_viewer?
        format.html { render template: 'admin/shared/edit', locals: { record: @geo_viewer }, status: :unprocessable_entity }
        format.xml  { render xml: @geo_viewer.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def permitted_attributes
    params.fetch(:geo_viewer, {}).permit!
  end

  # Finds the +GeoViewer+ object corresponding to the passed in +id+ parameter.
  def find_geo_viewer
    @geo_viewer = GeoViewer.find(params[:id]).current_version
  end

  def find_available_geo_viewer_placeables
    @placeables = @geo_viewer.geo_viewer_placeables.all + (GeoViewer.without_combined - @geo_viewer.geo_viewers - [@geo_viewer]).map { |gv| @geo_viewer.geo_viewer_placeables.build(geo_viewer: gv) }
  end

  def set_default_search_scopes
    @search_scopes.unshift([I18n.t('geo_viewers.filter_settings.parent_section'), "node_#{(@parent_node || @node.parent).id}"]) if @node || @parent_node
    @search_scopes.unshift([I18n.t('geo_viewers.filter_settings.all'), 'all'])
  end

  def filter_parameters_for_viewer_type
    if params[:geo_viewer].try(:[], :combined_viewer) && params[:geo_viewer][:combined_viewer] == '0'
      params[:geo_viewer].delete(:geo_viewer_placeable_attributes)
    end
  end
end
