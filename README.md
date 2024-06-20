
# Composer-ELT

Composer-ELT is a project designed to showcase the provisioning of a Data mart in BigQuery and leverage Cloud Composer for the Extract, Load, and Transform (ELT) process using Apache Airflow.  

The motivating scenario is that of a multinational retail company operating across Europe. The primary goal of this project is to provide analysts in said organization 

with a "Silver" table against which to executer queries. The table's partition, along with its dependent staging tables, is updated daily from source systems using Airflow DAGs leveraging GCP operators. 

## Project Structure

- **terraform/**: Contains the Terraform configurations for provisioning the necessary GCP resources.
  - **schemas/**: JSON schema files for BigQuery tables, designed to leverage partitioning and clustering.
  - **build.sh**: Script to deploy resources using Terraform.
- **dags/**: The Python DAGs to orchetrate the ELT processes.
  - **data/sql/**: SQL queries that utilize the partitioned and clustered BigQuery tables.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- Google Cloud Platform account
- Google Cloud SDK installed
- Python 3.6 or later
- Terraform installed

## Setup

### Step 1: Configure GCP Project

Set your GCP project ID:

```bash
gcloud config set project <PROJECT_ID>
```

### Step 2: Deploy Resources via Terraform

Navigate to the `terraform/` directory and run the deployment script:

```bash
cd terraform
./build.sh apply
```

This script will:
- Provision a BigQuery dataset and tables using the provided schema JSON files.
- Set up a VPC with a private subnet.
- Create a Composer environment with a private IP.
- Assign a custom service account with the necessary roles for BigQuery.

## Local Testing

For local development and testing, you can use the [`composer-local-dev`](https://github.com/GoogleCloudPlatform/composer-local-dev) project, which creates a local Composer image based on your Composer environment in GCP. A fork of this project is linked as a submodule. Scripts for creating and authenticating this local Composer image are provided in the `dev/` directory.

### Step 1: Create Local Composer Image

Run `pip install dev/composer-local-dev` to install the forked `composer-local-dev` project. Then, create and start the local Composer environment with `./dev/create_composer_env.sh`. Access the Airflow UI on port 8080.

### Step 2: Authenticate Local Composer Image

Use the provided script `dev/setup_composer_credentials.sh` to authenticate as the Composer environment service account with Application Default Credentials. This needed to run the DAGs with the required permissions. 

## Work in Progress

The provided DAG is a work in progress. Current efforts are focused on developing a data generation mechanism and simulated transactional database for a more realistic scenario.
