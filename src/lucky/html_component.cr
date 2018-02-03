abstract class Lucky::HTMLComponent(T)
  include Lucky::Assignable

  abstract def render

  forward_missing_to @page

  def initialize(@page : T)
  end

  macro setup_initializer_hook
    macro finished
      generate_needy_initializer
    end

    macro included
      setup_initializer_hook
    end

    macro inherited
      setup_initializer_hook
    end
  end

  macro included
    setup_initializer_hook
  end

  macro generate_needy_initializer
    {% if !@type.abstract? %}
      def initialize(
        {% for var, type in ASSIGNS %}
          @{{ var }} : {{ type }},
        {% end %}
        )
      end
    {% end %}
  end
end
