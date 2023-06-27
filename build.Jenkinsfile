pipeline {
    agent {
        docker {
            image '700935310038.dkr.ecr.us-west-2.amazonaws.com/<repo-name>'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
        timestamps()
    }

    environment {
        IMAGE_NAME = '<img-name>'
        IMAGE_TAG = "${GIT_COMMIT}"
        REPO_URL = '700935310038.dkr.ecr.us-west-2.amazonaws.com'
    }

    stages {
        stage('ECR Login') {
            steps {
                sh 'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 700935310038.dkr.ecr.us-west-2.amazonaws.com'
            }
        }
        stage('Image Build') {
            steps {
                sh "cd yolo5 && docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }


        stage('Image Push') {
            steps {
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REPO_URL}/${IMAGE_NAME}:${IMAGE_TAG}"
                sh "docker push ${REPO_URL}/${IMAGE_NAME}:${IMAGE_TAG}"
            }
            post {
                    always {
                        sh 'docker image prune -a --filter "until=64h" --force'
                    }
                }
        }
    }
}
