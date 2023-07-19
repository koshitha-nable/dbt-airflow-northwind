pipeline {

    agent { docker { image 'python' } }

    stages {
        
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
                sh """
                echo "Cleaned Up Workspace For Project"
                """
            }
        }

        stage('Code Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/develop' ]],
                    extensions: scm.extensions,
                    userRemoteConfigs: [[
                        url: 'https://github.com/nableanalytics/dbt-demo-northwind.git',
                        credentialsId: 'cf325171-7467-4ac3-8016-68fee3c83361'
                ]]
            ])
            }
        }

        stage('DBT Enviornment setup') {
            steps {
                sh """
                # install required py dep
                virtualenv -p python3.8 venv
                . venv/bin/activate 
                pip install -r requirement.txt

                # change into dbt project
                echo "Changing dir to dbt project"
                cd dbt_northwind
                echo "Installing dbt dependancies"
                dbt deps
                """
            }
        }

        stage(' Dev deployment') {
            steps {
                sh """
                . venv/bin/activate
                cd dbt_northwind
                echo "Running dbt models"
                dbt run --full-refresh --target dev
                """
            }
        }

        stage(' DBT Unit Testing') {
            input {
                message "Approval and env choise for dbt test?"
                ok "Submit"
                parameters {
                    string(name: "TEST_ENV", defaultValue: "dev")
                }
            }
            steps {
                sh '''
                echo "Selected $TEST_ENV enviornment for testing"
                . venv/bin/activate
                cd dbt_northwind
                echo "Running dbt Unit Tests"
                dbt test --target $TEST_ENV
                '''
            }
        }

        stage('Production Deployment') {
            when {
                beforeInput true
                branch 'develop'
            }
            input {
                message "Can we deploy it on Production ?"
                ok "Yes"
                parameters {
                    string(name: "DEPLOY_ENV", defaultValue: "prod")
                }
            }
            steps {
                sh '''
                 echo "Production Deployment approved"
                . venv/bin/activate
                cd dbt_northwind
                dbt run --full-refresh --target $DEPLOY_ENV
                '''
            }
        }

        stage('Code Analysis') {
            steps {
                sh """
                echo "Running Code Analysis"
                """
            }
        }

        stage('Build Deploy Code') {
            when {
                branch 'develop'
            }
            steps {
                sh """
                echo "Building Artifact"
                """

                sh """
                echo "Deploying Code"
                """
            }
        }

    }   
}
