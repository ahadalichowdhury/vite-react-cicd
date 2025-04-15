# Build stage
FROM node:20-alpine AS build

WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the source code and build the app
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine AS production

WORKDIR /app

# Install serve globally
RUN npm install -g serve

# Copy the Vite build output (from dist folder)
COPY --from=build /app/dist /app/build

# Expose the port Vite app will run on
EXPOSE 5173

# Serve the build folder using `serve` on port 5173
CMD ["serve", "-s", "build", "-l", "5173"]
