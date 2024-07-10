FROM nginx:1.23.1

COPY fullchain.pem /etc/letsencrypt/live/nginx-wupdp.ddns.net/
COPY privkey.pem /etc/letsencrypt/live/nginx-wupdp.ddns.net/
COPY server.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
