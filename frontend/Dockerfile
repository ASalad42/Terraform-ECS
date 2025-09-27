FROM node:22-alpine

WORKDIR /usr/src/app

COPY package.json ./
RUN npm install --only=production

COPY app.js ./

EXPOSE 80

CMD ["npm", "start"]