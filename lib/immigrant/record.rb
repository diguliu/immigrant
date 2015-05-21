require 'active_record'

class Immigrant::Record < ActiveRecord::Base
  self.abstract_class = true
  #establish_connection Immigrant.config[:database]

  # You may use some of the following methods to improve the interface's quality.
  #
  # set_table_name :your_entity_table
  # set_inheritance_column :your_entity_type
  # set_primary_key :your_entity_id

  @@entities = []

  def self.entities
    @@entities
  end

  def self.inherited(child)
    super
    @@entities << child
  end

  def self.exceptions
    []
  end

  def memory_namespace
  end

  def migrate
    raise "This method must be overridden by the subclass defining the migration process."
  end

  # Provides the fallback method for any attribute in cases where the value is
  # invalid. Just define the method with the attribute name prefixed by
  # "fallback_".
  #
  # Ex:
  # def fallback_login
  #   "#{self.id}-fixme-"
  # end
  def set_fallback_attributes(record)
    record.errors.keys.each do |attribute|
      next unless self.class.method_defined?("fallback_#{attribute}")
      record.send("#{attribute}=", self.send("fallback_#{attribute}"))
    end
    record
  end

  # Sets the attributes by sending the exact attribute name on the immigrant
  # record. If you want to treat the attribute value or the names doesn't
  # match, you can define a method with the attribute name prefixed with '__';
  # e.g.: for the attibute 'login' you would define a method named '__login'.
  def set_attributes(record, attributes)
    attributes.each do |attribute|
      begin
        value = self.class.method_defined?("__#{attribute}") ? self.send("__#{attribute}") : self.send(attribute)
        record.send("#{attribute}=", value)
      rescue
      end
    end
    record = set_fallback_attributes(record) unless record.valid?
    record
  end

  # Provides a way to create new records with pretreatment and fallback values
  # for attributes. To define the pretreatment just define a method with the
  # attribute name prefixed with "__".
  # Ex:
  # def __login
  #   username.to_slug
  # end
  #
  # If no pretreatment is defined, it'll look for a method with the same name
  # as the attribute.
  #
  # After the treatment, it'll check for invalid attributes and replace them by
  # defined fallback attributes, if defined.
  #
  # Usage: my_user = new_record(User, [:login, :email, :environment])

  def new_record(klass, attributes)
    record = klass.new
    record = set_attributes(record, attributes)
    record
  end

  def create_record(klass, attributes)
    record = new_record(klass, attributes)
    record.save!
    record
  end
end

# Ensure entities are loaded and, therefore, stored on the entities variable.
Dir[File.join(Immigrant.config[:entities_folder], '*.rb')].each {|file| require_dependency file }
