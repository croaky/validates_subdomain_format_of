require File.dirname(__FILE__) + '/test_helper'

class Account < ActiveRecord::Base
  validates_subdomain_format_of :subdomain,
    :on      => :create, 
    :message => 'fails with custom message'
end

class ValidatesSubdomainFormatOfTest < Test::Unit::TestCase

  context 'Typical valid subdomains' do
    should_allow_values  
      ['thoughtbot',
       'dan.croak',              
       'dan+croak',     
       'dan_croak',     
       'dan-croak']                 
  end
  
  context 'Typical invalid subdomains' do
    should_not_allow_values
      ['dancroak.',
       'dancroak_',
       'dancroak-',
       'dan#croak',
       'dan croak']
  end

  context 'invalid subdomain exceeding length limits' do
    should_not_allow_values
      ['aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@example.com',
       'test@aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com']
  end
  
  context 'An invalid account on update' do
    setup do
      @account = Account.new(:subdomain => 'dancroak')
      @account.save
      @account.update_attribute :subdomain, 'dan croak'
    end
      
    should 'pass validation' do
      assert @account.valid?
      assert @account.save
      assert_nil @account.errors.on(:subdomain)
    end
  end

end
