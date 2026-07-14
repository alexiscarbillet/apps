import '../../models/cheatsheet.dart';

final Cheatsheet gcpCheatsheet = Cheatsheet(
  category: 'GCP',
  summary: 'Google Cloud Platform (GCP) provides highly scalable computing services. Learn key GCP concepts including Compute Engine, Cloud Storage, GKE, IAM, and BigQuery.',
  sections: [
    CheatsheetSection(
      title: 'Compute Engine & Cloud Run',
      content: 'GCP offers versatile compute options. Compute Engine provides managed Virtual Machines, while Cloud Run hosts containerized serverless applications.',
      bulletPoints: [
        'Compute Engine (GCE): Flexible VMs running in Google infrastructure. Highly customizable vCPUs and memory.',
        'Cloud Run: Serverless platform to run stateless containers. Automatically scales from zero to infinity.',
        'Machine Types: Pre-defined (e.g., e2-medium) or custom configurations of virtual compute cores and RAM.',
        'Disks: Persistent Disks (HDD/SSD) that can be attached to VMs.',
      ],
      codeSnippet: '# Create a Google Compute Engine VM instance\ngcloud compute instances create study-vm \\\n  --zone=us-central1-a \\\n  --machine-type=e2-medium \\\n  --image-family=ubuntu-2204-lts \\\n  --image-project=ubuntu-os-cloud',
    ),
    CheatsheetSection(
      title: 'Cloud Storage (GCS)',
      content: 'Cloud Storage is a flat, unified object storage service. It provides global access and high throughput for diverse data.',
      bulletPoints: [
        'Buckets: Organizes data. Located in a single region, multi-region, or dual-region.',
        'Storage Classes: Standard (active access), Nearline (once/month), Coldline (once/quarter), Archive (once/year).',
        'Object Lifecycle Management: Automatically transitions objects to cheaper storage classes or deletes them after set criteria.',
        'Access: Managed using IAM roles at the bucket level or fine-grained ACLs at the object level.',
      ],
      codeSnippet: '# Upload a directory of images to Cloud Storage\ngsutil -m cp -r ./images gs://my-assets-bucket/',
    ),
    CheatsheetSection(
      title: 'Google Kubernetes Engine (GKE)',
      content: 'GKE is Google\'s managed environment for deploying, managing, and scaling containerized applications using Kubernetes.',
      bulletPoints: [
        'Autopilot Mode: Google manages the entire cluster nodes, infrastructure, scaling, and security configurations.',
        'Standard Mode: Gives full manual control over the underlying nodes and cluster administration.',
        'Node Pools: A group of VM instances within a cluster that all share the same configuration.',
        'Integrations: Built-in support for Cloud Logging, Monitoring, and VPC network integration.',
      ],
      codeSnippet: '# Fetch credentials for a GKE cluster to use with kubectl\ngcloud container clusters get-credentials school-cluster \\\n  --zone us-central1-a',
    ),
    CheatsheetSection(
      title: 'BigQuery & Data Analytics',
      content: 'BigQuery is a fully managed, serverless enterprise data warehouse designed to analyze petabytes of data using SQL.',
      bulletPoints: [
        'Serverless Architecture: Computes and queries are separated, scaling resources dynamically.',
        'Columnar Storage: Stores tables column-by-column rather than row-by-row, accelerating analytical reads.',
        'Federated Queries: Queries data directly in external sources (GCS, Cloud SQL, Bigtable) without importing.',
        'Datasets: Logical containers used to organize and control access to tables and views.',
      ],
      codeSnippet: '# Query public dataset to find popular search terms\nSELECT query, COUNT(*) as count \nFROM `bigquery-public-data.google_trends.top_terms` \nGROUP BY query \nORDER BY count DESC \nLIMIT 10;',
    ),
  ],
);
