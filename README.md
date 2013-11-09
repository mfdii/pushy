# Pushy cookbook

# Usage

```
pushy "<job name>" do
  action :run # The only action is run
  wait true # Wait for the job run to complete before continuing with the run
  nodes [ "node1", "node2", "node3"]
end
```

For example:

```
pushy "chef-client" do
  action :run 
  wait true 
  nodes [ "node1", "node2", "node3"]
end

```
would be the same as

```
knife job start chef-client node1 node2 node3
```

# Author

* Author: Michael Ducy <michael@opscode.com>
