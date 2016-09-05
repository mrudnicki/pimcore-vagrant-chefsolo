bash "apt_get_update" do
  code "apt-get update"
end

packages = ['ntp', 'ntpdate', 'htop', 'vim', 'gcc', 'make', 'git', 'fortune', 'sudo', 'mc']

packages.each do |pkg|
  package pkg
end

bash "install_linux_headers" do
  code "apt-get install -y linux-headers-$(uname -r)"
end
