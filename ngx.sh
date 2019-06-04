#!/bin/bash

ngx_version=nginx-1.16.0

apt-get install -y libpam0g-dev libtool automake

if [ ! -d /build ]; then
	mkdir /build
fi

cd /build

rm a.t
if [ ! -d linux-lib-src ]; then
	git clone https://github.com/atest0/linux-lib-src
	cd linux-lib-src

	tar xzf libxml2*
	cd libxml2*/
	./configure && make && make install
	cd ..

	tar xzf libxslt*
	cd libxslt*/
	./configure && make && make install
	cd ../..
fi

if [ ! -d openssl* ]; then
	wget https://www.openssl.org/source/openssl-1.1.1b.tar.gz -O a.t
	tar xzf a.t
	rm a.t
	cd openssl*
	./config && make && make install
	cd ..
fi

if [ ! -d libgd* ]; then
	wget https://github.com/libgd/libgd/releases/download/gd-2.2.5/libgd-2.2.5.tar.gz -O a.t
	tar xzf a.t
	rm a.t
	cd libgd*
	./configure && make && make install
	cd ..
fi

if [ ! -d geoip-api-c ]; then
	git clone https://github.com/maxmind/geoip-api-c
	cd geoip-api-c
	./bootstrap
	./configure && make && make install
	cd ..
fi

if [ ! -d nginx* ]; then
	wget http://nginx.org/download/${ngx_version}.tar.gz -O a.t
	tar xzf a.t
	rm a.t
fi
cd nginx*

mkdir modules

NGX_MOD() {
	dir=/build/${ngx_version}/modules/$2
	if [ ! -d $dir ]; then
		git clone $1 $dir
	fi
}

NGX_MOD https://github.com/sto/ngx_http_auth_pam_module nginx-auth-pam
NGX_MOD https://github.com/openresty/echo-nginx-module nginx-echo
NGX_MOD https://github.com/arut/nginx-dav-ext-module nginx-dav-ext-module
NGX_MOD https://github.com/gnosek/nginx-upstream-fair nginx-upstream-fair
NGX_MOD https://github.com/yaoweibin/ngx_http_substitutions_filter_module ngx_http_substitutions_filter_module


apt-get install -y dh-make checkinstall
