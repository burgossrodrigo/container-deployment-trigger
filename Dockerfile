# Use the Node.js 18 image as the base image
FROM node:18

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and yarn.lock files to the working directory
COPY package.json yarn.lock ./

# Install project dependencies
RUN yarn install

# Install TypeScript and necessary declaration files as development dependencies
RUN yarn add --dev typescript @types/node @types/dockerode @types/express @types/cors @types/node

# Copy the rest of the project files to the working directory
COPY . .

# Expose port 3000 for the application
EXPOSE 3000

# Start the application
CMD ["npx", "ts-node", "index.ts"]