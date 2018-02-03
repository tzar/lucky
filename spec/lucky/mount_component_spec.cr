require "../../spec_helper"

include ContextHelper

private class FancyUserRow(T) < Lucky::HTMLComponent(T)
  def render
    fancy_html_from_page_class { text "fancy row" }
  end
end

private class UserRowWithNeeds(T) < Lucky::HTMLComponent(T)
  needs custom_text : String

  def render
    fancy_html_from_page_class { text @custom_text }
  end
end

private class PageWithComponent
  include Lucky::HTMLPage

  def render
    mount FancyUserRow
  end

  def fancy_html_from_page_class
    div class: "so-fancy" do
      yield
    end
  end
end

private class PageWithComponentThatHasArgs < PageWithComponent
  def render
    mount UserRowWithNeeds, custom_text: "much custom"
  end
end

describe "mounting components" do
  it "renders components that have no arguments" do
    view.render.to_s.should contain "fancy row"
    view.render.to_s.should contain "so-fancy"
  end

  it "renders components with arguments" do
    view_with_arguments.render.to_s.should contain "much custom"
    view_with_arguments.render.to_s.should contain "so-fancy"
  end
end

private def view
  PageWithComponent.new(build_context)
end

private def view_with_arguments
  PageWithComponentThatHasArgs.new(build_context)
end
