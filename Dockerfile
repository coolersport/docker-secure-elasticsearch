FROM docker.elastic.co/elasticsearch/elasticsearch:6.2.3

COPY entrypoint.sh /

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install -b com.floragunn:search-guard-6:6.2.3-22.0 && \
    chmod u+x /usr/share/elasticsearch/plugins/search-guard-6/tools/*.sh && \
    chown -R elasticsearch /usr/share/elasticsearch/plugins/search-guard-6 && \
    chmod u+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["eswrapper"]
