FROM  centos 

RUN   yum update -y && yum repolist -y 
 
# Download mysql server package
RUN yum install -y https://repo.mysql.com/mysql-community-minimal-release-el7.rpm \
      https://repo.mysql.com/mysql-community-release-el7.rpm \
  && yum install -y \
      $MYSQL_SERVER_PACKAGE \
      $MYSQL_SHELL_PACKAGE \
      libpwquality \
  && yum clean all \
  && mkdir /docker-entrypoint-initdb.d

RUN yum install mysql-server -y 

RUN chown -R mysql:root /var/lib/mysql/

#RUN yum daemon-reload 

#RUN reboot 

#RUN systemctl start mysqld.service && systemctl status mysqld && systemctl enable mysqld

ARG MYSQL_DATABASE

ARG MYSQL_USER

ARG MYSQL_PASSWORD

ARG MYSQL_ROOT_PASSWORD

ENV MYSQL_DATABASE=my_db

ENV MYSQL_USER=user

ENV MYSQL_PASSWORD=abcde12345 

ENV MYSQL_ROOT_PASSWORD=abcde12345

EXPOSE 3306

CMD [ "/bin/bash" ]
