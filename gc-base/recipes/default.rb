package "mlocate" do	
end

cookbook_file "gamecoach-machine" do
	path "/home/vagrant/.ssh/id_rsa"
	owner "vagrant"
	group "vagrant"
	mode 00600
	action :create_if_missing
end

file "/home/vagrant/.ssh/config" do
	content <<-EOF
Host *github.com
	StrictHostKeyChecking no
	User git
	IdentityFile /home/vagrant/.ssh/id_rsa
	EOF
	owner "vagrant"
	group "vagrant"
	mode 00600
end