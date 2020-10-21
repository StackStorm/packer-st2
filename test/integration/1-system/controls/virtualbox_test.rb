# encoding: utf-8
# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

KERNEL_MODULES = %w(
  vboxsf vboxguest
).freeze

control 'vbox-guest-additions' do
  title 'Verify Virtualbox guest additions'
  desc '
    Install guest additions into the OVA, so full screen resolution,
    clipboard, and mouse pointer work. See the following for more info:
      https://www.virtualbox.org/manual/ch04.html#idm1873
  '

  KERNEL_MODULES.each do |module_name|
    describe kernel_module(module_name) do
      it { should be_loaded }
      it { should_not be_disabled }
      it { should_not be_blacklisted }
    end
  end

  describe processes('VBoxService') do
    it { should exist }
  end
end
