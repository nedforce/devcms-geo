extension_of DevcmsCore

class Devcms

  class << self
    # Overrides for ContentType configurations
    def content_types_configuration
      {
        'Section' => {
          :allowed_child_content_types => %w(
            AlphabeticIndex Attachment AttachmentTheme Calendar Carrousel CombinedCalendar ContactBox ContactForm Feed Forum GeoViewer
            HtmlPage Image LinksBox InternalLink ExternalLink NewsArchive NewsletterArchive NewsViewer
            Page Poll SearchPage Section SocialMediaLinksBox WeblogArchive
          ),
          :allowed_roles_for_create  => %w( admin final_editor ),
          :allowed_roles_for_destroy => %w( admin final_editor ),
          :has_content_box_representation => true,
          :has_own_content_box => true
        },
        'Site' => {
          :allowed_child_content_types => %w(
            AlphabeticIndex Attachment AttachmentTheme Calendar Carrousel CombinedCalendar ContactBox ContactForm Feed Forum GeoViewer
            HtmlPage Image LinksBox InternalLink ExternalLink NewsArchive NewsletterArchive NewsViewer
            Page Poll SearchPage Section Site SocialMediaLinksBox WeblogArchive
          ),
          :allowed_roles_for_create  => %w( admin ),
          :allowed_roles_for_update  => %w( admin ),
          :allowed_roles_for_destroy => %w( admin ),
          :has_content_box_representation => true,
          :has_own_content_box => true,
          :controller_name => 'sites',
          :show_in_menu => false,
          :copyable => false
        }
      }
    end
  end
end
