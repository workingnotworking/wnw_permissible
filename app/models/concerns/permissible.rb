module Permissible
  extend ActiveSupport::Concern

  PERMISSIBLE_PERMISSION_METHOD_REGEX = /^can_(.*)\?$/
  PERMISSIBLE_ROLE_METHOD_REGEX = /\?$/

  included do
    has_many :authorizations, :as => :authorizable, :dependent => :destroy
    has_many :roles,          :through => :authorizations
    has_many :role_limits,    :through => :roles
  end

  def method_missing(method_id, *args)
    case
    when _permission_match?(method_id)
      return has_permission?(_method_to_permission_name(method_id))
    when _role_match?(method_id)
      _role_check_warning(method_id)
      return has_role?(_method_to_role_name(method_id))
    else
      super
    end
  end

  def respond_to_missing?(method_id, *args)
    _permission_match?(method_id) or
      _role_match?(method_id) or
      super
  end

  # list of permissions granted by roles, as :symbols
  def permissions
    @permissions ||= _permission_names_for_roles(roles).sort
  end

  def has_permission?(name)
    permissions.include?(name)
  end

  def has_role?(name)
    roles.where(:name => name).any?
  end

  def role_names
    roles.pluck(:name)
  end

  # since a user can have multiple roles, take the max value of their limits:
  #
  #   user.limit(:searches) #=> 8
  def limit(attribute)
    role_limits.pluck(attribute).max
  end

  # is method in the form of `can_something?`
  private def _permission_match?(name)
    !!(name.to_s =~ PERMISSIBLE_PERMISSION_METHOD_REGEX)
  end

  # is method in the form of `role?`
  private def _role_match?(name)
    name.to_s.match(PERMISSIBLE_ROLE_METHOD_REGEX) and
      Role.where(:name => name.to_s.chop).any?
  end

  # converts a permission method check into a name: :can_do_this? => :do_this
  private def _method_to_permission_name(name)
    name.to_s.match(PERMISSIBLE_PERMISSION_METHOD_REGEX)[1].to_sym
  end

  # convers a role method check into a name: :admin? => 'admin'
  private def _method_to_role_name(name)
    name.to_s.chop
  end

  # Outputs a warning in the Rails log if a check for a user's role is found.
  # The best practice is to only check if someone can do something, not if they
  # have a certain title:
  # http://programmers.stackexchange.com/questions/299729/role-vs-permission-based-access-control
  private def _role_check_warning(method_id)
    if Rails.env.development? or Rails.env.test?
      position = caller.at(1).sub(%r{.*/},'').sub(%r{:in\s.*},'')
      Rails.logger.warn "\033[0;33m  WARNING: You should really be checking for individual permissions, not roles! #{self.class.name.to_s}##{method_id.to_s} called from #{position}"
    end
  end

  # returns an array of symbols with the permission names granted by the given
  # role(s)
  private def _permission_names_for_roles(roles)
    RolePermission.joins(:permission).where(:role_id => roles).distinct
      .pluck(Permission.arel_table[:name]).collect(&:to_sym)
  end

end
