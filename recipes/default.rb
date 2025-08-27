#
# Cookbook:: cr_teamviewer
# Recipe:: default
#
# Copyright:: 2025, The Authors, All Rights Reserved.

if platform_family?('mac_os_x')
  tmp_file = "#{Chef::Config['file_cache_path']}/TeamViewer.dmg"
  dmg_package 'TeamViewer.dmg' do
    source tmp_file
    accept_eula true
    action :nothing
  end
  
  remote_file 'TeamViewer.dmg' do
    path tmp_file
    source 'https://download.teamviewer.com/download/TeamViewer.dmg'
    action :create
    notifies :install, 'dmg_package[TeamViewer.dmg]', :immediately
  end
elsif platform_family?('debian')
  tmp_file = "#{Chef::Config['file_cache_path']}/TeamViewer.dmg"
  # Debian : https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
  
  package 'libminizip1'
  package 'libxcb-xinerama0'

  remote_file 'TeamViewer.deb' do
    path tmp_file
    source 'https://download.teamviewer.com/download/linux/teamviewer_amd64.deb'
    action :create
  end

  dpkg_package 'TeamViewer.deb' do
    source tmp_file
    action :install
  end
elsif platform_family?('windows')

  windows_package 'TeamViewer' do
    source 'https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe'
    options '/S'
    installer_type :custom
    action :install
  end
  
  # tmp_file = "#{Chef::Config['file_cache_path']}/TeamViewer_Setup_x64.exe"
  # execute 'TeamViewer_Setup_x64.exe' do
  #   command [tmp_file, '/S']
  #   action :nothing
  # end
  # remote_file 'TeamViewer_Setup_x64.exe' do
  #   source 'https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe'
  #   action :create
  #   notifies :install, 'execute[TeamViewer_Setup_x64.exe]', :immediately
  # end
  
end