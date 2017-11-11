## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
#https://docs.puppet.com/pe/2015.3/release_notes.html#filebucket-resource-no-longer-created-by-default
File { backup => false }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}

node ubntupupcli03.saranu.local {
 docker::image { 'ubuntu':
  ensure      => 'present',
  image_tag   => 'precise',
  docker_file => '/tmp/Dockerfile',
  }
  docker::run { 'helloworld':
  image   => 'ubuntu:precise',
  command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
  }
}
node puppetnode02.saranu.local {
class { '::java': }
class { '::tomcat': }
tomcat::install { '/opt/tomcat9':
  source_url => 'https://www.apache.org/dist/tomcat/tomcat-9/v9.0.x/bin/apache-tomcat-9.0.x.tar.gz'
}
tomcat::instance { 'tomcat9-first':
  catalina_home => '/opt/tomcat9',
  catalina_base => '/opt/tomcat9/first',
}
tomcat::instance { 'tomcat9-second':
  catalina_home => '/opt/tomcat9',
  catalina_base => '/opt/tomcat9/second',
}
# Change the default port of the second instance server and HTTP connector
tomcat::config::server { 'tomcat9-second':
  catalina_base => '/opt/tomcat9/second',
  port          => '8006',
}
tomcat::config::server::connector { 'tomcat9-second-http':
  catalina_base         => '/opt/tomcat9/second',
  port                  => '8081',
  protocol              => 'HTTP/1.1',
  additional_attributes => {
    'redirectPort' => '8443'
  },
}
}
