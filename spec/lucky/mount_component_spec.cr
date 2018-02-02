require "../../spec_helper"

include ContextHelper

private class FancyUserRow(T) < Lucky::HTMLComponent(T)
  def render
    text "fancy row"
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
    view.render.to_s.should eq "fancy row"
  end
end

private def view
  PageWithComponent.new(build_context)
end
