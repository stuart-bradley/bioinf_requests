module RequestsHelper
  def sanatize_wysihtml text
    allowed_tags = (Loofah::HTML5::WhiteList::ALLOWED_ELEMENTS_WITH_LIBXML2.add(%w['u','font']))
    default_attributes = Loofah::HTML5::WhiteList::ALLOWED_ATTRIBUTES.add('face')
    utf8_text = text.to_s.force_encoding("UTF-8")
    sanitize utf8_text, tags: allowed_tags, attributes: default_attributes
  end
end
