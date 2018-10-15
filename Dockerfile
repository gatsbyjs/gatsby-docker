FROM nginx:1-alpine

COPY nginx-boot.sh /sbin/nginx-boot

CMD [ "/sbin/nginx-boot" ]

EXPOSE 80
