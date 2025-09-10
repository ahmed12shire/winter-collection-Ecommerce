# Use Nginx image as base
FROM nginx:latest AS prod

# Copy all static files from the 'app' folder into the Nginx HTML directory
COPY app/ /usr/share/nginx/html

# Change ownership of the Nginx HTML directory to the nginx user and group (default user in Nginx)
RUN chown -R nginx:nginx /usr/share/nginx/html

# Expose port 80 (default for Nginx)
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
