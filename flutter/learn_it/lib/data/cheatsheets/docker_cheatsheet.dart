import '../../models/cheatsheet.dart';

final Cheatsheet dockerCheatsheet = Cheatsheet(
  category: 'Docker',
  summary: 'Docker packages applications and dependencies into portable containers so they run consistently across environments, from laptops to production clusters.',
  sections: [
    CheatsheetSection(
      title: 'Images, Containers, and Layers',
      content: 'A Docker image is a read-only template built from a Dockerfile. A container is a running instance of that image, and each filesystem change adds a new layer to the image stack.',
      bulletPoints: [
        'Image: portable package containing code, runtime, libraries, and config.',
        'Container: running process with isolated filesystem, network, and PID namespace.',
        'Layered filesystem: each instruction in a Dockerfile creates a cached layer for efficient rebuilds.',
        'Union filesystem: combines layers to present one coherent filesystem view.',
      ],
      codeSnippet: r'''# Build an image from a Dockerfile
docker build -t myapp:1.0 .

docker run --name myapp -p 8080:80 myapp:1.0''',
    ),
    CheatsheetSection(
      title: 'Dockerfile Fundamentals',
      content: 'A Dockerfile defines how an image is assembled, including the base OS, application code, dependencies, and startup command.',
      bulletPoints: [
        'FROM: base image, such as ubuntu, node, or python.',
        'WORKDIR: sets the working directory for subsequent instructions.',
        'COPY/ADD: place application files into the image.',
        'RUN: execute dependency installation or build steps.',
        'CMD/ENTRYPOINT: define the default process run when the container starts.',
      ],
      codeSnippet: r'''FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
EXPOSE 3000
CMD ["npm", "start"]''',
    ),
    CheatsheetSection(
      title: 'Networking and Storage',
      content: 'Docker isolates workloads while still enabling communication through networks and persisting data with volumes or bind mounts.',
      bulletPoints: [
        'Bridge network: default internal Docker network for containers on the same host.',
        'Host network: container shares the host network namespace for direct access to ports.',
        'Volumes: managed Docker storage that persists independently from the container lifecycle.',
        'Bind mounts: map a host path directly into a container for development or configuration.',
      ],
      codeSnippet: r'''# Publish port 8080 on host to 80 in container
docker run -p 8080:80 nginx

# Mount a host directory into a container
docker run -v $(pwd):/app myapp''',
    ),
    CheatsheetSection(
      title: 'Compose and Multi-Container Apps',
      content: 'Docker Compose defines services, configuration, networks, and volumes in a single YAML file so a full stack can be run with a single command.',
      bulletPoints: [
        'services: each service represents a container, such as app, db, or redis.',
        'depends_on: orders startup between services.',
        'volumes: persist database or app state across restarts.',
        'environment: inject configuration values without baking secrets into images.',
      ],
      codeSnippet: r'''services:
  web:
    build: .
    ports:
      - "8080:80"
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: secret
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:''',
    ),
    CheatsheetSection(
      title: 'Security and Operations',
      content: 'Containers are efficient but require secure image selection, least-privilege configuration, and regular monitoring to reduce risk.',
      bulletPoints: [
        'Use minimal base images such as distroless or alpine to reduce attack surface.',
        'Run as a non-root user and avoid privileged containers unless required.',
        'Scan images for CVEs using tools like Trivy or Docker Scout.',
        'Use secrets management instead of embedding credentials in Dockerfiles or compose files.',
      ],
      codeSnippet: r'''docker run --read-only --cap-drop ALL --user 1001:1001 myapp

docker image ls
docker ps
docker logs myapp''',
    ),
  ],
);
