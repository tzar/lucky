require "lucky_cli"
require "teeplate"
require "lucky_inflector"

class Lucky::ResourceTemplate < Teeplate::FileTree
  directory "#{__DIR__}/templates/resource/"

  getter resource

  def initialize(@resource : String)
  end

  private def pluralized_resource
    LuckyInflector::Inflector.pluralize(resource)
  end

  private def folder_name
    pluralized_resource.underscore
  end

  private def underscored_resource
    @resource.underscore
  end

  private def query_class
    "#{resource}Query"
  end

  private def form_class
    "#{resource}Form"
  end
end

class Gen::Model < LuckyCli::Task
  banner "Generate a resource (model, form, query, actions, and pages)"
  getter io : IO = STDOUT

  def call(@io : IO = STDOUT)
    if valid?
      Lucky::ResourceTemplate.new(resource_name).render("./src/")
      # display_success_messages
    else
      io.puts @error.colorize(:red)
    end
  end

  private def valid?
    resource_name_is_present? && resource_name_is_camelcase
  end

  private def resource_name_is_present?
    @error = "Resource name is required. Example: lucky gen.resource.browser User"
    ARGV.first?
  end

  private def resource_name_is_camelcase
    @error = "Resource name should be camel case. Example: lucky gen.resource.browser #{resource.camelcase}"
    resource_name.camelcase == resource_name
  end

  private def display_success_messages
    io.puts success_message("./src/models/#{underscored_name}.cr")
    io.puts success_message("./src/forms/#{underscored_name}_form.cr", "Form")
    io.puts success_message("./src/queries/#{underscored_name}_query.cr", "Query")
  end

  private def success_message(filename, type = nil)
    "Generated #{resource_name.colorize(:green)}#{type.colorize(:green)} in #{filename.colorize(:green)}"
  end

  private def resource_name
    ARGV.first
  end
end
