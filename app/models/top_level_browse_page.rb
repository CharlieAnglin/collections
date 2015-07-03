class TopLevelBrowsePage
  attr_reader :slug

  delegate :title, :description, to: :content_store_item

  def initialize(slug)
    @slug = slug
  end

  def slimmer_breadcrumb_options
    {}
  end

  def second_level_browse_pages
    content_store_item.links.second_level_browse_pages
  end

  def top_level_browse_pages
    content_store_item.links.top_level_browse_pages
  end

  def base_path
    "/browse/#{slug}"
  end

private

  def content_store_item
    @content_store_item ||= ContentItem.find!(base_path)
  end
end
