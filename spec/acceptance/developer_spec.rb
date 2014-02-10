require 'spec_helper_acceptance'

describe 'developer class' do

  context 'standard include' do
    it 'should work with no errors' do
      pp = default_manifest + <<-EOS
        csrterc::developer { 'dave':
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
