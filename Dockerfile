# Use an official Ubuntu as the base image
FROM ubuntu:20.04

# Install OpenSSH Server
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server iputils-ping ansible && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure SSH
RUN mkdir -p /var/run/sshd 
RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ''  # Generate SSH key pair
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys  # Add public key to authorized_keys
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
COPY sshconfig /root/.ssh/config
RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/authorized_keys 
RUN chmod 400 /root/.ssh/config


# Expose SSH port
EXPOSE 22

# Start the SSH server
CMD ["/usr/sbin/sshd", "-D"]
