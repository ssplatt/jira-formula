require 'serverspec'

# Required by serverspec
set :backend, :exec

describe package('mariadb-client') do
  it { should be_installed }
end

describe package('mariadb-server') do
  it { should be_installed }
end

describe package('python-mysqldb') do
  it { should be_installed }
end

describe file('/opt/atlassian/jira') do
  it { should exist }
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/opt/atlassian/jira/lib/mysql-connector-java-5.1.43-bin.jar') do
  it { should exist }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/lib/systemd/system/jira.service') do
  it { should exist }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/opt/atlassian/jira/conf/server.xml') do
  it { should exist }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /<Connector port="8080"/ }
  its(:content) { should match /redirectPort="8443"/ }
end

describe file('/opt/atlassian/jira/bin/setenv.sh') do
  it { should exist }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /^JVM_SUPPORT_RECOMMENDED_ARGS="-Dhttp\.proxyHost=proxy\.example\.org -Dhttp\.proxyPort=8080 -Dhttps\.proxyHost=proxy\.example\.org -Dhttps\.proxyPort=8080 -Dhttp\.nonProxyHosts=localhost"/ }
  its(:content) { should match /JVM_MINIMUM_MEMORY="512m"/ }
  its(:content) { should match /JVM_MAXIMUM_MEMORY="1024m"/ }
end

describe file('/opt/atlassian/jira/atlassian-jira/WEB-INF/web.xml') do
  it { should exist }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /\<session-timeout\>600\<\/session-timeout\>/ }
end

describe service('jira') do
  it { should be_enabled }
  it { should be_running }
end

describe service('mysql') do
  it { should be_enabled }
  it { should be_running }
end

describe port('3306') do
  it { should be_listening }
end

describe process('java') do
  its(:user) { should eq 'jira' }
  its(:args) { should match /-Djava.util.logging.config.file=\/opt\/atlassian\/jira\/conf\/logging.properties/ }
  its(:args) { should match /-Xms512m/ }
  its(:args) { should match /-Xmx1024m/ }
  its(:args) { should match /-Datlassian\.standalone=JIRA/ }
  its(:args) { should match /-classpath \/opt\/atlassian\/jira\/bin\/bootstrap.jar\:\/opt\/atlassian\/jira\/bin\/tomcat-juli\.jar/ }
  its(:args) { should match /-Dcatalina\.base=\/opt\/atlassian\/jira/ }
  its(:args) { should match /-Dcatalina\.home=\/opt\/atlassian\/jira/ }
  its(:args) { should match /-Djava\.io\.tmpdir=\/opt\/atlassian\/jira\/temp/ }
  its(:args) { should match /org\.apache\.catalina\.startup\.Bootstrap start/ }
end

describe file('/etc/cron.hourly/mysql-backup') do
  it { should exist }
  it { should be_mode 750 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:sha256sum) { should eq 'd67dbfbc6e113d35a213505c088c11257ce88f929999905c66d209f1a6ed734e' }
end

describe file('/etc/logrotate.d/mysql-backup') do
  it { should exist }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:sha256sum) { should eq '7f973d0af7b731af3b6e102a30800aaa1780d50e0bee656178ae4683b4f7a826' }
end
