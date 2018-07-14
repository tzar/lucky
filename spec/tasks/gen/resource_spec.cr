require "../../spec_helper"

include CleanupHelper
include GeneratorHelper

describe Gen::Action do
  it "generates actions, model, form and query" do
    with_cleanup do
      valid_resource_name = "Users"
      io = generate valid_resource_name, Gen::Resource::Browser

      should_create_files_with_contents io,
        "./src/actions/users/index.cr": "class Users::Index < BrowserAction",
        "./src/actions/users/show.cr": "class Users::Show < BrowserAction",
        "./src/actions/users/new.cr": "class Users::New < BrowserAction",
        "./src/actions/users/create.cr": "class Users::Create < BrowserAction",
        "./src/actions/users/edit.cr": "class Users::Edit < BrowserAction",
        "./src/actions/users/update.cr": "class Users::Update < BrowserAction",
        "./src/actions/users/delete.cr": "class Users::Delete < BrowserAction"
      should_create_files_with_contents io,
        "./src/pages/users/index_page.cr": "class Users::IndexPage < MainLayout",
        "./src/pages/users/show_page.cr": "class Users::ShowPage < MainLayout",
        "./src/pages/users/new_page.cr": "class Users::NewPage < MainLayout",
        "./src/pages/users/edit.cr": "class Users::EditPage < MainLayout"
      should_create_files_with_contents io,
        "./src/models/user.cr": "class User < BaseModel",
        "./src/queries/user_query.cr": "class UserQuery < User::BaseQuery",
        "./src/forms/user_form.cr": "class UserForm < User::BaseForm"
      should_generate_migration named: "create_users.cr"
    end
  end

  it "displays an error if given no arguments" do
    io = generate nil, Gen::Resource::Browser

    io.to_s.should contain("Resource name is required.")
  end

  pending "displays an error if given a singular resource" do
    io = generate "User", Gen::Resource::Browser

    io.to_s.should contain("Resource must be pluralized")
  end

  pending "allows forcing generating even if singular" do
  end

  pending "does not accept namespaces resources yet" do
  end
end

private def generate(name, generator : Class)
  ARGV.push(name) if name
  io = IO::Memory.new
  generator.new.call(io)
  io
end

private def should_have_generated(text, inside)
  File.read(inside).should contain(text)
end
