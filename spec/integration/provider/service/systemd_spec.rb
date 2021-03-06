require 'spec_helper'

test_title = 'Integration Tests for Puppet::Type::Service::Provider::Systemd'

describe test_title, unless: Puppet::Util::Platform.jruby? do
  let(:provider_class) { Puppet::Type.type(:service).provider(:systemd) }

  # TODO: Unfortunately there does not seem a way to stub the executable
  #       checks in the systemd provider because they happen at load time.
  it "should be considered suitable if /proc/1/exe is present and points to 'systemd'",
    :if => File.exist?('/proc/1/exe') && Puppet::FileSystem.readlink('/proc/1/exe').include?('systemd') do
    expect(provider_class).to be_suitable
  end

  it "should not be considered suitable if /proc/1/exe is present it does not point to 'systemd'",
    :if => File.exist?('/proc/1/exe') && !Puppet::FileSystem.readlink('/proc/1/exe').include?('systemd') do
    expect(provider_class).not_to be_suitable
  end

  it "should not be considered suitable if /proc/1/exe is absent",
    :if => !File.exist?('/proc/1/exe') do
    expect(provider_class).not_to be_suitable
  end
end
