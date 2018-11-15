FROM sanjayboddu/ensembl-web-03:v1

ARG ENSEMBL_SERVERNAME=www.ensembl.org 

ENV ENSEMBL_SERVERNAME=$ENSEMBL_SERVERNAME 

WORKDIR $ENSEMBL_WEBCODE_LOCATION

# checkout code
RUN source ${HOME}/.bashrc \
    && git-ensembl --clone --checkout --branch release/94 public-web \
    && git-ensembl --checkout --branch experimental/docker2 public-plugins \
    && cp public-plugins/docker/conf/Plugins.pm-dist ensembl-webcode/conf/Plugins.pm

RUN mkdir -p ${ENSEMBL_TMP_DIR_LOCATION}/server/conf/packed 

ADD *.packed ${ENSEMBL_TMP_DIR_LOCATION}/server/conf/packed/

USER www

# init and start the server
RUN source ${HOME}/.bashrc \
    && ./ensembl-webcode/ctrl_scripts/init \ 
    && ./ensembl-webcode/ctrl_scripts/start_server


CMD source ${HOME}/.bashrc \
    && ./ensembl-webcode/ctrl_scripts/start_server -D FOREGROUND 

EXPOSE 8080
