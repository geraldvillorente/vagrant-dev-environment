template "/var/www/index.html" do
  source "vde_help.html.erb"
  variables(
    :sites => node["sites"]
  )
end
