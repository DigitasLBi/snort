require_relative '../spec_helper'

describe 'snort::default' do

  let(:snort_run) do
        runner = ChefSpec::Runner.new(platform:'redhat', version:'6.5') do |node|
  
        env = Chef::Environment.new
        env.name 'default'

        allow(Chef::Environment).to receive(:load).and_return(env)

        allow(node).to receive(:chef_environment).and_return(env.name)
      end

    Chef::Config[:file_cache_path] = "/var/chef/cache"

    runner.converge(described_recipe,"recipe[snort::default]")
  end

  it "Install snort" do
    expect(snort_run).to create_yum_repository("epel")
    expect(snort_run).to install_yum_package("libdnet")
    
  #  expect(snort_run).to install_yum_package("/var/chef/cache/daq.rpm")
  #  expect(snort_run).to install_yum_package("/var/chef/cache/snort.rpm")
  end

  it "Install snort template" do
    expect(snort_run).to create_template("/etc/snort/snort.conf")
  end

  it "start snort service" do
    expect(snort_run).to create_template("/etc/init.d/snortd")
    expect(snort_run).to start_service("snortd")
  end
end