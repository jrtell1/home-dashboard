FROM node:12.13-alpine

WORKDIR /app

COPY package*.json /app/

ENV NODE_ENV 'production'
ENV HOST '0.0.0.0'

RUN npm install --production

COPY . /app/

RUN npm run build

EXPOSE 3000
CMD ["npm", "start"]
