FROM sanjayboddu/ensembl-web-03:v1



# --build-args
# some info must be supplied at build time and is then saved to ENV
# this is not a secure solution but should do to get us started

# server hostname args
ARG ENSEMBL_SERVERNAME=www.ensembl.org
ENV ENSEMBL_SERVERNAME=$ENSEMBL_SERVERNAME

# session db args
ARG SESSION_HOST=your.session.db.host
ARG SESSION_PORT=3306
ARG SESSION_USER=ensrw
ARG SESSION_PASS=ensrw

ENV SESSION_HOST=$SESSION_HOST
ENV SESSION_PORT=$SESSION_PORT
ENV SESSION_USER=$SESSION_USER
ENV SESSION_PASS=$SESSION_PASS



WORKDIR $ENSEMBL_WEBCODE_LOCATION

# checkout code
RUN source ${HOME}/.bashrc \
    && git-ensembl --clone web \
    && git-ensembl --checkout --branch release/94 web \
    && git-ensembl --checkout --branch experimental/docker2 public-plugins \
    && cp public-plugins/docker-demo/conf/Plugins.pm-dist ensembl-webcode/conf/Plugins.pm



RUN mkdir -p ${ENSEMBL_TMP_DIR_LOCATION}/server/conf/packed \
    && cd ${ENSEMBL_TMP_DIR_LOCATION}/server/conf/packedi \
    && wget https://www.ebi.ac.uk/~sboddu/packed_files/mus_musculus.db.packed

WORKDIR $ENSEMBL_WEBCODE_LOCATION

# copy the Plugins config
#RUN cp public-plugins/docker-demo/conf/httpd.conf ensembl-webcode/conf/

# build C deps
#RUN ensembl-webcode/ctrl_scripts/build_api_c     ## not working - probably not required
#RUN ensembl-webcode/ctrl_scripts/build_inline_c

# init and start the server
RUN ./ensembl-webcode/ctrl_scripts/init
#RUN ./ensembl-webcode/ctrl_scripts/start_server

#CMD ./ensembl-webcode/ctrl_scripts/start_server -D FOREGROUND

EXPOSE 8080
