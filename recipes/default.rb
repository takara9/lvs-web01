#
# Cookbook Name:: lvs-web01
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
#


case node['platform']
# === Debian系 ===
when 'ubuntu','debian'

  execute 'apt-get update' do
    command 'apt-get update'
    ignore_failure true
  end

  # ファイアウォールの設定
  execute 'ufw_for_http' do
    command "/usr/sbin/ufw allow #{node['virtual_portno1']}"
    ignore_failure true
  end

  # 追加パッケージ
  %w{
    ufw
  }.each do |pkgname|
    package "#{pkgname}" do
      action :install
    end
  end

  template "/etc/network/interfaces.d/lo:1" do
    source 'lo:1.erb'
    owner "root"
    group "root"
    mode 0644
    action :create
    variables({
      :vip1 => node["virtual_ipaddress1"],
    })
  end

  #
  # /etc/network/interfaces に１行追加
  #
  ruby_block 'edit_interfaces' do
    block do
      file = "/etc/network/interfaces"
      line = "\nsource interfaces.d/lo:1\n"
      if (`grep "^source" #{file}`.size == 0) then
        File::open(file, "a") do |f|
          f.write "#{line}"
        end
      end
    end
    action :run
  end
  

# === RedHat系 ===
when 'centos','redhat'

  execute 'yum update' do
    command 'yum update -y'
    action :run
  end

  service "iptables" do
    action [ :enable, :start]
  end

  # ファイアウォールの設定
  template "/etc/sysconfig/iptables" do
    source "iptables.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      :lvs_subnet => node['public_prim_subnet'],
    })
    action :create
  end

  # 設定の有効化
  execute 'iptables-restore' do
    command 'iptables-restore < /etc/sysconfig/iptables'
    action :run
  end

  # 追加パッケージ
  %w{
    
  }.each do |pkgname|
    package "#{pkgname}" do
      action :install
    end
  end
end



#
# カーネルパラメータの変更
#
execute 'sysctl' do
  command '/sbin/sysctl -p'
  action :nothing
end

template "/etc/sysctl.conf" do
  source 'sysctl.conf.erb'
  owner "root"
  group "root"
  mode 0644
  action :create
  notifies :run, 'execute[sysctl]', :immediately
  ignore_failure true
end
