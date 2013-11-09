# Pushy cookbook

# Usage

```ruby
pushy "<job name>" do
  action :run # The only action is run
  wait true # Wait for the job run to complete before continuing with the run
  nodes [ "node1", "node2", "node3"]
end
```

For example:

```ruby
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

The "wait" option defaults to false. Setting wait to true makes the Chef run wait for the remote job to complete before continuing. This can be useful if you need to have an action happen on a remote machine before finishing the local Chef run.


# Author

* Author: Michael Ducy <michael@opscode.com>
