FROM amd64/centos:latest

# Enabled systemd
ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# VOLUME [ "/sys/fs/cgroup" ]

VOLUME [ "/config" ]
VOLUME [ "/plex" ]

# epel-release
RUN yum install -y epel-release
RUN yum update -y

# install python
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum update -y
RUN yum install -y python36u python36u-libs python36u-devel python36u-pip

# install nginx
RUN yum install -y nginx

# install git
RUN yum install -y git

# update sqlite3
RUN yum install -y wget gcc
RUN wget https://sqlite.org/2019/sqlite-autoconf-3270200.tar.gz -O /tmp/sqlite-autoconf-3270200.tar.gz
RUN mkdir -p /tmp/sqlite-autoconf-3270200/
RUN tar xvfz /tmp/sqlite-autoconf-3270200.tar.gz -C /tmp/
WORKDIR /tmp/sqlite-autoconf-3270200/
RUN ./configure
RUN /usr/bin/make
RUN /usr/bin/make install

# install crontab
RUN yum install -y cronie

# copy root
COPY rootfs/ /

# prepare default config
RUN cp -r /defaults/systemd/startup.service /etc/systemd/system/startup.service
RUN cp -r /defaults/nginx/nginx.conf /etc/nginx/nginx.conf

# prepare trakt-plex-tracker
RUN git clone https://github.com/h1f0x/trakt-plex-tracker.git /opt/trakt-plex-tracker
RUN pip3.6 install -r /opt/trakt-plex-tracker/requirements.txt
RUN (crontab -l 2>/dev/null; echo "*/15 * * * * export LD_LIBRARY_PATH=/usr/local/lib/ && /usr/bin/python3.6 /opt/trakt-plex-tracker/trakt-or.py") | crontab -
RUN (crontab -l 2>/dev/null; echo "@reboot export LD_LIBRARY_PATH=/usr/local/lib/ && /usr/bin/python3.6 /opt/trakt-plex-tracker/trakt-or.py") | crontab -


# configure services (systemd)
RUN systemctl enable nginx
RUN systemctl enable startup.service

WORKDIR /root

# End
CMD ["/usr/sbin/init"]