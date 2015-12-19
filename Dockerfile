#FROM nodesource/jessie:4
FROM mhart/alpine-node:4.2.3

RUN apk add --update git
ENV NODE_ENV production

WORKDIR /app
ADD tutor-student/ /app/
RUN rm -rf /app/node_modules
RUN npm install
ADD config.cson /app/


EXPOSE 80


CMD []
ENTRYPOINT ["node", "index.js"]
