require "../../spec_helper"

# private abstract class BaseComponent
#   include Lucky::HTMLBuilder

#   needs view : IO::Memory
# end

# private class TestComponentWithArgs < BaseComponent
#   needs title : String

#   def render
#     text "TestComponentWithArgs: #{@title}"
#   end
# end

private class TestMountPage
  include Lucky::HTMLPage

  def render
    with_attrs field: name_field, class: "form-control" do |html|
      html.text_input
    end

    with_attrs field: name_field, class: "form-control" do |html|
      html.text_input placeholder: "Name please"
    end
    @view
  end
end

describe "with_attrs" do
  it "renders the component" do
    contents = TestMountPage.new(build_context).render.to_s

    contents
      .should contain %(<input type="text" id="user_name" name="user:name" value="" class="form-control"/>)
    contents
      .should contain %(<input type="text" id="user_name" name="user:name" value="" class="form-control" placeholder="Name please"/>)
  end
end

private def name_field
  field = LuckyRecord::Field(String).new(
    name: :name,
    param: "",
    value: "",
    form_name: "user"
  )
  LuckyRecord::FillableField.new(field)
end
