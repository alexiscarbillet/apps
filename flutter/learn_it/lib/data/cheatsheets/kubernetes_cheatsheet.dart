import '../../models/cheatsheet.dart';

final Cheatsheet kubernetesCheatsheet = Cheatsheet(
  category: 'Kubernetes',
  summary: 'Kubernetes (K8s) is an open-source platform for automating deployment, scaling, and management of containerized applications.',
  sections: [
    CheatsheetSection(
      title: 'Pods & Deployments',
      content: 'Pods and Deployments are the primary workload objects in Kubernetes, representing runtime instances of containers.',
      bulletPoints: [
        'Pod: The smallest deployable unit. It represents a single instance of a running process and shares storage, network, and configuration.',
        'Deployment: A controller that manages declarative updates for Pods and ReplicaSets (handling replica count, rollouts, rollbacks).',
        'ReplicaSet: Ensures a specified number of Pod replicas are running at any given time.',
      ],
      codeSnippet: '# View resources in the current cluster\nkubectl get deployments\nkubectl get pods -o wide\nkubectl describe pod my-web-pod',
    ),
    CheatsheetSection(
      title: 'Services & Ingress',
      content: 'Since Pod IPs are volatile and change when pods recreate, Services and Ingress provide stable networking access to workloads.',
      bulletPoints: [
        'ClusterIP: Exposes the Service on an internal cluster IP (accessible only within the cluster).',
        'NodePort: Exposes the Service on each Node\'s IP at a static port (typically 30000-32767).',
        'LoadBalancer: Creates an external load balancer in the cloud provider and assigns a public IP.',
        'Ingress: Manages external access to the services, acting as an application layer (Layer 7) HTTP/HTTPS reverse proxy.',
      ],
      codeSnippet: '# Expose a deployment as a ClusterIP service\nkubectl expose deployment frontend \\\n  --port=80 \\\n  --target-port=8080 \\\n  --type=ClusterIP',
    ),
    CheatsheetSection(
      title: 'ConfigMaps & Secrets',
      content: 'Kubernetes decouples application configuration and credentials from container images using ConfigMaps and Secrets.',
      bulletPoints: [
        'ConfigMap: Stores non-sensitive configurations as key-value pairs, injected as environment variables or volume mounts.',
        'Secret: Stores sensitive data (passwords, API keys, credentials) encoded in Base64.',
        'Best Practice: Never store actual secrets in Git repositories; use external managers or encrypted volumes.',
      ],
      codeSnippet: '# Create a secret from literal key-value pairs\nkubectl create secret generic db-pass \\\n  --from-literal=password=\'SuperSecret123\'',
    ),
    CheatsheetSection(
      title: 'Cluster Architecture & Nodes',
      content: 'A Kubernetes cluster is composed of a Control Plane (management) and Worker Nodes (computing infrastructure).',
      bulletPoints: [
        'Control Plane components: kube-apiserver (API entrypoint), etcd (state database), kube-scheduler, kube-controller-manager.',
        'Worker Node components: kubelet (node agent enforcing pod specs), kube-proxy (network rules controller), container runtime (e.g. containerd).',
        'Namespaces: Virtual clusters inside a single physical cluster, providing resource scoping and access control isolation.',
      ],
      codeSnippet: '# Check node statuses in the cluster\nkubectl get nodes\nkubectl top node',
    ),
  ],
);
