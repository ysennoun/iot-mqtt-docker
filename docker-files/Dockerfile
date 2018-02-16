FROM centos

# Install package
RUN yum -y install wget
RUN yum -y install man
RUN yum -y install sudo
RUN yum -y install httpd
RUN yum -y install net-tools
RUN yum -y install iproute
RUN yum -y install wireshark-gnome
RUN yum -y install initscripts

# Install mosquitto
RUN echo "[home_oojah_mqtt]" >> /etc/yum.repos.d/CentOS-Base.repo
RUN echo "name=mqtt (CentOS_CentOS-7)" >> /etc/yum.repos.d/CentOS-Base.repo
RUN echo "type=rpm-md" >> /etc/yum.repos.d/CentOS-Base.repo
RUN echo "baseurl=http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-7/" >> /etc/yum.repos.d/CentOS-Base.repo
RUN echo "gpgcheck=1" >> /etc/yum.repos.d/CentOS-Base.repo
RUN echo "gpgkey=http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-7/repodata/repomd.xml.key" >> /etc/yum.repos.d/CentOS-Base.repo
RUN echo "enabled=1" >> /etc/yum.repos.d/CentOS-Base.repo
RUN yum -y install mosquitto
RUN yum -y install mosquitto-clients

# Install Java
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz"
RUN tar xzf jdk-8u161-linux-x64.tar.gz
RUN mkdir -p /usr/bin/java/
RUN mv jdk1.8.0_161 /usr/bin/java/
RUN rm jdk-8u161-linux-x64.tar.gz
RUN chown -R root:root /usr/bin/java/jdk1.8.0_161/
ENV JAVA_HOME=/usr/bin/java/jdk1.8.0_161
ENV PATH=$PATH:/usr/bin/java/jdk1.8.0_161/bin
RUN java -version

# Install EMQTT
RUN wget emqtt.io/downloads/latest/centos7-rpm
RUN rpm -ivh centos7-rpm
RUN rm centos7-rpm

# Copy files
RUN mkdir -p /home/jars
COPY modify_emq_conf_file.sh /home/
COPY publisher.sh /home/
COPY subscriber.sh /home/
COPY jars/* /home/jars/

# Install Elasticsearch
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.1.tar.gz
RUN useradd -ms /bin/bash elasticuser
RUN tar -xzf elasticsearch-6.2.1.tar.gz
RUN mv elasticsearch-6.2.1/ /home/elasticuser/elasticsearch
RUN chown -R elasticuser:elasticuser /home/elasticuser/elasticsearch/
RUN rm elasticsearch-6.2.1.tar.gz

# Install Kibana
RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-6.2.0-x86_64.rpm
RUN rpm -ivh kibana-6.2.0-x86_64.rpm
RUN rm kibana-6.2.0-x86_64.rpm
RUN echo "server.host: 0.0.0.0" >> /etc/kibana/kibana.yml
RUN echo "server.port: 5601" >> /etc/kibana/kibana.yml

# Expose ports
EXPOSE 1883
EXPOSE 5601
EXPOSE 9200
EXPOSE 9300


