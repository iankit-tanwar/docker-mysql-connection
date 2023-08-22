# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package sources and install necessary packages
RUN apt-get update && apt-get install -y \
    mysql-server \
    && rm -rf /var/lib/apt/lists/*

# Set the root user password (replace 'rootpassword' with your desired password)
RUN echo 'mysql-server mysql-server/root_password password rootpassword' | debconf-set-selections && \
    echo 'mysql-server mysql-server/root_password_again password rootpassword' | debconf-set-selections

# Bind MySQL to all network interfaces
RUN sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Create a new MySQL user (replace 'ankit' and 'ankit@123' with your desired values)
RUN service mysql start && \
    mysql -u root -prootpassword -e "CREATE USER 'ankit'@'%' IDENTIFIED BY 'ankit@123';" && \
    mysql -u root -prootpassword -e "GRANT ALL PRIVILEGES ON *.* TO 'ankit'@'%';" && \
    mysql -u root -prootpassword -e "FLUSH PRIVILEGES;"

# Expose the MySQL port
EXPOSE 3306

# Start the MySQL service on container startup
CMD ["mysqld"]

# Note: This Dockerfile doesn't handle secure MySQL setup for production use. For that, additional configuration is required.
