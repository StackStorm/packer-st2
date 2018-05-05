# encoding: utf-8
# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

control 'vbox-guest-additions' do
  title 'Verify Virtualbox guest additions'
  desc '
    Install guest additions into the OVA, so full screen resolution,
    clipboard, and mouse pointer work. See the following for more info:
      https://www.virtualbox.org/manual/ch04.html#idm1873
  '

  describe kernel_module('vboxvideo') do
    it { should be_loaded }
    it { should_not be_disabled }
    it { should_not be_blacklisted }
  end

  describe kernel_module('vboxsf') do
    it { should be_loaded }
    it { should_not be_disabled }
    it { should_not be_blacklisted }
  end

  describe kernel_module('vboxguest') do
    it { should be_loaded }
    it { should_not be_disabled }
    it { should_not be_blacklisted }
  end

  describe processes('VBoxService') do
    it { should exist }
  end
end
