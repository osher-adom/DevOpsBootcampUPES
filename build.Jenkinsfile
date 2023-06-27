pipeline {
    agent {
        docker {
	    label 'ec2auto'
            image '854171615125.dkr.ecr.eu-west-1.amazonaws.com/jenkins-agent'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    options {
        timeout(time: 35, unit: 'MINUTES')
        timestamps()
    }

    environment {
        IMAGE_NAME = 'osher-yolo5'
        IMAGE_TAG = "${GIT_COMMIT}"
        REPO_URL = '854171615125.dkr.ecr.eu-west-1.amazonaws.com/jenkins-agent'
    }

    stages {
	stage('ECR Login') {
            steps {
                sh 'aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 854171615125.dkr.ecr.eu-west-1.amazonaws.com'
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
