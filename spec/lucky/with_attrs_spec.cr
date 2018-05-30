require "../../spec_helper"

private class TestMountPage
  include Lucky::HTMLPage

  def render
    with_attrs field: name_field, class: "form-control" do |html|
      html.text_input
    end

    with_attrs field: name_field, class: "form-control" do |html|
      html.text_input placeholder: "Name please"
    end

    with_attrs field: name_field, placeholder: "default" do |html|
      html.text_input placeholder: "override default"
    end

    with_attrs field: name_field, class: "default" do |html|
      html.text_input class: "default-class-not-overridden"
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
    contents
      .should contain %(<input type="text" id="user_name" name="user:name" value="" placeholder="override default"/>)
    contents
      .should contain %(<input type="text" id="user_name" name="user:name" value="" class="default default-class-not-overridden"/>)
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
