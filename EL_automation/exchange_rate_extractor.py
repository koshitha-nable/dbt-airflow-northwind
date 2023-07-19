import requests
import json
import psycopg2
from psycopg2 import OperationalError

def retrieve_exchange_rates(api_key):
    # Set the API endpoint URL
    url = f"http://api.exchangeratesapi.io/v1/latest?access_key={api_key}"

    try:
        # Send a GET request to the API
        response = requests.get(url)

        # Check if the request was successful
        if response.status_code == 200:
            # Retrieve the JSON data from the response
            data = response.json()

            # Extract the required information
            base = data['base']
            rates = data['rates']

            # Create a new dictionary with the extracted data
            extracted_data = {'base': base, 'rates': rates}

            return extracted_data

        else:
            print("Request failed. Status code:", response.status_code)
    except requests.exceptions.RequestException as e:
        print("An error occurred:", e)


    
    # PostgreSQL connection details
    db_host = "20.2.72.244"
    db_port = "5432"
    db_name = "dbt_demo_db"
    db_user = "postgres"
    db_password = "postgres"

    # Establish PostgreSQL connection
    try:
        conn = psycopg2.connect(
            host=db_host,
            database=db_name,
            user=db_user,
            password=db_password
        )
        cursor = conn.cursor()
        
    except Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
        exit(1)

    # Parse the JSON data
    relevant_data = json.loads(json_data)

    print(relevant_data['rates'])

    # Prepare and execute SQL query to insert exchange rates into PostgreSQL
    try:
        for currency, rate in relevant_data.items():
            query = "INSERT INTO dbt_dim_dev.dim_exchange_rates (currency,exchange_rate) VALUES(%s,%s) ON CONFLICT (currency) DO UPDATE SET exchange_rate = EXCLUDED.exchange_rate"
            data = (currency, rate)
            cursor.execute(query, data)

        conn.commit()
        print("Exchange rates inserted successfully!")
    except Error as e:
        print(f"Error inserting exchange rates into PostgreSQL: {e}")

    # Close the database connection
    cursor.close()
    conn.close()


def check_postgres_connection(host, port, database, user, password):

    """
        check postgres connection

    """

    try:
        # Connect to the PostgreSQL database
        connection = psycopg2.connect(
            host=host,
            port=port,
            database=database,
            user=user,
            password=password
        )
        
        # Print the PostgreSQL connection properties
        print("Connection established:")
        print(f"  Host: {connection.get_dsn_parameters()['host']}")
        print(f"  Port: {connection.get_dsn_parameters()['port']}")
        print(f"  Database: {connection.get_dsn_parameters()['dbname']}")
        print(f"  User: {connection.get_dsn_parameters()['user']}")
        
        # Close the connection
        return connection
        
    except OperationalError as error:
        print("Error while connecting to PostgreSQL:", error)

# Call the function to check the PostgreSQL connection
#check_postgres_connection()



def load_rates_to_postgres(data, host, port, database, user, password):
    """
    Load rates data into a PostgreSQL table.

    Args:
        data (dict): A dictionary containing currency rates data.
            It should have the keys 'base' and 'rates'.

    Returns:
        None
    """
    try:
        # Connect to the PostgreSQL database
        connection = check_postgres_connection(host, port, database, user, password)

        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()

        # Create the table if it doesn't exist
        create_table_query = """
        CREATE TABLE IF NOT EXISTS dbt_dim_dev.dim_exchange_rates (
            currency_code VARCHAR(3) PRIMARY KEY,
            rate FLOAT
        );
        """
        cursor.execute(create_table_query)

        # Insert rates data into the table
        insert_query = """
        INSERT INTO dbt_dim_dev.dim_exchange_rates (currency_code, rate) VALUES (%s, %s)
        ON CONFLICT (currency_code)
        DO UPDATE SET rate = EXCLUDED.rate;
        """
        for currency, rate in data['rates'].items():
            cursor.execute(insert_query, (currency, rate))

        # Commit the transaction
        connection.commit()

        # Close the cursor and the connection
        cursor.close()
        connection.close()

        print("Rates data loaded successfully!")

    except OperationalError as error:
        print("Error while connecting to PostgreSQL:", error)



def main():
    api_key = '4c95b58a0f6a27427afe4b78841aaf9b'
    # Define the public connection details as variables
    host = "20.2.72.244"
    port = "5432"
    database = "dbt_demo_db"
    user = "postgres"
    password = "postgres"

    data = retrieve_exchange_rates(api_key)
    print(data)
    rates = data['rates']

    print("\nbase currency " + data['base'])
    # load_exchange_rates_data(data)
    load_rates_to_postgres(data, host, port, database, user, password)


if __name__ == "__main__":
    main()

