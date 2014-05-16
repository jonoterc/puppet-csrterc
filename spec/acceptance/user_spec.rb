require 'spec_helper_acceptance'

describe 'user class' do

  context 'standard include' do
    it 'should work with no errors' do
      pp = default_manifest + <<-EOS
        csrterc::user { 'dave':
          hashed_password   => '$6$AiO5XZYT$71pQRC5qGrkHbe6hFhHQcrkpmrz2U7tqXJKQ/2PR5CLOd/Clr9tI/BVbxfDONzByyrf3GBvCvuellN/CwkH7I0' ,
          plaintext_password => '12345' , 
          group_name         => 'sudo' , 
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
  end

end
