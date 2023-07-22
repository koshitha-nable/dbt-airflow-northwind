# DBT Northwind
<p align="left">
  <a href="http://20.2.72.244:8080/blue/organizations/jenkins/multibranch_demo/detail/develop/2/pipeline">
    <img src="https://raw.githubusercontent.com/jenkinsci/embeddable-build-status-plugin/b1c2c0cb228000fc41002d3fc6f2dd8f8ad5d0bb/src/doc/plastic_unconfigured.svg" alt="CI Badge"/>
  </a>
</p>

**[dbt](https://www.getdbt.com/)** enables data analysts and engineers to transform their data using the same practices that software engineers use to build applications.

![architecture](https://raw.githubusercontent.com/dbt-labs/dbt-core/202cb7e51e218c7b29eb3b11ad058bd56b7739de/etc/dbt-transform.png)

## Understanding dbt

Analysts using dbt can transform their data by simply writing select statements, while dbt handles turning these statements into tables and views in a data warehouse.

These select statements, or "models", form a dbt project. Models frequently build on top of one another – dbt makes it easy to [manage relationships](https://docs.getdbt.com/docs/ref) between models, and [visualize these relationships](https://docs.getdbt.com/docs/documentation), as well as assure the quality of your transformations through [testing](https://docs.getdbt.com/docs/testing).
<p align="left">
  <img src="https://github.com/nableanalytics/dbt-demo-northwind/assets/76805373/cdc3982f-6075-457d-8cb6-f06dec575502" alt="dbt logo" width="700"/>
</p>

## Overview

:wave: The following is a demo project to showcase setting up dbt - using dbt Core not Cloud - and Postgres. The aim of this project is to showcase familiarity with dbt, data modeling, and custom configurations using publicly available data from keggle and not necessarily SQL complexity.

## Project setup

1. Create new python virtual environment in order to avoice pip package conflicts. 
2. Install dbt Core & postgres adapter using pip.
3. Create a new Postgres db (`dbt_demo_db`)
4. Create a `profile.yml` file in the `.dbt` folder and add configurations for data warehouse.
5. :tada: run `dbt debug` to make sure connection worked (it did :D)
<p align="left">
  <img src="https://github.com/nableanalytics/dbt-demo-northwind/assets/76805373/4a586bff-9c53-4c3a-8811-ffe5de0d2faa" alt="dbt logo" width="700"/>
</p>


## Setting up project scaffolding

1. Create `intermediate` folder & `facts` folder inside models directory for basic project setup. Staging will be my transformed source data and facts will be my "final fact" models
2. added a `packages.yml` file so that I could install the `dbt utils` package which has [a lot of handy pre-built macros](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/) that can be reasily referenced & reused

## Northwind dataset

The [Northwind](https://www.kaggle.com/datasets/subhamila/northwind-graph-data) database is a sample database that was originally created by Microsoft and used as the basis for their tutorials in a variety of database products for decades. The Northwind database contains the sales data for a fictitious company called `Northwind Traders`, which imports and exports specialty foods from around the world. The Northwind database is an excellent tutorial schema for a small-business ERP, with customers, orders, inventory, purchasing, suppliers, shipping, employees, and single-entry accounting. The Northwind database has since been ported to a variety of non-Microsoft databases, including PostgreSQL.

The Northwind dataset includes sample data for the following.

- **Suppliers**: Suppliers and vendors of Northwind
- **Customers**: Customers who buy products from Northwind
- **Employees**: Employee details of Northwind traders
- **Products**: Product information
- **Shippers**: The details of the shippers who ship the products from the traders to the end-customers
- **Orders and Order_Details**: Sales Order transactions taking place between the customers & the company

### Install the project dependencies:
```sh
pip install -r requirements.txt
```
### Running the container

1. start required docker services with docker-compose-initiate database
    ```sh
     cd dockerairflow
     docker compose up airflow-init
     docker-compose build airflow-webserver

# Run the entire Docker Compose environment
docker-compose up

    ```
2. check all docker application services up and running 
    Running Airflow:
    ```sh
    docker compose up
    ```
3. Start the Airflow scheduler and web server:
    ```sh
    airflow scheduler
    airflow webserver -p 8080
    ```
### Configuration
1. Open the dbt_project.yml file and update the necessary configurations, such as **target database**, **credentials**, and other project-specific settings.
2. Configure your database connection by creating a **profiles.yml** file in the ~/.dbt directory. Refer to the [dbt Profiles Documentation](https://docs.getdbt.com/reference/warehouse-profiles) for more details.

## Running the project in local environments

#### Building Data Models ####
**To build the data models and transform your data, follow these steps:**

##### 1. Test the database connection and show information for debugging purposes ####
```sh
cd dbt_northwind
dbt debug
```
##### 2. Downloads dependencies for a project
```sh
dbt deps
```
##### 3. Loads CSV files into the database #####
```sh
dbt seed
```
This command will load csv files located in the seed-paths directory of your dbt project into your data warehouse.
##### 4. To execute the compiled SQL transformations and materialize the models, use the following command: #####
```sh
dbt run
```
Running this command will create or update the tables/views defined in your project. It applies the transformations defined in the models and loads the data into the target database.

##### If you want to perform a full refresh of the data models, including dropping and recreating the tables/views, use the following command: #####

```sh
dbt run --full-refresh
```
This command ensures that the data models reflect the latest state of the source data.

#### Testing ####
**To test the project models and ensure the accuracy of the transformations, follow these step:**
##### To execute the tests defined in your project, use the following command: ##### 
```sh
dbt test
```

This command runs the tests specified in this project, checking if the expected results match the actual data.

#### Documentation #### 
**To generate and view the documentation for this dbt project, follow these steps:**
##### 1. Generate the documentation by running the following command: #####
```sh
dbt docs generate
```
This command generates HTML pages documenting the models, tests, and macros in your project.
#####  2. Serve the documentation locally by running the following command: ##### 
```sh
dbt docs serve
```
This command starts a local web server to host the documentation. You can access it by opening your browser and visiting the provided URL.
**Note**: Remember to generate the documentation before serving it.


 Refer the [dbt commands](https://docs.getdbt.com/reference/dbt-commands) for more details.

#### Airflow Web UI
The Airflow Web UI provides a graphical interface for managing and monitoring workflows. Through the UI, you can:

- View and manage DAGs, including enabling/disabling DAGs and individual tasks.
- Trigger manual executions of tasks or entire DAGs.
- Monitor task status, logs, and execution history.
- Configure connections to external systems and variables for use within your DAGs.
- Define schedules and set up task dependencies.
- The Airflow Web UI offers a user-friendly way to interact with Airflow and gain insights into your workflows.

To access the Airflow Web UI, you need to follow these steps:

1. Install and Configure Airflow: Ensure that you have installed and configured Airflow on your machine or server. Refer to the official [Airflow documentation](https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html) for detailed instructions on installation and configuration.

2. Start the Airflow Web Server: Open a terminal or command prompt and navigate to the Airflow installation directory. Use the following command to start the Airflow web server:
    ```sh
    airflow webserver
    ```
- By default, the web server will listen on port 8080. If you want to use a different port, you can specify it using the -p or --port option followed by the desired port number.
3. Access the Airflow Web UI: Open a web browser and enter the following URL:
    ```sh
    http://localhost:8080
    ```
- If you started the web server on a different port, replace 8080 with the corresponding port number.

4. Login to the Airflow Web UI: You will be directed to the Airflow login page. Enter your username and password to log in. The default username and password are typically set to admin. Make sure to change the default credentials for security reasons.

5. Explore the Airflow Web UI: Once logged in, you will be presented with the Airflow Web UI. Here, you can perform various actions such as:

    - View and manage DAGs: The UI provides an overview of all your DAGs, their status, and configuration details. You can enable or disable DAGs, trigger manual runs, and view the DAG structure.

    - Monitor task execution: Check the status of individual tasks, view task logs, and track the execution history. You can identify successful runs, failed runs, and ongoing runs.

    - Configure connections and variables: Airflow allows you to define connections to external systems (e.g., databases, APIs) and variables (e.g., reusable configuration values). You can manage these configurations through the web UI.

    - Access additional features: The Airflow Web UI offers other functionalities, such as browsing logs, configuring access controls, and managing plugins. Explore the UI to leverage these features.

    Remember to secure access to the Airflow Web UI by configuring authentication and authorization mechanisms according to your requirements.

    By following these steps, you should be able to access and utilize the Airflow Web UI for managing and monitoring your workflows.
