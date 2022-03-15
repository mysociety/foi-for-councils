FROM ruby:2.6-bullseye

ENV DOCKER 1
ENV DEBIAN_FRONTEND noninteractive

# NodeJS and Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -y && \
    apt-get install -y \
    nodejs \
    yarn

# Wait-for-it
RUN git clone https://github.com/vishnubob/wait-for-it.git /tmp/wait-for-it && \
    chmod +x /tmp/wait-for-it/wait-for-it.sh && \
    ln -s /tmp/wait-for-it/wait-for-it.sh /bin/wait-for-it

WORKDIR /code/

EXPOSE 3000
CMD wait-for-it db:5432 --strict -- ./docker/entrypoint.sh
