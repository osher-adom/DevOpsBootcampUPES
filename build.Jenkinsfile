pipeline {
    agent {
        docker {
            label 'ec2auto'
            image '854171615125.dkr.ecr.eu-west-1.amazonaws.com/jenkins-agent'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    stages {
        stage('Build') {
            steps {
                sh 'echo jenkins is building...'
            }
        }
    }
}
