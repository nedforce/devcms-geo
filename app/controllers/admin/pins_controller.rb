class Admin::PinsController < Admin::AdminController
  layout false

  require_role %w(admin final_editor)

  def index
  end

  def create
    @pin = Pin.new(permitted_attributes)

    respond_to do |format|
      format.js do
        responds_to_parent do |page|
          if @pin.save
            page.replace_html 'pins', partial: 'pins'
          else
            page.call 'Ext.Msg.alert', I18n.t('pins.create_failed_title'), I18n.t('pins.create_failed', errors: @pin.errors.full_messages.to_sentence)
          end
        end
      end
    end
  end

  def destroy
    @pin = Pin.find(params[:id])

    respond_to do |format|
      format.js do
        render :update do |page|
          if @pin.destroy
            page.replace_html 'pins', partial: 'pins'
          else
            page.call 'Ext.Msg.alert', I18n.t('pins.destroy_failed_title'), I18n.t('pins.destroy_failed', errors: @pin.errors.full_messages.to_sentence)
          end
        end
      end
    end
  end

  protected

  def permitted_attributes
    params.fetch(:pin, {}).permit!
  end

end
