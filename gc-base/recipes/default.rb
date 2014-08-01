execute 'sudo yum groupinstall -y "Development Tools"' do
end

package "mlocate" do	
end

cookbook_file "gamecoach-machine" do
	path "#{node["gc-base"]["home_dir"]}/.ssh/id_rsa"
	owner node["gc-base"]["user"]
	group node["gc-base"]["group"]
	mode 00600
	action :create_if_missing
end

file "#{node["gc-base"]["home_dir"]}/.ssh/config" do
	content <<-EOF
Host *github.com
	StrictHostKeyChecking no
	User git
	IdentityFile #{node['gc-base']['home_dir']}/.ssh/id_rsa
	EOF
	owner node["gc-base"]["user"]
	group node["gc-base"]["group"]
	mode 00600
end