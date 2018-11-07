
describe service('mongod') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
end

describe port(27017) do
    it { should be_listening }
end
