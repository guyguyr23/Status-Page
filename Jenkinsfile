pipeline {
    agent any
    options {
        skipStagesAfterUnstable()
    }
    stages {

        stage('Build') { 
            steps { 
                script{
                 app = docker.build("dave_private")
                }
            }
        }

        stage('Test'){
            steps {
                 echo 'Empty'
            }
        }
