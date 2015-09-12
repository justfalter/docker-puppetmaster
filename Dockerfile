FROM debian:wheezy

MAINTAINER justfalter

RUN export DEBIAN_FRONTEND=noninteractive && \
      apt-get -qq update && \
      apt-get install -y wget ca-certificates && \
      apt-get clean && rm -rf /var/lib/apt/lists/*

RUN  wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb && \
      dpkg -i puppetlabs-release-wheezy.deb && \
      rm puppetlabs-release-wheezy.deb

RUN export DEBIAN_FRONTEND=noninteractive && \
      apt-get -qq update && \
      apt-get install -y --no-install-recommends puppet=3.8.2-1puppetlabs1 puppetserver=1.1.1-1puppetlabs1  && \
      apt-get clean && rm -rf /var/lib/apt/lists/*

ADD puppet.conf /etc/puppet/puppet.conf

RUN mv /etc/puppet /etc/puppet.skel
RUN mv /var/lib/puppet /var/lib/puppet.skel
VOLUME [ "/etc/puppet" ]
VOLUME [ "/var/lib/puppet" ]

EXPOSE 8140

ADD docker-entrypoint /docker-entrypoint
RUN chmod 755 /docker-entrypoint

ENTRYPOINT [ "/docker-entrypoint" ]
