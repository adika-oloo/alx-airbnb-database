
## 📁 create_and_test_indexes.py

```python
#!/usr/bin/python3
"""
Script to create indexes and measure performance
"""

import mysql.connector
import time
import os
from typing import Dict, Any, List

def get_db_connection():
    """Create database connection"""
    return mysql.connector.connect(
        host=os.getenv('DB_HOST', 'localhost'),
        user=os.getenv('DB_USER', 'root'),
        password=os.getenv('DB_PASSWORD', ''),
        database='ALX_prodev',
        port=os.getenv('DB_PORT', '3306')
    )

def execute_sql_file(filename: str):
    """Execute SQL commands from a file"""
    connection = get_db_connection()
    cursor = connection.cursor()
    
    try:
        with open(filename, 'r') as file:
            sql_commands = file.read().split(';')
            
            for command in sql_commands:
                command = command.strip()
                if command:
                    cursor.execute(command)
                    
        connection.commit()
        print(f"Successfully executed {filename}")
        
    except Exception as e:
        print(f"Error executing {filename}: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def measure_query_performance(query: str, description: str) -> float:
    """Measure query execution time"""
    connection = get_db_connection()
    cursor = connection.cursor()
    
    try:
        start_time = time.time()
        cursor.execute(query)
        results = cursor.fetchall()
        end_time = time.time()
        
        execution_time = (end_time - start_time) * 1000  # Convert to milliseconds
        print(f"{description}: {execution_time:.2f}ms ({len(results)} rows)")
        
        return execution_time
        
    except Exception as e:
        print(f"Error measuring query: {e}")
        return 0
    finally:
        cursor.close()
        connection.close()

def explain_query(query: str) -> List[Dict[str, Any]]:
    """Get EXPLAIN output for a query"""
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    try:
        cursor.execute(f"EXPLAIN {query}")
        return cursor.fetchall()
    except Exception as e:
        print(f"Error explaining query: {e}")
        return []
    finally:
        cursor.close()
        connection.close()

def main():
    """Main function to test index performance"""
    
    # Test queries
    test_queries = [
        ("SELECT * FROM user_data WHERE age > 25", "Age filter query"),
        ("SELECT * FROM user_data WHERE email = 'Molly59@gmail.com'", "Email lookup"),
        ("SELECT * FROM user_data WHERE age > 25 ORDER BY name LIMIT 100", "Age filter with sort"),
        ("SELECT age, COUNT(*) FROM user_data GROUP BY age", "Group by age")
    ]
    
    print("=== PERFORMANCE BEFORE INDEXES ===")
    before_times = {}
    for query, description in test_queries:
        explain_result = explain_query(query)
        print(f"\nEXPLAIN for {description}:")
        for row in explain_result:
            print(f"  {row}")
        
        time_taken = measure_query_performance(query, description)
        before_times[description] = time_taken
    
    # Create indexes
    print("\n=== CREATING INDEXES ===")
    execute_sql_file('database_index.sql')
    
    print("\n=== PERFORMANCE AFTER INDEXES ===")
    after_times = {}
    for query, description in test_queries:
        explain_result = explain_query(query)
        print(f"\nEXPLAIN for {description}:")
        for row in explain_result:
            print(f"  {row}")
        
        time_taken = measure_query_performance(query, description)
        after_times[description] = time_taken
    
    # Print comparison
    print("\n=== PERFORMANCE COMPARISON ===")
    for description in before_times:
        before = before_times[description]
        after = after_times[description]
        improvement = before / after if after > 0 else 0
        print(f"{description}: {before:.2f}ms -> {after:.2f}ms ({improvement:.1f}x improvement)")

if __name__ == "__main__":
    main()
