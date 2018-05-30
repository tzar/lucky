module Lucky::WithAttrs
  def with_attrs(**named_args)
    OptionMerger.new(context: self, named_args: named_args).run do |html|
      yield html
    end
  end

  class OptionMerger(T, V)
    def initialize(@context : T, @named_args : V)
    end

    def run
      yield self
    end

    macro method_missing(call)
      args = @named_args{% if call.named_args %}.merge(
        {% for key, value in call.named_args %}
          {{ key }},
        {% end %}
      )
      {% end %}
      @context.{{ call.name }} **args
    end
  end
end
