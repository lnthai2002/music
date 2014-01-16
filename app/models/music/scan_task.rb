module Music
  class ScanTask
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    #TODO: recursive should be boolean
    attr_accessor 'host', 'folder', 'recursive'

    validates 'host', 'folder', :presence=>true
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