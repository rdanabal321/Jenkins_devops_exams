pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub_user'
        DOCKERHUB_REPO = 'asram321'
        IMAGE_TAG = 'latest'
        NAMESPACE = 'staging'
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
                    docker.build("${DOCKERHUB_REPO}/cast-service:${IMAGE_TAG}", '-f cast-dockerfile .')
                    docker.build("${DOCKERHUB_REPO}/movie-service:${IMAGE_TAG}", '-f movie-dockerfile .')
                    docker.build("${DOCKERHUB_REPO}/nginx:${IMAGE_TAG}", '-f nginx-dockerfile .')
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
        
        stage('Helm Install') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: 'KubCluster', contextName: '', credentialsId: 'kub_secret', namespace: 'prod', serverUrl: 'https://192.168.1.24:6443']]) {
                    sh 'helm install fastapiapp-staging ./fastapiapp-0.1.0.tgz --namespace staging -f fastapiapp/values-staging.yaml'
}
            }
        }
    }
}
