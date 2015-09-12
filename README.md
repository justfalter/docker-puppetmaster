# docker-puppetmaster
Docker image for puppet server macadmins/docker-puppetmaster. 

- Based on debian wheezy
- Autosigning is turned *on* in puppet.conf.
- confdir and vardir are both docker volumes, so it is be easy to carry your
  configuration and state from one version of puppet to another.
  - confdir = /etc/puppet
  - vardir = /var/lib/puppet
- Manifests are stored in /etc/puppet/manifests

# Starting...

## Using a data-only container
Storing your data in a data-only container is a popular choice. The advantage is that all of your puppet data is contained within a single container. A major disadvantage is that it can be a bit of a hassle to edit your manifests.

1. Make a data-only container first, so you can destroy the puppetmaster container without losing certs or other configuration data:  
  `docker run -d --name puppet-data --entrypoint /bin/true`
2. `docker run -d --name puppetmaster -h puppet -p 8140:8140 --volumes-from puppet-data justfalter/puppetmaster`

## Using volume directories

1. Create a directory on your docker host's filesystem to store puppet's confdir. 
   `mkdir /opt/puppet/confdir`
2. Create a directory on your docker host's filesystem to store puppet's vardir. 
   `mkdir /opt/puppet/vardir`
3. Start the puppet master container using these directories:
   `docker run -d --name puppetmaster -h puppet -p 8140:8140 -v /opt/puppet/confdir:/etc/puppet -v /opt/puppet/vardir:/var/lib/puppet justfalter/puppetmaster`


# Usage

## Listing certificates:
`docker exec puppetmaster puppet cert list -all`

# Configuring a host to use the puppetmaster:
1. Install Puppet, Hiera, Facter, and Puppet LaunchDaemon onto client
2. Ensure that when the host resolves 'puppet', it resolves to the IP of your Docker host. This can be done via DNS or adding an entry to /etc/hosts.
3. Test puppet on client running as root:  
   `puppet agent --test`  
    You should see the cert request being generated and autosigned.
4. Verify cert signing on puppetmaster docker container:  
  `docker exec puppetmaster puppet cert list -all`
6. On the client, run:  
  `puppet agent --test` 
  again to verify that cert exists and was confirmed.
