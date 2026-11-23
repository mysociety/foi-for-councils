FROM ruby:3.4-bookworm

ENV DOCKER 1
ENV DEBIAN_FRONTEND noninteractive

# Wait-for-it
RUN git clone https://github.com/vishnubob/wait-for-it.git /tmp/wait-for-it && \
    chmod +x /tmp/wait-for-it/wait-for-it.sh && \
    ln -s /tmp/wait-for-it/wait-for-it.sh /bin/wait-for-it

WORKDIR /code/

EXPOSE 3000
CMD wait-for-it db:5432 --strict -- ./docker/entrypoint.sh
