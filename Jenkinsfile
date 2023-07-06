pipeline{
    agent {
        node{
            label 'kworkerthree'
        }
    }

    tools {
        maven 'slave-mvn'
       
    }

    environment {
        DOCKER_USER = credentials('dockerid')
        DOCKER_PASSWORD = credentials('dockerpwd')
        NEXUS_USER = credentials('nexusID')
        NEXUS_PWD = credentials('nexusPwd')
        NEXUS_IMAGE_TAG = "10.0.0.174:8083/java-maven:v1.4.1"
        DOCKER_TAG = "sanjeetkr/web-app:v1.4.1"
        NEXUS_ENDPOINT = "10.0.0.174:8083"
    }

    stages {
        
        stage('Build jar file') {
            steps {
                echo "Building jar"
                sh 'mvn clean package deploy'
                echo "executing pipeline"
            }
        }
        
        stage('Build docker image for nexus') {
            steps {
                echo "Building docker nexus image"
                sh "docker build -t ${NEXUS_IMAGE_TAG} ."
                sh "docker login -u $NEXUS_USER -p $NEXUS_PWD ${NEXUS_ENDPOINT}"
                sh "docker push ${NEXUS_IMAGE_TAG}"
            }
        }

        stage('Build docker image for dockerhub') {
            steps {
                echo "Building docker image"
                sh "docker build -t ${DOCKER_TAG} ."
                sh "docker login -u $DOCKER_USER -p $DOCKER_PASSWORD"
                sh "docker push ${DOCKER_TAG}"
            }
        }

        stage('Deploy the image') {
            steps {
                echo "Deployment phase"
                script {
                    def docker_cmd = "docker run -d -p 8080:8080 ${DOCKER_TAG}"
                    sshagent(['ec2-server']) { // -o StrictHostKeyChecking=no : used to suppress popup
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@35.170.201.92 ${docker_cmd}"
                    }
                }
            }
        }


    }
    post{
        always{
            echo "Publishing test result"
            junit "**/target/surefire-reports/*.xml"
        }
    } 
    
}