abstract class Lucky::HTMLComponent(T)
  include Lucky::Assignable

  abstract def render

  forward_missing_to @page

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

  macro inherited
    setup_initializer_hook
  end

  macro generate_needy_initializer
    {% if !@type.abstract? %}
      def initialize(
        @page : T,
        {% for var, type in ASSIGNS %}
          @{{ var }} : {{ type }},
        {% end %}
        )
      end
    {% end %}
  end
end
