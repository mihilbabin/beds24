require 'nokogiri'

class Hash
  class << self
    def from_xml(xml_io)
      result = Nokogiri::XML(xml_io)
      { result.root.name => xml_node_to_hash(result.root)}
    end

    def xml_node_to_hash(node)
      if node.element?
        result_hash = {}
        if node.attributes != {}
          attributes = {}
          node.attributes.keys.each do |key|
            if [:id, 'id', :name, 'name'].include?(key)
              node.name = node.attributes[key].value
              node.delete(key.to_s)
            else
              attributes[node.attributes[key].name] = node.attributes[key].value
            end
          end
        end

        if node.children.size > 0
          node.children.each do |child|
            result = xml_node_to_hash(child)

            if child.name == 'text'
              unless child.next_sibling || child.previous_sibling
                return result unless attributes
                result_hash[child.name] = result
              end
            elsif result_hash[child.name]
              if result_hash[child.name].is_a?(Array)
                 result_hash[child.name] << result
              else
                 result_hash[child.name] = [result_hash[child.name]] << result
              end
            else
              result_hash[child.name] = result
            end
          end
          if attributes
            result_hash = attributes.merge(result_hash)
          end
          return result_hash
        else
          return attributes
        end
      else
        node.content.to_s
      end
    end
  end
end