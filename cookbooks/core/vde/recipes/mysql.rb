template "/etc/mysql/conf.d/vde_my.cnf" do
  source "vde_my.cnf.erb"
  mode "0644"
  notifies :restart, "service[mysql]", :delayed
end
