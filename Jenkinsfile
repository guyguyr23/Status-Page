pipeline {
    agent any
          environment {
    Secret_key = credentials('Secret_access_key')
    Access_key = credentials('Access_key_ID')
    build_num = "${env.BUILD_NUMBER}"
     }
    options {
        skipStagesAfterUnstable()
    }
    stages {

        stage('configure aws') {
            steps{ 
                sh '''
                aws configure set aws_access_key_id ${Access_key}
                aws configure set aws_secret_access_key ${Secret_key}
                aws configure set default.region us-west-1
                '''
                }
          }
        
        stage('Build and deploy to ECR') { 
            steps { 
                sh '''
                aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 333082661382.dkr.ecr.us-west-1.amazonaws.com
                docker build -t status_page_image .
                docker tag status_page_image:latest 333082661382.dkr.ecr.us-west-1.amazonaws.com/status_page_image:$build_num
                docker push 333082661382.dkr.ecr.us-west-1.amazonaws.com/status_page_image:$build_num
                '''
                
                
            }
        }

        
   
       
          stage('get master node public ip') {
            steps{                  
                sh '''
                PUBLIC_IP=$(aws ec2 describe-instances --instance-ids i-0d2817565eeac7442 --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
                echo $PUBLIC_IP > ip.txt
                ssh-keyscan -H $PUBLIC_IP >> ~/.ssh/known_hosts
                '''
                stash name: 'ip', includes: 'ip.txt'                          
               }
            }
        stage('connect to the master node') {
            steps{ 
                unstash 'ip'
                sh '''
                PUBLIC_IP=$(cat ip.txt)
                aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 333082661382.dkr.ecr.us-west-1.amazonaws.com
                ssh -i ~/test-servers-key.pem ubuntu@$PUBLIC_IP ../home/ubuntu/app_test.sh -t $build_num
               
               
           script {
                    final String url = "http://$PUBLIC_IP:8000"

                    final String response = sh(script: "curl -s $url", returnStdout: true).trim()

                    echo response
                } 
                
                scp -i ~/test-servers-key.pem config_files/deployment.yml ubuntu@$PUBLIC_IP:/home/ubuntu/kube_config
                ssh -i ~/test-servers-key.pem ubuntu@$PUBLIC_IP /home/ubuntu/kube_config/jenkins_CD.sh
                '''
            }
        }
    }
}

