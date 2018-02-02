require "../../spec_helper"

include ContextHelper

private abstract class MainLayout
  include Lucky::HTMLPage

  def render
    render_if_defined :sidebar
  end
end

private class PageWithSidebar < MainLayout
  def sidebar
    text "In the sidebar"
  end
end

describe "mounting components" do
  it "renders the component and passes in the args" do
  end
end

private def view
  TestRender.new(build_context)
end
