module Mollie
  class Exception < StandardError
  end

  class RequestError < Exception
    attr_accessor :status, :title, :detail, :field, :links

    def initialize(error)
      exception.status = error['status']
      exception.title  = error['title']
      exception.detail = error['detail']
      exception.field  = error['field']
      exception.links  = error['_links']
    end

    def to_s
      "#{status} #{title}: #{detail}"
    end
  end
end
