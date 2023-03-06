pipeline {

    agent any

          environment {
    Secret_key = credentials('Secret_access_key')
    Access_key = credentials('Access_key_ID')
    Build_num = "${env.BUILD_NUMBER}"
    Address_ecr = '333082661382.dkr.ecr.us-west-1.amazonaws.com'
    Flask_image = 'status_page_image'
    Ngnix_image = 'nginx_repo'
    
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
        

        stage('Build images and deploy to ECR') { 
            steps { 


                sh '''

                aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin ${Address_ecr}

              #  docker build -t ${Flask_image} .
               # docker tag ${Flask_image}:latest ${Address_ecr}/${Flask_image}:$Build_num
                #docker push ${Address_ecr}/${Flask_image}:$Build_num

                
                docker build -f nginx_dockerfile -t ${Ngnix_image} .
                docker tag ${Ngnix_image}:latest ${Address_ecr}/${Ngnix_image}:$Build_num
                docker push ${Address_ecr}/${Ngnix_image}:$Build_num

                docker images prune
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
        
        stage('test images on test server'){
            steps{

                unstash 'ip'
                sh '''


                PUBLIC_IP=$(cat ip.txt)
                
                
                ssh -i ~/test-servers-key.pem ubuntu@$PUBLIC_IP "
                aws configure set aws_access_key_id ${Access_key} 
                aws configure set aws_secret_access_key ${Secret_key} 
                aws configure set default.region us-west-1 
        
                aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin ${Address_ecr}
                
               # docker pull ${Address_ecr}/${Flask_image}:$Build_num 
               # docker stop status_page
               # docker rm status_page
               # docker run -d -p 8000:8000 --name status_page ${Address_ecr}/${Flask_image}:$Build_num  
                

                docker pull ${Address_ecr}/${Ngnix_image}:$Build_num 
                docker stop ngnix
                docker rm ngnix
                docker run -d --net=host -p 80:80 --name ngnix ${Address_ecr}/${Ngnix_image}:$Build_num  

                docker images prune
                sleep 5
                
              #  /home/ubuntu/curl_responde.sh "
                '''
                
            }
        }
        stage('connect to the master node') {
            steps{ 


                unstash 'ip'
                sh '''


                PUBLIC_IP=$(cat ip.txt)
                
                
                
                ssh -i ~/test-servers-key.pem ubuntu@$PUBLIC_IP "
                aws configure set aws_access_key_id ${Access_key} 
                aws configure set aws_secret_access_key ${Secret_key} 
                aws configure set default.region us-west-1
             #   curl https://raw.githubusercontent.com/guyguyr23/statuspage/main/config_files/deployment.yml > /home/ubuntu/kube_config/deployment.yml
             #   curl https://raw.githubusercontent.com/guyguyr23/statuspage/main/config_files/service.yml > /home/ubuntu/kube_config/service.yml
             #   /home/ubuntu/kube_config/jenkins_CD.sh -t $Build_num"
                '''


            }
        }
    }
}

