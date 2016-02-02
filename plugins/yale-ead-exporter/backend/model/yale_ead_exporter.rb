require 'nokogiri'
require 'securerandom'

class EADSerializer < ASpaceExport::Serializer
    serializer_for :ead

    def serialize_container(inst, xml, fragments)
      containers = []
      @parent_id = nil
      (1..3).each do |n|
        atts = {}
        next unless inst['container'].has_key?("type_#{n}") && inst['container'].has_key?("indicator_#{n}") 
        @container_id = prefix_id(SecureRandom.hex)
        atts[:parent] = @parent_id unless @parent_id.nil?
        atts[:id] = @container_id
        @parent_id = @container_id
        atts[:type] = inst['container']["type_#{n}"]
        text = inst['container']["indicator_#{n}"]
        if n == 1 && inst['instance_type']
          if inst["container"]["barcode_1"]
            atts[:label] = I18n.t("enumerations.instance_instance_type.#{inst['instance_type']}", :default => inst['instance_type']) + "|" + inst["container"]["barcode_1"] 
          else
            atts[:label] = I18n.t("enumerations.instance_instance_type.#{inst['instance_type']}", :default => inst['instance_type'])
          end
        end
        xml.container(atts) { sanitize_mixed_content(text, xml, fragments)  }
      end
    end
    



end
