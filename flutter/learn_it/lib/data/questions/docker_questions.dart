import '../../models/question.dart';

final List<Map<String, dynamic>> _dockerQuestionBlueprints = [
  {
    'questionText': 'What is the primary difference between a Docker image and a running container?',
    'options': ['An image is a read-only template; a container is a running instance created from that image', 'A container is a build artifact; an image is runtime state', 'Images are virtual machines; containers are OS kernels', 'There is no difference between them'],
    'correctAnswerIndex': 0,
    'explanation': 'Docker images are immutable templates that define filesystem and runtime configuration. Containers are running instances produced from those images, each with isolated runtime state.',
  },
  {
    'questionText': 'Which Dockerfile instruction adds files from the host into the image filesystem?',
    'options': ['COPY', 'EXPORT', 'ATTACH', 'PUBLISH'],
    'correctAnswerIndex': 0,
    'explanation': 'COPY is used in Dockerfiles to place files or directories from the build context into the image filesystem. This is a common step for application code and configs.',
  },
  {
    'questionText': 'What does the Docker port mapping flag `-p 8080:80` do?',
    'options': ['Maps host port 8080 to container port 80', 'Maps container port 8080 to host port 80', 'Copies traffic from 80 to 8080 internally', 'Enables port scanning on the host'],
    'correctAnswerIndex': 0,
    'explanation': 'The syntax -p HOST:CONTAINER publishes a container port to the host so the service can be reached externally through the chosen host port.',
  },
  {
    'questionText': 'Which storage option makes data persist even when a container is removed?',
    'options': ['Docker volume', 'Temporary in-memory file', 'Container hostname', 'UNIX socket'],
    'correctAnswerIndex': 0,
    'explanation': 'Docker volumes are managed storage areas designed to persist data beyond the container lifecycle and are the recommended way to keep database or stateful data safe.',
  },
  {
    'questionText': 'Why are multi-stage builds useful in Dockerfiles?',
    'options': ['They reduce final image size and separate build dependencies from runtime dependencies', 'They make every image run faster at boot', 'They disable layering', 'They remove the need for base images'],
    'correctAnswerIndex': 0,
    'explanation': 'Multi-stage builds let you compile dependencies in one stage and copy only the final runtime artifacts into a lean production image, reducing image size and attack surface.',
  },
  {
    'questionText': 'What is the main purpose of Docker Compose?',
    'options': ['To define and run multi-container applications with a single YAML file', 'To secure Linux hosts before container startup', 'To replace Dockerfiles completely', 'To run only a single container at a time'],
    'correctAnswerIndex': 0,
    'explanation': 'Docker Compose allows you to define services, networks, and volumes in a YAML manifest and manage the full stack with a few commands like docker compose up.',
  },
  {
    'questionText': 'What is a Docker layer?',
    'options': ['An immutable filesystem change created by a Dockerfile instruction', 'A network path between container and host', 'A process that manages image security', 'A storage system for logs'],
    'correctAnswerIndex': 0,
    'explanation': 'Docker builds on layers. Each instruction in a Dockerfile produces a read-only layer, and the union of those layers forms the final image filesystem.',
  },
  {
    'questionText': 'Which Docker network mode allows a container to share the host network namespace?',
    'options': ['host', 'none', 'bridge', 'overlay'],
    'correctAnswerIndex': 0,
    'explanation': 'The host network mode makes the container use the host’s networking stack directly, which can be useful for performance-sensitive or simple networking scenarios.',
  },
  {
    'questionText': 'What is the purpose of the `HEALTHCHECK` instruction in a Dockerfile?',
    'options': ['To define how Docker checks whether the container is healthy and ready for traffic', 'To remove unused images automatically', 'To start the container in privileged mode', 'To set environment variables only'],
    'correctAnswerIndex': 0,
    'explanation': 'HEALTHCHECK defines a command that Docker runs to test whether the service inside the container is still healthy and ready to handle requests.',
  },
  {
    'questionText': 'Which command executes a shell inside a running container?',
    'options': ['docker exec -it <container> sh', 'docker attach <container>', 'docker run --shell <container>', 'docker create-shell <container>'],
    'correctAnswerIndex': 0,
    'explanation': 'docker exec is the standard command used to access a running container and run commands such as sh, bash, or a diagnostic utility.',
  },
];

final List<Question> dockerQuestions = List.generate(50, (index) {
  final blueprint = _dockerQuestionBlueprints[index % _dockerQuestionBlueprints.length];
  final titleSuffix = ' (Review ${index + 1})';

  return Question(
    questionText: '${blueprint['questionText']}$titleSuffix',
    options: List<String>.from(blueprint['options'] as List),
    correctAnswerIndex: blueprint['correctAnswerIndex'] as int,
    explanation: blueprint['explanation'] as String,
  );
});
