require "../../spec_helper"

include ContextHelper

private class FancyUserRow
  include Lucky::HTMLComponent

  def render
  end
end

private class PageWithComponent
  include Lucky::HTMLPage

  def render
    mount FancyUserRow
  end
end

describe "mounting components" do
  it "renders components that have no arguments" do
    view.render
  end
end

private def view
  PageWithComponent.new(build_context)
end
