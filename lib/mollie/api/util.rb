module Util
  extend self

  def nested_underscore_keys(hash)
    hash.each_with_object({}) do |(key, value), underscored|
      if value.is_a?(Hash)
        underscored[underscore(key)] = nested_underscore_keys(value)
      elsif value.is_a?(Array)
        underscored[underscore(key)] = value.map { |v| nested_underscore_keys(v) }
      else
        underscored[underscore(key)] = value
      end
    end
  end

  def camelize_keys(hash)
    hash.each_with_object({}) do |(key, value), camelized|
      camelized[camelize(key)] = value
    end
  end

  def underscore(string)
    string.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr("-", "_").
        downcase.to_s
  end

  def camelize(term)
    string = term.to_s
    string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { |match| match.downcase }
    string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
    string.gsub!('/'.freeze, '::'.freeze)
    string
  end
end
