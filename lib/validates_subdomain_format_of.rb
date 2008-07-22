require 'addressable/uri'

module ActiveRecord
  module Validations
    module ClassMethods
      # Validates whether the value of the specified attribute is a valid subdomain
      #
      #   class User < ActiveRecord::Base
      #     validates_subdomain_format_of :subdomain
      #   end
      #
      # Configuration options:
      # * <tt>message</tt> - A custom error message (default is: " does not appear to be a valid subdomain")
      # * <tt>on</tt> - Specifies when this validation is active (default is :save, other options :create, :update)
      # * <tt>allow_nil</tt> - Allow nil values (default is false)
      # * <tt>allow_blank</tt> - Allow blank values (default is false)
      # * <tt>if</tt> - Specifies a method, proc or string to call to determine if the validation should
      #   occur (e.g. :if => :allow_validation, or :if => Proc.new { |user| user.signup_step > 2 }).  The
      #   method, proc or string should return or evaluate to a true or false value.
      # * <tt>unless</tt> - See <tt>:if</tt>
      def validates_subdomain_format_of(*attr_names)
        options = { :message => ' is not a valid subdomain', 
                    :on => :save, 
                    :allow_nil => false,
                    :allow_blank => false }

        options.update(attr_names.pop) if attr_names.last.is_a?(Hash)

        validates_each(attr_names, options) do |record, attr_name, value|
          v = value.to_s

          begin
            uri = Addressable::URI.parse "http://#{v}.thoughtbot.com"
          rescue Addressable::URI::InvalidURIError
            record.errors.add(attr, 'The format of the subdomain is not valid.')
          end
        end
      end
    end   
  end
end
