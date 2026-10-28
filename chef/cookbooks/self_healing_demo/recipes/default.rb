package 'docker' do
  action :install
end

service 'docker' do
  supports status: true, restart: true
  action [:enable, :start]
end

directory '/opt/self-healing-demo' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Assumes the image has already been built or pulled onto the node.
execute 'run_self_healing_demo_container' do
  command <<~CMD
    docker rm -f #{node['self_healing_demo']['container_name']} >/dev/null 2>&1 || true
    docker run -d --restart unless-stopped \
      --name #{node['self_healing_demo']['container_name']} \
      -p #{node['self_healing_demo']['host_port']}:#{node['self_healing_demo']['container_port']} \
      #{node['self_healing_demo']['image']}
  CMD
  not_if "docker ps --filter name=#{node['self_healing_demo']['container_name']} --filter status=running --quiet | grep -q ."
end
