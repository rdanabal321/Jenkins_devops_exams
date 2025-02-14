pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub_user'
        DOCKERHUB_REPO = 'asram321'
        IMAGE_TAG = 'latest'
        NAMESPACE = 'prod'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    docker.build("${DOCKERHUB_REPO}/cast-service:${IMAGE_TAG}", '-f cast-service/Dockerfile .')
                    docker.build("${DOCKERHUB_REPO}/movie-service:${IMAGE_TAG}", '-f movie-service/Dockerfile .')
                    docker.build("${DOCKERHUB_REPO}/nginx:${IMAGE_TAG}", '-f nginx/Dockerfile .')
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        docker.image("${DOCKERHUB_REPO}/cast-service:${IMAGE_TAG}").push()
                        docker.image("${DOCKERHUB_REPO}/movie-service:${IMAGE_TAG}").push()
                        docker.image("${DOCKERHUB_REPO}/nginx:${IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Helm Package') {
            steps {
                sh 'helm package fastapiapp'
            }
        }

        stage('Manual Approval') {
            steps {
                input message: 'Approve deployment to production?', ok: 'Deploy'
            }
        }

        stage('Helm Install') {
            steps {
                sh 'helm install fastapiapp-prod ./fastapiapp-0.1.0.tgz --namespace prod -f fastapiapp/values-prod.yaml'
            }
        }
    }
}