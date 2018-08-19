module Mollie
  module Util
    module_function

    def nested_underscore_keys(obj)
      if obj.is_a?(Hash)
        obj.each_with_object({}) do |(key, value), underscored|
          underscored[underscore(key)] = nested_underscore_keys(value)
        end
      elsif obj.is_a?(Array)
        obj.map { |v| nested_underscore_keys(v) }
      else
        obj
      end
    end

    def camelize_keys(hash)
      hash.each_with_object({}) do |(key, value), camelized|
        camelized[camelize(key)] = value
      end
    end

    def underscore(string)
      string.to_s.gsub(/::/, '/')
            .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .tr('-', '_')
            .downcase.to_s
    end

    # Dirty pluralize function, but currently holds for all required plurals
    # Not worth to include another library like ActiveSupport
    def pluralize(string)
      "#{string}s"
    end

    def camelize(term)
      string = term.to_s
      string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/, &:downcase)
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}" }
      string.gsub!('/'.freeze, '::'.freeze)
      string
    end

    def nested_openstruct(obj)
      if obj.is_a?(Hash)
        obj.each_with_object(OpenStruct.new) do |(key, value), openstructed|
          openstructed[key] = nested_openstruct(value)
        end
      elsif obj.is_a?(Array)
        obj.map { |v| nested_openstruct(v) }
      else
        obj
      end
    end

    def extract_url(links, type)
      links && links[type] && links[type]['href']
    end

    def extract_id(links, type)
      href = extract_url(links, type)
      return if href.nil?
      uri = URI.parse(href)
      File.basename(uri.path)
    end
  end
end
