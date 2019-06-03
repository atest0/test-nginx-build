FROM debian

#ssh {

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server pwgen
RUN apt-get clean
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh

ENV AUTHORIZED_KEYS **None**

#ssh }

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim nano curl wget zip build-essential git

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	zlibc \
	zlib1g \
	zlib1g-dev \
	libpcre3 \
	libpcre3-dev \
	zip

RUN apt-get clean


Add ngx.sh /ngx.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

SHELL ["/bin/bash", "-c"]
RUN /ngx.sh


RUN echo "syntax on\nset number\nset ruler\n" >> /etc/vim/vimrc

EXPOSE 80 8080 22

ENTRYPOINT ["/run.sh"]
