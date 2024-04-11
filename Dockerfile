# Use the official Python image as the base image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Copy the Python script into the container at /app
COPY myapp3 .

# Install Flask
RUN pip install Flask

# Expose port 8080 to the outside world
EXPOSE 5000

# Run the Python script when the container launches
CMD ["python", "myapp3.py"]
