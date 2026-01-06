pipeline {
    agent any

    options{
        timestamps()
        disableCoucurrentBuilds()
        timeout(time: 30, unit: 'MINUTES')

    }

    tools {
        nodejs 'node18'
    }

    environment {
        APP_NAME = 'demo-app'
    }

    parameters {
        string(
            name: 'BRANCH',
            defaultValue: 'main',
            description: 'Branch to deploy'
        )
        choice(
            name: 'ENV',
            choices: ['dev', 'stage', 'prod'],
            description: 'Target environment'
        )
        booleanParam(
            name: 'DEPLOY',
            defaultValue: false,
            description: 'Deploy application'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: params.BRANCH,
                    url: 'https://github.com/org/repo.git'
            }
        }

        stage('Build') {
            steps {
                echo "Building ${APP_NAME} for ${params.ENV}"
            }
        }

        stage('Testing') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        echo 'Running unit tests'
                    }
                }
                stage('E2E Tests') {
                    steps {
                        echo 'Running integration tests'
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                expression { params.DEPLOY == true }
                expression{ param.ENV != 'prod' ||currentBuild.rawBuild.getCause(hudson.model.Cause$UserIdCause) != null }
                }
            }
            options {
                timeout(time: 10, unit: 'MINUTES') // deploy must not hang
            }
            steps {
                retry(2) {   // retry only deploy infra calls
                    echo "Deploying ${APP_NAME} to ${params.ENV}"
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded'
        }
        failure {
            echo 'Pipeline failed'
        }

        always{
            mail: "echo pipeline executed"
            cleanWs()

        }
    }
}
