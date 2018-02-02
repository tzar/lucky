require "../../spec_helper"

include ContextHelper

private class FancyUserRow(T) < Lucky::HTMLComponent(T)
  def render
    fancy_html { text "fancy row" }
  end
end

private class PageWithComponent
  include Lucky::HTMLPage

  def render
    mount FancyUserRow
  end

  def fancy_html
    div class: "so-fancy" do
      yield
    end
  end
end

describe "mounting components" do
  it "renders components that have no arguments" do
    view.render.to_s.should contain "fancy row"
    view.render.to_s.should contain "so-fancy"
  end
end

private def view
  PageWithComponent.new(build_context)
end
