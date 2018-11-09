FROM sanjayboddu/ensembl-web-03:v1

# --build-args
# some info must be supplied at build time and is then saved to ENV
# this is not a secure solution but should do to get us started


ARG ENSEMBL_SERVERNAME=www.ensembl.org 
ARG SESSION_HOST=your.session.db.host 
ARG SESSION_PORT=3306 
ARG SESSION_USER=ensrw 
ARG SESSION_PASS=ensrw

ENV ENSEMBL_SERVERNAME=$ENSEMBL_SERVERNAME \
    SESSION_HOST=$SESSION_HOST \
    SESSION_PORT=$SESSION_PORT \
    SESSION_USER=$SESSION_USER \
    SESSION_PASS=$SESSION_PASS 



WORKDIR $ENSEMBL_WEBCODE_LOCATION

# checkout code
RUN source ${HOME}/.bashrc \
    && git-ensembl --clone web \
    && git-ensembl --checkout --branch release/94 web \
    && git-ensembl --checkout --branch experimental/docker2 public-plugins \
    && cp public-plugins/docker/conf/Plugins.pm-dist ensembl-webcode/conf/Plugins.pm



RUN mkdir -p ${ENSEMBL_TMP_DIR_LOCATION}/server/conf/packed \
    && cd ${ENSEMBL_TMP_DIR_LOCATION}/server/conf/packed \
    && wget https://www.ebi.ac.uk/~sboddu/packed_files/mus_musculus.db.packed 

WORKDIR $ENSEMBL_WEBCODE_LOCATION

#RUN cp public-plugins/docker-demo/conf/httpd.conf ensembl-webcode/conf/


USER www

# init and start the server
RUN source ${HOME}/.bashrc \
    && ./ensembl-webcode/ctrl_scripts/init \ 
    && ./ensembl-webcode/ctrl_scripts/start_server


CMD source ${HOME}/.bashrc \
    && ./ensembl-webcode/ctrl_scripts/start_server -D FOREGROUND 

EXPOSE 8080
