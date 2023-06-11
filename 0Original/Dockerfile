FROM node:10-alpine

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./

USER node

RUN apt-get update && apt-get install -y \
    software-properties-common \
    python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN npm install

COPY --chown=node:node . .

EXPOSE 3000

CMD [ "node", "app.js","--port=$PORT" ]
