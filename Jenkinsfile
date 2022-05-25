pipeline {
    agent any
    tools {
        jdk 'jdk'
        maven '3.8.5'

    }

    environment
    	{
    	    AWS_ACCOUNT_ID="714089092330"
            AWS_DEFAULT_REGION="us-east-1"
            IMAGE_REPO_NAME="devops-demo"
            IMAGE_TAG="v1"
            REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    	}

    stages {
        stage("build project") {
            steps {
                echo "Java VERSION"
                sh 'java -version'
                echo "Maven VERSION"
                sh 'mvn -version'
                echo 'building project...'
                sh "mvn clean"
                sh "mvn install"
            }
        }

        stage('Logging into AWS ECR') {
            steps {
                script {
                   //- aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}"
                   //- aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}"
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
            }
        }

        stage('Build Docker Image'){
                steps
                {
                    script
                    {
                    //must install jenkins plugins : aws credentials , ecr , docker pipeline
                    sh "docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} ."
                    }
                }

       }

        stage('Pushing to AWS ECR') {
             steps{
                 script {
                        sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}"
                        sh "docker push ${REPOSITORY_URI}:${IMAGE_TAG}"
                 }
             }
        }
    }



    post
    {
        always
        {
            sh "rm -rf /var/jenkins_home/workspace/${IMAGE_REPO_NAME}/*"
        }
    }

}