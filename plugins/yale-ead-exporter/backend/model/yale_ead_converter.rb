class YaleEADConverter < EADConverter

  def self.import_types(show_hidden = false)
    [
     {
       :name => "yale_ead_xml",
       :description => "Import Yale EAD records from an XML file"
     }
    ]
  end


  def self.instance_for(type, input_file)
    if type == "yale_ead_xml"
      self.new(input_file)
    else
      nil
    end
  end

  def self.profile
    "Convert EAD To ArchivesSpace JSONModel records"
  end

  def self.configure
    super

    with 'container' do

      if context_obj.instances.empty?
        make :instance, {
          :instance_type => 'mixed_materials'
        } do |instance|
          set ancestor(:resource, :archival_object), :instances, instance
        end
      end

      inst = context == :instance ? context_obj : context_obj.instances.last
      
      
      if inst.container.nil?
        make :container do |cont|
          set inst, :container, cont
        end
      end

      cont = inst.container || context_obj
      
      if att('label') && att('label').include?("|")
        inst_type, barcode = att('label').split("|")
        cont["barcode_1"] = barcode
        inst["instance_type"] = inst_type
      end
      

      (1..3).to_a.each do |i|
        next unless cont["type_#{i}"].nil?
        cont["type_#{i}"] = att('type').strip
        cont["indicator_#{i}"] = inner_xml
            
        if cont["indicator_#{i}"].length == 0
          cont["indicator_#{i}"] = 'BLANK'
        end
        break
      end
    end

  end
end
