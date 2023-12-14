FROM nginx 

ADD custom.conf /etc/nginx/conf.d/

EXPOSE 8043

ENV FOO bar

CMD ["nginx", "-g", "daemon off;"]
