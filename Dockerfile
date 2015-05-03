FROM debian:latest
    MAINTAINER myasu26 <hotshot26jp@gmail.com>

# mirror
RUN echo "deb http://cdn.debian.net/debian/ jessie main contrib non-free" > /etc/apt/sources.list.d/mirror.jp.list
RUN echo "deb http://cdn.debian.net/debian/ jessie-updates main contrib" >> /etc/apt/sources.list.d/mirror.jp.list
RUN /bin/rm /etc/apt/sources.list

RUN export DEBIAN_FRONTEND=noninteractive LANG
RUN apt-get update

# set locale
RUN apt-get install -y --no-install-recommends task-japanese locales

RUN locale-gen ja_JP.UTF-8  
ENV LANG ja_JP.UTF-8 
ENV LANGUAGE ja_JP:ja
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

# set timezone
RUN echo "Asia/Tokyo" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# sample
# RUN apt-get install -y --no-install-recommends xxx

# apt package
# need for git
RUN apt-get install -y --no-install-recommends git
RUN apt-get install -y --no-install-recommends ca-certificates openssl

# need for ansible
RUN apt-get install -y --no-install-recommends ssh python

# other
RUN apt-get install -y --no-install-recommends sudo vim-gnome wget curl locate

# clean up
RUN apt-get upgrade -y && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* 

## Set up SSH
RUN mkdir -m 700 ~/.ssh
RUN wget https://github.com/myasu26.keys -O ~/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys

EXPOSE 22

CMD ["/sbin/init", "3"]

