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
