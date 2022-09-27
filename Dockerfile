FROM centos:7
MAINTAINER Eazon

RUN groupadd kingbase && useradd -g kingbase -m -d /opt/kingbase -s /bin/bash kingbase


WORKDIR /opt/kingbase/data
WORKDIR /opt/kingbase

ADD kingbase.tar.gz ./

ADD entrypoint.sh ./
ADD initdb.sh ./
ADD license.dat ./

RUN chmod +x entrypoint.sh
RUN chmod +x initdb.sh

RUN chown -R kingbase:kingbase /opt/kingbase

ENV PATH /opt/kingbase/Server/bin:$PATH

ENV DB_VERSION V008R003C002B0320


EXPOSE 54321

ENTRYPOINT ["/opt/kingbase/entrypoint.sh"]
