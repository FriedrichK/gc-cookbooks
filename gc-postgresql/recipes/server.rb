package "postgresql93-libs" do	
end

package "postgresql93-devel" do
end

include_recipe 'postgresql::server'