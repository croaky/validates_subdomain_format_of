$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'active_record'

# Set up database with accounts table, subdomain column

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => "#{File.dirname(__FILE__)}/db/subdomain_format_test.sqlite3")

# Set up Feedback testing framework, a la carte

require 'test/unit'
require 'shoulda'
require "#{File.dirname(__FILE__)}/../init"

class Test::Unit::TestCase #:nodoc:
  
  def self.should_allow_values(*good_values)
    get_options!(good_values)
    good_values.each do |v|
      should "allow subdomain to be set to #{v.inspect}" do
        account = Account.new(:subdomain => v)
        account.save
        assert_nil account.errors.on(:subdomain)
      end
    end
  end

  def self.should_not_allow_values(*bad_values)
    message = get_options!(bad_values, :message)
    message ||= /invalid/
    bad_values.each do |v|
      should "not allow subdomain to be set to #{v.inspect}" do
        account = Account.new(:subdomain => v)
        assert !account.save, "Saved account with subdomain set to \"#{v}\""
        assert account.errors.on(:subdomain), "There are no errors set on subdomain after being set to \"#{v}\""
      end
    end
  end
  
  def self.get_options!(args, *wanted)
    ret  = []
    opts = (args.last.is_a?(Hash) ? args.pop : {})
    wanted.each {|w| ret << opts.delete(w)}
    raise ArgumentError, "Unsuported options given: #{opts.keys.join(', ')}" unless opts.keys.empty?
    return *ret
  end
  
end
