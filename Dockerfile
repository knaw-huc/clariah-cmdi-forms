FROM ubuntu:18.04
MAINTAINER  Menzo Windhouwer <menzo.windhouwer@di.huc.knaw.nl>

#
# locale
#

ENV TZ 'Europe/Amsterdam'
RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y locales && \
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"

#
# Update and install all system libraries
#

RUN apt-get update &&\
	apt-get -y dist-upgrade

# Apache
RUN apt-get -y install apache2
EXPOSE 80

# MariaDB
RUN	apt-get -y install mariadb-server mariadb-client
RUN mkdir -p /var/log/mariadb

# PHP
RUN apt-get -y install libapache2-mod-php php-mysqli php-xml php-curl

# GIT
RUN	apt-get -y install supervisor git

# supervisor
RUN apt-get -y install supervisor
ADD docker/supervisor/*.conf /etc/supervisor/conf.d/
ADD docker/supervisor/start.sh /start.sh
RUN	chmod u+x /start.sh
ENTRYPOINT /start.sh

# scripts
RUN mkdir -p /app/bin
ADD docker/scripts/* /app/bin/
RUN	chmod u+x /app/bin/*
ENV PATH=/app/bin:$PATH

#
# Install the app
#

RUN mkdir -p /var/www/html/ccf
WORKDIR /var/www/html/ccf

# huc-generic-editor
ADD mod/huc-generic-editor /var/www/html/ccf/huc-generic-editor
RUN if [ ! -f huc-generic-editor/LICENSE  ]; then rm -rf ./huc-generic-editor && git clone https://github.com/knaw-huc/huc-generic-editor.git; fi
RUN mv ./huc-generic-editor/js . &&\
    mv ./huc-generic-editor/css . &&\
    rm -rf ./huc-generic-editor

# clariah-cmdi-parser
ADD mod/clariah-cmdi-parser /var/www/html/ccf/clariah-cmdi-parser
RUN if [ ! -f clariah-cmdi-parser/LICENSE  ]; then rm -rf ./clariah-cmdi-parser && git clone https://github.com/knaw-huc/clariah-cmdi-parser.git; fi
RUN mv ./clariah-cmdi-parser/classes . &&\
    mv ./clariah-cmdi-parser/config . &&\
    mv ./clariah-cmdi-parser/examples ./data &&\
    mv ./clariah-cmdi-parser/tweaker . &&\
    rm -rf ./clariah-cmdi-parser

# clariah-cmdi-forms
#ADD mod/clariah-cmdi-forms /var/www/html/ccf/clariah-cmdi-forms
#RUN if [ ! -f clariah-cmdi-forms/LICENSE  ]; then rm -rf ./clariah-cmdi-forms && git clone https://github.com/knaw-huc/clariah-cmdi-forms.git; fi
ADD src /var/www/html/ccf/clariah-cmdi-forms
RUN cp -r ./clariah-cmdi-forms/classes/* ./classes/ &&\
    cp -r ./clariah-cmdi-forms/config/* ./config/ &&\
    mv ./clariah-cmdi-forms/convert . &&\
    cp -r ./clariah-cmdi-forms/css/* ./css/ &&\
    cp -r ./clariah-cmdi-forms/data/* ./data/ &&\
    mv ./clariah-cmdi-forms/img . &&\
    mv ./clariah-cmdi-forms/includes . &&\
    cp ./clariah-cmdi-forms/js/ccforms.js ./js/src &&\
    mv ./clariah-cmdi-forms/sample_db . &&\
    mv ./clariah-cmdi-forms/smarty . &&\
    mv ./clariah-cmdi-forms/*.php . &&\
    rm -rf ./clariah-cmdi-forms

# rights
RUN mkdir -p /var/www/html/ccf/smarty/templates_c &&\
    chmod -R a+w /var/www/html/ccf/smarty/templates_c &&\
    mkdir -p /var/www/html/ccf/data/records &&\
    chmod -R a+w /var/www/html/ccf/data/records &&\
    mkdir -p /var/www/html/ccf/data/records/inprogress &&\
    chmod -R a+w /var/www/html/ccf/data/records/inprogress &&\
    mkdir -p /var/www/html/ccf/data/uploads &&\
    chmod -R a+w /var/www/html/ccf/data/uploads

#
# Install sample data
#

RUN service supervisor start &&\
    supervisorctl status &&\
    sleep 10 &&\
    supervisorctl status &&\
    mysql < /var/www/html/ccf/sample_db/cmdi_forms.sql &&\
    ccf-add-profile.sh TestProfile "Profile to test CLARIAH CMDI Forms" &&\
    supervisorctl stop all &&\
	service supervisor stop

#
# Cleanup
#

# clean up APT and /tmp when done.
RUN apt-get clean &&\
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
