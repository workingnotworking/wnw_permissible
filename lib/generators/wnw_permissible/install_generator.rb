# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module WnwPermissible
  # Installs PaperTrail in a rails app.
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    MODELS = ['role', 'permission','role_permission', 'role_limit', 'authorization']

    source_root File.expand_path("templates", __dir__)
    class_option(
      :with_changes,
      :type => :boolean,
      :default => false,
      :desc => "Store changeset (diff) with each version"
    )

    desc "Generates (but does not run) a migration to add a required tables."

    def create_model_files
      MODELS.each do |model|
        if File.exist? File.join(destination_root,'app','models',"#{model}.rb")
          ::Kernel.warn "Migration already exists: #{model}.rb"
        else
          template "model.rb.erb", "app/models/#{model}.rb", :model => model
        end
      end
    end

    def create_migration_files
      migration_dir = File.expand_path("db/migrate")

      MODELS.each do |template|
        template_name = "create_#{template.pluralize}"
        if self.class.migration_exists?(migration_dir, template_name)
          ::Kernel.warn "Migration already exists: #{template_name}"
        else
          migration_template(
            "#{template_name}.rb.erb",
            "db/migrate/#{template_name}.rb",
            :migration_version => migration_version
          )
        end
      end
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def migration_version
      major = ActiveRecord::VERSION::MAJOR
      if major >= 5
        "[#{major}.#{ActiveRecord::VERSION::MINOR}]"
      end
    end

  end
end
