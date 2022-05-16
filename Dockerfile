ARG NODE_VERSION=16.13.1

FROM node:${NODE_VERSION}-alpine as build
WORKDIR /app

COPY . .

RUN npm install

CMD ["npm", "run", "start"]
