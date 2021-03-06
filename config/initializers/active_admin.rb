module ActiveAdmin
  class Comment < ActiveRecord::Base
    attr_accessible :resource_type, :resource_id, :body
  end
end

module ActiveAdmin::Views::Pages
  class Base
    # Renders the content for the footer
    def build_footer
      "Seller Auction"
    end
  end
end
  
module MetaSearch
  class Builder

    private

    def build_join_dependency(relation)
      buckets = relation.joins_values.group_by do |join|
        case join
        when String
          'string_join'
        when Hash, Symbol, Array
          'association_join'
        when ::ActiveRecord::Associations::JoinDependency::JoinAssociation
          'stashed_join'
        when Arel::Nodes::Join, Squeel::Nodes::Join, Squeel::Nodes::Stub
          'join_node'
        else
          raise 'unknown class: %s' % join.class.name
        end
      end

      association_joins         = buckets['association_join'] || []
      stashed_association_joins = buckets['stashed_join'] || []
      join_nodes                = buckets['join_node'] || []
      string_joins              = (buckets['string_join'] || []).map { |x|
        x.strip
      }.uniq

      join_list = relation.send :custom_join_ast, relation.table.from(relation.table), string_joins

      join_dependency = ::ActiveRecord::Associations::JoinDependency.new(
        relation.klass,
        association_joins,
        join_list
      )

      join_nodes.each do |join|
        join_dependency.alias_tracker.aliased_name_for(join.left.name.downcase)
      end

      join_dependency.graft(*stashed_association_joins)
    end
  end
end

module ActiveAdmin
  module Devise
    class RegistrationsController < ::Devise::RegistrationsController
      include ::ActiveAdmin::Devise::Controller
    end
  end
end

module ActiveAdmin
  module Inputs
    class TimepickerInput < ::Formtastic::Inputs::StringInput
      def input_html_options
        options = super
        options[:class] = [options[:class], "timepicker"].compact.join(' ')
        options
      end
    end
  end
end


ActiveAdmin.setup do |config|

  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = "Seller Auction"

  # Set the link url for the title. For example, to take
  # users to your main site. Defaults to no link.
  #
  config.site_title_link = "/"

  # Set an optional image to be displayed for the header
  # instead of a string (overrides :site_title)
  #
  # Note: Recommended image height is 21px to properly fit in the header
  #
  # config.site_title_image = "/images/logo.png"

  # == Default Namespace
  #
  # Set the default namespace each administration resource
  # will be added to.
  #
  # eg:
  #   config.default_namespace = :hello_world
  #
  # This will create resources in the HelloWorld module and
  # will namespace routes to /hello_world/*
  #
  # To set no namespace by default, use:
  config.default_namespace = false
  #
  # Default:
  # config.default_namespace = :admin
  #
  # You can customize the settings for each namespace by using
  # a namespace block. For example, to change the site title
  # within a namespace:
  #
  #   config.namespace :admin do |admin|
  #     admin.site_title = "Custom Admin Title"
  #   end
  #
  # This will ONLY change the title for the admin section. Other
  # namespaces will continue to use the main "site_title" configuration.

  # == User Authentication
  #
  # Active Admin will automatically call an authentication
  # method in a before filter of all controller actions to
  # ensure that there is a currently logged in admin user.
  #
  # This setting changes the method which Active Admin calls
  # within the controller.
  config.authentication_method = :authenticate_user!


  # == Current User
  #
  # Active Admin will associate actions with the current
  # user performing them.
  #
  # This setting changes the method which Active Admin calls
  # to return the currently logged in user.
  config.current_user_method = :current_user


  # == Logging Out
  #
  # Active Admin displays a logout link on each screen. These
  # settings configure the location and method used for the link.
  #
  # This setting changes the path where the link points to. If it's
  # a string, the strings is used as the path. If it's a Symbol, we
  # will call the method to return the path.
  #
  # Default:
  config.logout_link_path = :destroy_user_session_path

  # This setting changes the http method used when rendering the
  # link. For example :get, :delete, :put, etc..
  #
  # Default:
  # config.logout_link_method = :get


  # == Admin Comments
  #
  # Admin comments allow you to add comments to any model for admin use.
  # Admin comments are enabled by default.
  #
  # Default:
  # config.allow_comments = true
  #
  # You can turn them on and off for any given namespace by using a
  # namespace config block.
  #
  # Eg:
  #   config.namespace :without_comments do |without_comments|
  #     without_comments.allow_comments = false
  #   end


  # == Controller Filters
  #
  # You can add before, after and around filters to all of your
  # Active Admin resources from here.
  #
  # config.before_filter :do_something_awesome


  # == Register Stylesheets & Javascripts
  #
  # We recommend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
  #
  # To load a stylesheet:
  #   config.register_stylesheet 'my_stylesheet.css'
  #
  # You can provide an options hash for more control, which is passed along to stylesheet_link_tag():
  #   config.register_stylesheet 'my_print_stylesheet.css', :media => :print
  #
  # To load a javascript file:
  #   config.register_javascript 'my_javascript.js'
end
