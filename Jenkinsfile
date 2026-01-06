pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {
        APP_NAME = 'demo-app'
    }

    parameters {
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
                allOf {
                    expression { params.DEPLOY == true }
                    expression {
                        params.ENV != 'prod' ||
                        currentBuild.rawBuild.getCause(
                          hudson.model.Cause$UserIdCause
                        ) != null
                    }
                }
            }
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            steps {
                retry(2) {
                    echo "Deploying ${APP_NAME} to ${params.ENV}"
                }
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
        always {
            cleanWs()
        }
    }
}
