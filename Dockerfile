# Use the official Node.js 18 image from Docker Hub
FROM node:18

# Create a directory in the container to hold the application code
WORKDIR /usr/src/app

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Install dependencies including development dependencies
# This is necessary for the `nest build` command to work
RUN yarn install

# Copy the rest of the application code to the workdir
COPY . .

# Expose port 3000 for the application
EXPOSE 3000

# Start the application
CMD [ "npm", "start" ]