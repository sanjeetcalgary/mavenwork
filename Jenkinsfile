pipeline{
    agent none

    tools {
        maven 'slave-mvn'
       
    }

    environment {
        DOCKER_USER = credentials('dockerid')
        DOCKER_PASSWORD = credentials('dockerpwd')
        NEXUS_USER = credentials('nexusID')
        NEXUS_PWD = credentials('nexusPwd')
        NEXUS_IMAGE_TAG = "10.0.0.174:8083/java-maven:v2.1.3"
        DOCKER_TAG = "sanjeetkr/web-app:v2.1.3"
        NEXUS_ENDPOINT = "10.0.0.174:8083"
    }

    stages {
        
        stage('Build jar file') {
            agent {
                label 'kworkerthree'
            }
            steps {
                echo "Building jar"
                sh 'mvn clean package spring-boot:repackage deploy'
                echo "executing pipeline"
            }
            post{
                always{
                    echo "Publishing test result"
                    junit "**/target/surefire-reports/*.xml"
                }
            } 
        }
        
        stage('Build docker image for nexus') {
            agent {
                label 'kworkerthree'
            }
            steps {
                echo "Building docker nexus image"
                sh "docker build -t ${NEXUS_IMAGE_TAG} ."
                sh "docker login -u $NEXUS_USER -p $NEXUS_PWD ${NEXUS_ENDPOINT}"
                sh "docker push ${NEXUS_IMAGE_TAG}"
            }
        }

        stage('Build docker image for dockerhub') {
            agent {
                label 'kworkerthree'
            }
            steps {
                echo "Building docker image"
                sh "docker build -t ${DOCKER_TAG} ."
                sh "docker login -u $DOCKER_USER -p $DOCKER_PASSWORD"
                sh "docker push ${DOCKER_TAG}"
            }
        }
        //provisioner - terraform
        stage('Provision server') {
            agent {
                label 'windows'
            }
            environment {
                AWS_ACCCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                TF_VAR_aws_availzone = "us-east-1b"
            }
            steps {
                script { //to execute terraform, go to that directory
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                        EC2_PUBLIC_IP = sh(
                            script: "terraform output ec2-publicIP",
                            returnStdout: true
                            ).trim()
                    }
                }
            }
        }

        stage('Deploy the image') {
            agent {
                label 'windows'
            }
            steps {
                echo "Deployment phase"
                script {
                    sleep(time: 180, unit: "SECONDS")
                    echo "Deploying now in EC2........."
                    echo "${EC2_PUBLIC_IP}"
                    def docker_cmd = "bash ./server-cmd.sh ${DOCKER_TAG}"
                    def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"
                    sshagent(['ec2-server']) { // -o StrictHostKeyChecking=no : used to suppress popup
                        sh "scp -o StrictHostKeyChecking=no server-cmd.sh ${ec2Instance}:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yml ${ec2Instance}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${docker_cmd}"
                    }
                }
            }
        }


    }
    
    
}