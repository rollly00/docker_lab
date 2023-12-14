FROM alpine:3.19.0

ENV NGINX_VER 1.24.0-r14

RUN apk add --no-cache nginx=${NGINX_VER} && mkdir -p /run/nginx

COPY custom.conf /etc/nginx/http.d/

COPY index.html /opt/app/

EXPOSE 8043

COPY . /opt/

CMD ["nginx", "-g", "daemon off;"]

