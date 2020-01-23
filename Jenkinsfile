pipeline {
    agent any

    environment {
        UE4_ROOT = '/var/lib/jenkins/UnrealEngine_4.22'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '3', artifactNumToKeepStr: '3'))
    }

    stages {

        stage('Logging') {
            steps {
                sh 'echo UE4_ROOT'
            }
        }
    }

    post {
        always {
            deleteDir()
        }
    }
}
