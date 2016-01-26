FROM alpine:latest

MAINTAINER Tobias Hartwich <mail@tha.io>

ADD tunnel_shell /usr/bin/tunnel_shell

RUN chmod +x /usr/bin/tunnel_shell && \
		apk update && \
    apk add bash openssh && \
    adduser -D -g '' -s /usr/bin/tunnel_shell YOURUSER && \
    sed -i -r 's/YOURUSER:!:/YOURUSER:*:/' /etc/shadow && \
    mkdir -p /home/YOURUSER/.ssh && chmod 700 /home/YOURUSER/.ssh/ && \
    echo -e "Port 22\n" >> /etc/ssh/sshd_config && \
    echo -e "GatewayPorts yes\n" >> /etc/ssh/sshd_config && \
    echo -e "PermitRootLogin no\n" >> /etc/ssh/sshd_config && \
    echo -e "PasswordAuthentication no\n" >> /etc/ssh/sshd_config && \
    echo -e "PermitTunnel yes\n" >> /etc/ssh/sshd_config && \
    echo -e "AllowUsers YOURUSER\n" >> /etc/ssh/sshd_config && \
    cp -a /etc/ssh /etc/ssh.cache && \
    rm -rf /var/cache/apk/*

ADD server_id_rsa /etc/ssh/ssh_host_rsa_key
ADD server_id_rsa.pub /etc/ssh/ssh_host_rsa_key.pub
ADD YOURUSER_id_rsa.pub /home/YOURUSER/.ssh/authorized_keys

RUN chmod 600 /etc/ssh/ssh_host_rsa_key && \
		chmod 644 /etc/ssh/ssh_host_rsa_key.pub

EXPOSE 22 9001

ADD entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
