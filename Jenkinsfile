pipeline {
    agent none

    environment 
    {
        UE4_ROOT = '/home/jenkins/UnrealEngine_4.22'
    }

    options 
    {
        buildDiscarder(logRotator(numToKeepStr: '3', artifactNumToKeepStr: '3'))
    }
   
    stages 
    {

        stage('Setup') 
        {
            agent { label 'build' }
            steps 
            {
                sh 'make setup'
            }
        }

        stage('Build') 
        {
            agent { label 'build' }
            steps 
            {
                sh 'make LibCarla'
                sh 'make PythonAPI'
                sh 'make CarlaUE4Editor'
                sh 'make examples'
            }
            post 
            {
                always 
                {
                    archiveArtifacts 'PythonAPI/carla/dist/*.egg'
                    stash includes: 'PythonAPI/carla/dist/*.egg', name: 'eggs'
                }
            }
        }

        stage('Unit Tests') 
        {
            agent { label 'build' }
            steps 
            {
                sh 'make check ARGS="--all --xml"'
            }
            post 
            {
                always 
                {
                    junit 'Build/test-results/*.xml'
                    archiveArtifacts 'profiler.csv'
                }
            }
        }

        stage('Retrieve Content') 
        {
            agent { label 'build' }
            steps 
            {
                sh './Update.sh'
            }
        }

        stage('Package') 
        {
            agent { label 'build' }
            steps 
            {
                sh 'make package'
                sh 'make package ARGS="--packages=AdditionalMaps --clean-intermediate"'
            }
            post {
                always {
                    archiveArtifacts 'Dist/*.tar.gz'
                    stash includes: 'Dist/CARLA*.tar.gz', name: 'carla_package'
                }
            }
        }

        stage('Smoke Tests') 
        {
            agent { label 'gpu' }
            steps 
            {
                unstash name: 'eggs'
                unstash name: 'carla_package'
                sh 'tar -xvzf CARLA*.tar.gz Dist/'
                sh 'DISPLAY= ./Dist/CarlaUE4.sh -opengl --carla-rpc-port=3654 --carla-streaming-port=0 -nosound > CarlaUE4.log &'
                sh 'make smoke_tests ARGS="--xml"'
                sh 'make run-examples ARGS="localhost 3654"'
            }
            post 
            {
                always 
                {
                    archiveArtifacts 'CarlaUE4.log'
                    junit 'Build/test-results/smoke-tests-*.xml'
                }
            }
        }
    }
}
