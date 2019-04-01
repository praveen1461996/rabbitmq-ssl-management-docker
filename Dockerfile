FROM rabbitmq:3.6

RUN rabbitmq-plugins enable --offline rabbitmq_management
RUN rabbitmq-plugins enable --offline rabbitmq_stomp
RUN rabbitmq-plugins enable --offline rabbitmq_web_stomp

RUN apt-get update \
	&& apt-get install openssl -y  \ 
	&& mkdir -p /home/testca/certs \
	&& mkdir -p /home/testca/private \
	&& chmod 700 /home/testca/private \
	&& echo '10' >> /home/testca/serial \
	&& touch /home/testca/index.txt \
	&& touch /home/testca/index.txt.attr

COPY rabbitmq.config /etc/rabbitmq/rabbitmq.config
COPY openssl.cnf /home/testca
COPY server-keys.sh client-keys.sh /home/

RUN mkdir -p /home/server \
	&& mkdir -p /home/client \
	&& chmod +x /home/server-keys.sh /home/client-keys.sh

RUN /bin/bash /home/server-keys.sh \
	&& /etc/init.d/rabbitmq-server restart
EXPOSE 15672 15671 15674 61613 61614
CMD /bin/bash /home/client-keys.sh && rabbitmq-server
#sleep infinity
