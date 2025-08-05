FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y apache2 openssl && \
    a2enmod ssl && a2enmod rewrite

# Crear carpetas de contenido y certificados
RUN mkdir -p /var/www/sites

# Copiar sitios
COPY sites/ /var/www/sites/

# Copiar certificados
COPY ssl/ /etc/apache2/ssl/

# Copiar configuraciones de VirtualHosts
COPY vhosts/ /etc/apache2/sites-available/

RUN ls -l /etc/apache2/sites-available/
# Activar todos los sitios
RUN a2ensite boommania.conf && \
    a2ensite api.boommania.conf && \
    a2ensite web.boommania.conf && \
    a2dissite 000-default.conf

EXPOSE 80 443

CMD ["apachectl", "-D", "FOREGROUND"]