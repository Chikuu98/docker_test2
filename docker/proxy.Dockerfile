FROM nginx:1.23.2-alpine
COPY ./default.conf.template /etc/nginx/templates/default.conf.template
