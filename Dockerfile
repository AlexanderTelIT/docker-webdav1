FROM alpine:3.19

RUN apk upgrade --no-cache && apk add --no-cache \
    nginx \
    nginx-mod-http-dav-ext \
    nginx-mod-http-headers-more \
    openssl

RUN sed -i "s/user nginx;/user root;/g" /etc/nginx/nginx.conf

COPY webdav.conf /etc/nginx/http.d/default.conf

COPY entrypoint.sh /opt/webdav/entrypoint.sh

RUN chmod -R 7777 /etc/nginx/
RUN chmod -R 7777 /opt/webdav/
RUN chmod -R 7777 /var/lib/nginx/
RUN chmod -R 777 /var/log/nginx/. &&\
    chmod -R 777 /etc/nginx/.
RUN chmod -R 777 /run/nginx    
RUN mkdir /mnt/webdav
RUN chmod -R 777 /mnt/webdav

ENV WEBDAV_USER=webdav
ENV WEBDAV_PASSWORD=webdav
ENV WEBDAV_MAX_UPLOAD_SIZE=0

ENV HTPASSWD_FILE=/opt/webdav/.htpasswd

RUN sed -i "s/client_max_body_size 0;/client_max_body_size $WEBDAV_MAX_UPLOAD_SIZE;/g" /etc/nginx/http.d/default.conf

#ENTRYPOINT ["/opt/webdav/entrypoint.sh"]

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
