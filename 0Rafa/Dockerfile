# Use the official Node.js 14 image as the base
FROM node:14
ENV NODE_ENV=production

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application code
COPY . .

# Expose the app's port
EXPOSE 3000

# Start the app
CMD [ "node", "index.js" ]
