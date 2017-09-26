module Mollie
  class Relation
    def initialize(parent, klass)
      @parent = parent
      @klass = klass
    end

    def all(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      args.push(enhance(options))
      @klass.all(*args)
    end

    def get(id, options = {})
      @klass.get(id, enhance(options))
    end

    def update(id, data = {})
      @klass.update(id, enhance(data))
    end

    def create(data = {})
      @klass.create(enhance(data))
    end

    def delete(id, options = {})
      @klass.delete(id, enhance(options))
    end

    private

    def enhance(data = {})
      data.merge(@parent.class.id_param => @parent.id)
    end
  end
end
