import '../../models/cheatsheet.dart';

final Cheatsheet awsCheatsheet = Cheatsheet(
  category: 'AWS',
  summary: 'Amazon Web Services (AWS) is a comprehensive cloud platform. This cheatsheet covers compute, storage, databases, networking, and security basics.',
  sections: [
    CheatsheetSection(
      title: 'EC2 & Compute Services',
      content: 'Elastic Compute Cloud (EC2) provides resizable virtual server instances in the cloud, forming the backbone of AWS compute infrastructure.',
      bulletPoints: [
        'Instance Types: Categorized by workload optimization (General Purpose, Compute, Memory, Storage, Accelerated).',
        'AMIs: Amazon Machine Images represent pre-configured operating system and application templates.',
        'Security Groups: Virtual firewalls controlling inbound and outbound traffic at the instance level (stateful).',
        'Key Pairs: Public/private keys used for secure SSH/RDP login into instances.',
      ],
      codeSnippet: '# Launch an EC2 instance with the CLI\naws ec2 run-instances \\\n  --image-id ami-0c55b159cbfafe1f0 \\\n  --instance-type t2.micro \\\n  --key-name MyKeyPair \\\n  --security-group-ids sg-903004f8',
    ),
    CheatsheetSection(
      title: 'S3 & Object Storage',
      content: 'Simple Storage Service (S3) is an object storage service designed for storing files, static website assets, and backups with 99.999999999% durability.',
      bulletPoints: [
        'Buckets and Objects: Files are stored as "objects" inside globally unique "buckets".',
        'Storage Classes: Optimized for cost (Standard, Intelligent-Tiering, Standard-IA, Glacier, Glacier Deep Archive).',
        'Access Control: Managed via Bucket Policies (JSON documents) or Access Control Lists (ACLs).',
        'Versioning: Keeps multiple versions of an object to protect against accidental overwrites or deletions.',
      ],
      codeSnippet: '# Upload a local file to an S3 bucket\naws s3 cp document.pdf s3://my-unique-bucket-name/documents/',
    ),
    CheatsheetSection(
      title: 'VPC & Networking',
      content: 'Virtual Private Cloud (VPC) lets you provision a logically isolated section of the AWS cloud where you can launch resources in a virtual network.',
      bulletPoints: [
        'Subnets: IP address ranges within a VPC. Can be Public (has route to Internet Gateway) or Private (no internet route directly).',
        'Internet Gateway (IGW): Allows communication between resources in your VPC and the internet.',
        'NAT Gateway: Allows private instances to access the internet safely but blocks inbound internet connections.',
        'Route Tables: A set of rules determining where network traffic from subnets gets directed.',
      ],
      codeSnippet: '# Describe existing VPCs in your default region\naws ec2 describe-vpcs',
    ),
    CheatsheetSection(
      title: 'IAM & Access Management',
      content: 'Identity and Access Management (IAM) controls authentication and authorization, managing who (or what) can access specific resources.',
      bulletPoints: [
        'Users and Groups: Users represent individuals; Groups aggregate users to apply common permissions.',
        'Roles: Temp credentials assigned to trusted entities like applications or other AWS services (e.g. EC2, Lambda).',
        'Policies: JSON documents defining what actions are Allowed or Denied on which resources.',
        'Least Privilege Principle: Best practice of granting only the minimum permissions required to perform a task.',
      ],
      codeSnippet: '{\n  "Version": "2012-10-17",\n  "Statement": [\n    {\n      "Effect": "Allow",\n      "Action": "s3:GetObject",\n      "Resource": "arn:aws:s3:::my-bucket/*"\n    }\n  ]\n}',
    ),
  ],
);
