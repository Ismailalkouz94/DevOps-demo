pipeline {
    agent any
    tools {
        jdk 'jdk'
        maven '3.8.5'

    }

    environment
    	{
    	    AWS_ACCOUNT_ID="aws-credentials"
            AWS_DEFAULT_REGION="us-east-1"
            IMAGE_REPO_NAME="devops-demo"
            IMAGE_TAG="v1"
            REPOSITORY_URI = "714089092330.dkr.ecr.us-east-1.amazonaws.com/${IMAGE_REPO_NAME}"
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
                    sh """aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"""
                }
            }
        }

        stage('Build & Push Image to AWS ECR'){
                steps
                {
                    script
                    {
                    //must install jenkins plugins : aws credentials , ecr , docker pipeline
                    dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                    }
                }

            }
        stage('Pushing to ECR') {
             steps{
                 script {
                        sh """docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}"""
                        sh """docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"""
                 }
             }
        }
    }



    post
    {
        always
        {
            sh "rm -rf /var/jenkins_home/workspace/${PROJECT}/*"
        }
    }

}