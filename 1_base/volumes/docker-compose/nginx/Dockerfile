FROM alpine:latest

RUN apk add --no-cache nginx && mkdir -p /run/nginx

EXPOSE 8043

COPY custom.conf /etc/nginx/http.d/

COPY ./www/ /var/www/

CMD ["nginx", "-g", "daemon off;"]
