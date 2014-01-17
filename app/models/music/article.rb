module Music
  class Article
    include ActiveModel::Model

    attr_accessor 'file', 'timestamp', 'title', 'artist', 'album', 'year', 'track', 'genre', 'comment', 'length', 'apic'

    validates 'file', 'timestamp', :presence=>true
    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def persisted?
      false
    end
  end
end