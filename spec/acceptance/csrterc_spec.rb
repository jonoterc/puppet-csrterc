require 'spec_helper_acceptance'

describe 'csrterc class' do

  context 'standard include' do
    it 'should work with no errors' do
      pp = default_manifest + <<-EOS
        class { 'csrterc': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
  end

end
