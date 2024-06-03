# Use the Node.js 18 image as the base image
FROM node:18

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and yarn.lock files to the working directory
COPY package.json yarn.lock ./

# Install project dependencies
RUN yarn install

# Install TypeScript and necessary declaration files as development dependencies
RUN yarn add --dev typescript @types/node @types/dockerode @types/express @types/cors

# Copy the rest of the project files to the working directory
COPY . .

# Build the TypeScript code
RUN yarn build

# Expose port 3000 for the application
EXPOSE 3000

# Start the application
CMD ["node", "dist/index.js"]
