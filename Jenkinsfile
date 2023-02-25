pipeline {
    agent any
    options {
        skipStagesAfterUnstable()
    }
    stages {

        stage('Build') { 
            steps { 
                script{
                 app = docker.build("statuspage-image")
                }
            }
        }

        stage('Test'){
            steps {
                 echo 'Empty'
            }
        }
