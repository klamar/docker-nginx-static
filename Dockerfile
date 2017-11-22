FROM alpine:3.6

RUN set -ex \
    && apk add --update ca-certificates bash make g++ git zlib-dev \
    && update-ca-certificates \
    && apk add openssl \

    && git clone --recursive https://github.com/google/ngx_brotli.git /tmp/nginx_brotli \
#    && unzip /tmp/nginx_brotli.zip -d /tmp \

    && wget "https://nginx.org/download/nginx-1.13.7.tar.gz" -O /tmp/nginx.tar.gz \
    && tar xf /tmp/nginx.tar.gz -C /tmp \
    && cd /tmp/nginx-1.13.7 \
    && ./configure --add-module=/tmp/nginx_brotli --without-http_rewrite_module --with-http_gzip_static_module --with-http_v2_module \
            --prefix=/ --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log \
            --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid \
            --without-http_geo_module --without-http_map_module --without-http_split_clients_module --without-http_referer_module --without-http_rewrite_module --without-http_proxy_module --without-http_fastcgi_module --without-http_uwsgi_module --without-http_scgi_module --without-http_memcached_module --without-http_limit_conn_module --without-http_limit_req_module --without-http_empty_gif_module \
            --without-http-cache \
            --without-mail_pop3_module  --without-mail_imap_module --without-mail_smtp_module \

    && make install \
    && cd /tmp && rm -rf /tmp/* \
    && apk del ca-certificates bash make g++ git zlib-dev openssl

COPY nginx/nginx.conf /etc/nginx/nginx.conf

WORKDIR "/"

CMD ["/sbin/nginx", "-g", "daemon off;"]
