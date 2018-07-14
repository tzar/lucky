require "lucky_cli"
require "teeplate"
require "lucky_inflector"

class Lucky::GeneratedColumn
  def initialize(@name : String, @type : String)
  end
end

class Lucky::ResourceTemplate < Teeplate::FileTree
  directory "#{__DIR__}/templates/resource/"

  getter resource, columns

  def initialize(@resource : String, @columns : Array(Lucky::GeneratedColumn))
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

  private def form_filename
    form_class.underscore + ".cr"
  end

  private def query_filename
    query_class.underscore + ".cr"
  end
end

class Gen::Model < LuckyCli::Task
  banner "Generate a resource (model, form, query, actions, and pages)"
  getter io : IO = STDOUT

  def call(@io : IO = STDOUT)
    if valid?
      Lucky::ResourceTemplate.new(resource_name, columns).render("./src/")
      # display_success_messages
    else
      io.puts @error.colorize(:red)
    end
  end

  private def columns : Lucky::GeneratedColumn
    column_definitions.map do |column_definition|
      column_name, column_type = column_definition.split(":")
      Lucky::GeneratedColumn.new(name: column_name, type: column_type)
    end
  end

  private def valid?
    resource_name_is_present? && resource_name_is_camelcase && has_valid_columns?
  end

  private def has_valid_columns? : Bool
    @error = "Must provide valid columns for the resource: lucky gen.resource.browser #{resource.camelcase} name:String"
    columns_from_args = ARGV[1]?
    if columns_from_args
      column_definitions.all? do |column_definition|
        column_name, column_type = column_definition.split(":")
        column_definition.split(":").size == 2 &&
          column_name == column_name.underscore
      end
    else
      false
    end
  end

  private def column_definitions
    ARGV.skip(1)
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
