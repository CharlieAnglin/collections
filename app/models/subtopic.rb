class Subtopic
  delegate :description, :title, :details, to: :data
  delegate :documents_total, :documents_start, :beta, to: :details
  alias :beta? :beta

  def self.find(slug, api_options = {})
    collections_api = Collections.services(:collections_api)

    if (collections_api_response = collections_api.topic("/#{slug}", filtered_api_options(api_options)))
      new(slug, collections_api_response)
    else
      nil
    end
  end

  def initialize(slug, data)
    @slug = slug
    @data = data
  end

  attr_reader :slug

  def groups
    details.groups
  end

  def changed_documents
    details.documents
  end

  def parent_topic
    data.parent
  end

  def parent_topic_title
    parent_topic.title
  end

  def parent_slug
    split_slug[0]
  end

  def child_slug
    split_slug[1]
  end

  def combined_title
    "#{parent_topic_title}: #{title}"
  end

private

  attr_reader :data

  def split_slug
    slug.split('/')
  end

  def self.filtered_api_options(options)
    options.slice(:start, :count).reject {|_,v| v.blank? }
  end
end
