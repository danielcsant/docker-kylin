FROM sequenceiq/ambari:1.6.0-warmup
172.19.1.72     sandbox.hortonworks.com
MAINTAINER SequenceIQ

RUN curl -s http://apache.proserve.nl/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz | tar -xz -C /usr/local/
RUN ln -s /usr/local/apache-maven-3.2.3/bin/mvn /usr/bin/mvn

RUN curl -sL https://github.com/KylinOLAP/Kylin/archive/v0.6.2.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./Kylin-0.6.2 kylin
RUN cd /usr/local/kylin && mvn clean install -DskipTests

RUN yum install -y hbase mysql

RUN curl -s http://xenia.sote.hu/ftp/mirrors/www.apache.org/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59.tar.gz | tar -xz -C /usr/local/
ENV CATALINA_HOME /usr/local/apache-tomcat-7.0.59

RUN curl -s http://nodejs.org/dist/v0.10.32/node-v0.10.32-linux-x64.tar.gz | tar -xz -C /usr/local/
RUN ln -s /usr/local/node-v0.10.32-linux-x64/bin/npm /usr/bin/npm
RUN ln -s /usr/local/node-v0.10.32-linux-x64/bin/node /usr/bin/node

ADD serf /usr/local/serf

ADD install-cluster.sh /tmp/
ADD kylin-singlenode.json /tmp/
ADD kylin-multinode.json /tmp/
ADD wait-for-kylin.sh /tmp/
ADD deploy.sh /usr/local/kylin/deploy.sh

RUN echo 'root:kylin' | chpasswd

EXPOSE 7070
