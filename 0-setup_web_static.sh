#!/bin/bash

# Install Nginx if not already installed
if ! dpkg -l | grep -q nginx; then
    apt-get -y update
    apt-get -y install nginx
fi

# Create necessary directories if they don't exist
web_static_dir="/data/web_static"
test_release_dir="$web_static_dir/releases/test"
shared_dir="$web_static_dir/shared"

mkdir -p "$web_static_dir" "$test_release_dir" "$shared_dir"

# Create a fake HTML file for testing
echo "<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>" > "$test_release_dir/index.html"

# Create or recreate symbolic link
if [ -L "$web_static_dir/current" ]; then
    rm -f "$web_static_dir/current"
fi
ln -sf "$test_release_dir" "$web_static_dir/current"

# Give ownership of /data folder to ubuntu user and group recursively
chown -R ubuntu:ubuntu "$web_static_dir"

# Update Nginx configuration
config_file="/etc/nginx/sites-available/default"
nginx_config="location /hbnb_static/ {\n\talias $web_static_dir/current/;\n}\n"
if grep -q "location /hbnb_static/" "$config_file"; then
    sed -i "/location \/hbnb_static\//c\\$nginx_config" "$config_file"
else
    sed -i "s#server {#server {\n\t$nginx_config#" "$config_file"
fi

# Restart Nginx
service nginx restart

exit 0
