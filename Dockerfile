FROM andrewyatz/webdocker-perllibs

# add missing symlinks (these should really be created by the parent image)
RUN mkdir paths/apache
RUN ln -s /home/linuxbrew/.linuxbrew/opt/httpd22/bin/httpd paths/apache/httpd
RUN ln -s /home/linuxbrew/.linuxbrew/opt/httpd22/libexec paths/apache/modules
RUN ln -s /home/linuxbrew/.linuxbrew/opt/bioperl-169/libexec paths/bioperl

# create a workdir
RUN mkdir website
WORKDIR website

# checkout code
RUN git-ensembl --clone ensembl ensembl-compara ensembl-funcgen ensembl-io ensembl-orm ensembl-tools ensembl-variation ensembl-webcode public-plugins
RUN git-ensembl --checkout --branch experimental/docker public-plugins

# copy Plugins config
RUN cp public-plugins/docker/conf/Plugins.pm-dist ensembl-webcode/conf/Plugins.pm

# build C deps
#RUN ensembl-webcode/ctrl_scripts/build_api_c     ## not working - probably not required
RUN ensembl-webcode/ctrl_scripts/build_inline_c

# init
RUN mkdir tmp
RUN ensembl-webcode/ctrl_scripts/init

# go for it...
RUN ensembl-webcode/ctrl_scripts/start

