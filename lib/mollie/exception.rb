module Mollie
  class Exception < StandardError
  end

  class RequestError < Mollie::Exception
    attr_accessor :status, :title, :detail, :field, :links

    def initialize(error, response = nil)
      exception.status = error['status']
      exception.title  = error['title']
      exception.detail = error['detail']
      exception.field  = error['field']
      exception.links  = error['_links']
      self.response = response
    end

    def to_s
      "#{status} #{title}: #{detail}"
    end

    def http_headers
      response.to_hash if response
    end

    def http_body
      response.body if response
    end

    private

    attr_accessor :response
  end

  class ResourceNotFoundError < RequestError
  end
end
