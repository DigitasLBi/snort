require 'spec_helper'

describe 'snort::default' do

  let(:snort_repo_run) do
        runner = ChefSpec::Runner.new(platform:'redhat', version:'6.5') do |node|
  
        env = Chef::Environment.new
        env.name 'default'
          env.default_attributes = {
          "snort_yum_repo" => true
        }

        allow(Chef::Environment).to receive(:load).and_return(env)

        allow(node).to receive(:chef_environment).and_return(env.name)
      end

    Chef::Config[:file_cache_path] = '/var/chef/cache'

    runner.converge(described_recipe,"recipe[snort::default]")
  end

  it "adds new yum repo" do
    expect(snort_repo_run).to create_yum_repository("name")
  end

  it "install snort.x86_64 package from repo" do
    expect(snort_repo_run).to install_yum_package("snort.x86_64")
  end
end