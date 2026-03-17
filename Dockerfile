FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    di \
    sudo \
    software-properties-common \
    ansible \
    && add-apt-repository universe \
    && apt-get update \
    && rm -rf /var/lib/apt/lists/*

# Copy and run the ansible playbook to install packages
COPY ansible/playbook.yml /tmp/playbook.yml
RUN ansible-playbook -i "localhost," -c local /tmp/playbook.yml \
    && rm /tmp/playbook.yml

RUN useradd -m -s /bin/bash wstevenson \
    && echo "wstevenson ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/wstevenson \
    && chmod 0440 /etc/sudoers.d/wstevenson

USER wstevenson
WORKDIR /home/wstevenson
CMD ["/bin/bash"]
