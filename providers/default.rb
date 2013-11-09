# lwrp_example_three provider

require 'chef/rest'

use_inline_resources

def whyrun_supported?
  true
end


action :run do

  converge_by("Executing knife job start #{ new_resource.job_name } #{ new_resource.nodes}") do
    @node_names = []

    rest = Chef::REST.new(Chef::Config[:chef_server_url])

    Chef::Log.info "Attempting #{new_resource.job_name} on #{ new_resource.nodes} new"

    job_json = {
      'command' => new_resource.job_name,
      'nodes' => new_resource.nodes,
      'quorum' => new_resource.nodes.length,
    }

    job_json['run_timeout'] = 3600
    Chef::Log.info "josn: #{job_json}"

    
    result = rest.post_rest('pushy/jobs', job_json)
    job_uri = result['uri']
    Chef::Log.info @result
    Chef::Log.info "Started.  Job ID: #{job_uri[-32,32]}"

    if new_resource.wait
      previous_state = "Initialized."
      begin
        sleep(0.1)
        job = rest.get_rest(job_uri)
        finished, state = status_string(job)
        if state != previous_state
          Chef::Log.info(state)
          previous_state = state
        end
      end until finished
    end
  end
end

def status_string(job)
  case job['status']
    when 'new'
     [false, 'Initialized.']
    when 'voting'
      [false, job['status'].capitalize + '.']
    else
      total = job['nodes'].values.inject(0) { |sum,nodes| sum+nodes.length }
      in_progress = job['nodes'].keys.inject(0) { |sum,status|
        nodes = job['nodes'][status]
        sum + (%w(new voting running).include?(status) ? 1 : 0)
      }
    if job['status'] == 'running'
      [false, job['status'].capitalize + " (#{in_progress}/#{total} in progress) ..."]
    else
      [true, job['status'].capitalize + '.']
    end
  end
end

def status_code(job)
  if job['status'] == "complete" && job["nodes"].keys.all? do |key|
    key == "succeeded" || key == "nacked" || key == "unavailable"
  end
    0
  else
    1
  end
end
