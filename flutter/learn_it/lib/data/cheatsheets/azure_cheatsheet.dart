import '../../models/cheatsheet.dart';

final Cheatsheet azureCheatsheet = Cheatsheet(
  category: 'Azure',
  summary: 'Microsoft Azure is a major enterprise cloud platform. This guide covers Virtual Machines, Blob Storage, VNets, and Entra ID (formerly Azure AD).',
  sections: [
    CheatsheetSection(
      title: 'Virtual Machines & Scaling',
      content: 'Azure Virtual Machines provide on-demand, high-performance virtual compute resources with support for Windows and Linux operating systems.',
      bulletPoints: [
        'Resource Groups: Logical containers hosting related Azure resources, making deployment and cleanup easy.',
        'Availability Sets: Logic grouping to ensure VMs are isolated from each other across power sources and hardware switches.',
        'Scale Sets: Automatically increase or decrease the number of identical VM instances based on demand.',
        'OS Support: Native integration with Windows Server, Active Directory, alongside top Linux distributions.',
      ],
      codeSnippet: '# Create a new Ubuntu VM in Azure using CLI\naz vm create \\\n  --resource-group learn-rg \\\n  --name webVM \\\n  --image Ubuntu22LTS \\\n  --admin-username azureuser \\\n  --generate-ssh-keys',
    ),
    CheatsheetSection(
      title: 'Blob Storage & Accounts',
      content: 'Azure Blob Storage is Microsoft\'s object storage solution for the cloud, highly optimized for storing massive amounts of unstructured data.',
      bulletPoints: [
        'Storage Accounts: The entry point for all storage, grouping Blobs, Files, Queues, and Tables.',
        'Blob Containers: Organizes sets of blobs, acting like a folder structure inside the storage account.',
        'Blob Types: Block Blobs (text/binary files), Page Blobs (random-access files up to 8TB), Append Blobs (optimized for logs).',
        'Access Tiers: Hot (active data), Cool (infrequent access), Archive (offline data, high latency).',
      ],
      codeSnippet: '# Upload a log file to an Azure Blob container\naz storage blob upload \\\n  --account-name mystorageacct \\\n  --container-name logs \\\n  --name app-log.txt \\\n  --file ./logs/app.txt',
    ),
    CheatsheetSection(
      title: 'Entra ID & Identity',
      content: 'Microsoft Entra ID (formerly Azure Active Directory) is a cloud-based identity and access management service.',
      bulletPoints: [
        'Tenant: A dedicated and isolated instance of Entra ID representing a single organization.',
        'Users and Groups: Entities who access resources; permissions can be assigned individually or via groups.',
        'App Registrations: Registers custom apps to enable sign-in and integration with APIs.',
        'Conditional Access: Rule-based policies (e.g. block users outside country or require MFA).',
      ],
      codeSnippet: '# Sign in to your Azure account interactively\naz login',
    ),
    CheatsheetSection(
      title: 'Cosmos DB & Relational Data',
      content: 'Azure offers globally distributed database options. Cosmos DB serves NoSQL needs, while Azure SQL is relational.',
      bulletPoints: [
        'Cosmos DB: Multi-model database offering single-digit millisecond latency and global replication.',
        'Azure SQL Database: Fully managed relational database built on the SQL Server engine.',
        'Database APIs: Cosmos DB supports SQL API, MongoDB, Cassandra, Gremlin, and Table API.',
      ],
      codeSnippet: '# Show details of an Azure SQL Database\naz sql db show \\\n  --resource-group learn-rg \\\n  --server sql-srv \\\n  --name customer-db',
    ),
  ],
);
