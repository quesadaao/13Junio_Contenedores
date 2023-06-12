FROM node:10-alpine
USER root
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./

COPY . .

RUN apk update && apk add --no-cache \
    python3 \
    py3-pip

RUN npm install

USER node

COPY --chown=node:node . .

EXPOSE 3000

CMD [ "node", "app.js", "--port=$PORT" ]
