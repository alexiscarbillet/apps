import '../../models/cheatsheet.dart';

final Cheatsheet sqlCheatsheet = Cheatsheet(
  category: 'SQL',
  summary: 'Relational database queries, joins, aggregations, transaction safety (ACID), and indexes.',
  sections: [
    CheatsheetSection(
      title: 'Basic Querying & Joins',
      content: 'Structured Query Language (SQL) retrieves data from relational tables, using JOINs to link records across primary and foreign key definitions.',
      bulletPoints: [
        'INNER JOIN: Returns rows when there is a match in both tables.',
        'LEFT (OUTER) JOIN: Returns all rows from left table, and matching rows from right. Non-matches yield NULL values.',
        'RIGHT JOIN: Returns all rows from right table, and matching rows from left.',
        'FULL OUTER JOIN: Returns records if a match exists in either left or right tables.',
      ],
      codeSnippet: '-- Join users and order details\nSELECT u.id, u.username, o.order_date, o.total_amount\nFROM users u\nINNER JOIN orders o ON u.id = o.user_id\nWHERE o.status = \'Completed\';',
    ),
    CheatsheetSection(
      title: 'Grouping & Aggregations',
      content: 'Aggregating rows to calculate mathematical metrics across subsets of data.',
      bulletPoints: [
        'Aggregate Functions: COUNT(), SUM(), AVG(), MIN(), MAX().',
        'GROUP BY: Groups rows sharing identical field values so calculations can run per group.',
        'HAVING: Filters aggregated groups. (Note: `WHERE` filters rows *before* aggregation, `HAVING` filters groups *after*).',
      ],
      codeSnippet: '-- Count orders per customer and filter groups with > 3 orders\nSELECT user_id, COUNT(id) as total_orders, SUM(total_amount) as total_spent\nFROM orders\nGROUP BY user_id\nHAVING COUNT(id) > 3\nORDER BY total_spent DESC;',
    ),
    CheatsheetSection(
      title: 'ACID Transactions',
      content: 'Transactions group multiple SQL statements into a single unit of work to guarantee database integrity.',
      bulletPoints: [
        'Atomicity: All operations in the transaction succeed, or the entire transaction is rolled back (all or nothing).',
        'Consistency: Transaction moves the database from one valid state to another, maintaining constraints.',
        'Isolation: Concurrent transactions run independently without interfering with each other.',
        'Durability: Committed updates are permanently written to non-volatile storage and survive crashes.',
      ],
      codeSnippet: 'BEGIN TRANSACTION;\n  UPDATE accounts SET balance = balance - 250.00 WHERE id = 12;\n  UPDATE accounts SET balance = balance + 250.00 WHERE id = 45;\nCOMMIT; -- Or ROLLBACK; if errors occur',
    ),
    CheatsheetSection(
      title: 'Indexes & Query Optimization',
      content: 'Database indexing significantly speeds up search queries at the cost of slower writes and additional disk space.',
      bulletPoints: [
        'B-Tree Index: Default index type, optimizing equality and range search operations.',
        'Full Table Scan: An expensive operation where the database engine reads every row in a table to find matches (occurs on unindexed columns).',
        'Composite Index: An index built on multiple columns, optimized for queries filtering on those specific fields.',
      ],
      codeSnippet: '-- Create an index to optimize user lookups by email\nCREATE INDEX idx_users_email ON users(email);',
    ),
  ],
);
