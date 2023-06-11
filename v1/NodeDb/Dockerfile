# Base image
FROM mongo:4.1.8-xenial

# Set the root username and password
ENV MONGO_INITDB_ROOT_USERNAME $MONGO_USERNAME
ENV MONGO_INITDB_ROOT_PASSWORD $MONGO_PASSWORD

# Expose the MongoDB port
EXPOSE 27017

# Set the data directory as a volume
VOLUME /data/db

# Start MongoDB service
CMD ["mongod"]