require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/opt/atlassian/jira') do
  it { should exist }
  it { should be_directory }
  it { should be_mode 755 }
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
  its(:md5sum) { should eq "29b849163c7775c8532cc3592a8bd1d8" }
end

describe file('/opt/atlassian/jira/bin/setenv.sh') do
  it { should exist }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:md5sum) { should eq "26a68c2544e0d4018f15b43117e931f1" }
end

describe file('/opt/atlassian/jira/atlassian-jira/WEB-INF/web.xml') do
  it { should exist }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:md5sum) { should eq "2b991835f05adc2a850172546294c6d0" }
end
