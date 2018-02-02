abstract class Lucky::HTMLComponent(T)
  abstract def render

  forward_missing_to @page

  def initialize(@page : T)
  end

  def perform_render
    render
  end
end
