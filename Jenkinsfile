pipeline {
    agent any
    tools {
        jdk 'jdk'
        maven '3.8.5'
       
    }

    environment
    	{
    		PROJECT = "devops-demo"
    		CONTAINER_REPOSITORY = "714089092330.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}"
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
        stage('Build Docker Image'){
            steps
            {
                sh "docker build -t ${CONTAINER_REPOSITORY}:latest ."
                sh "docker tag ${CONTAINER_REPOSITORY}:latest  ${CONTAINER_REPOSITORY}:latest"
            }
        }
        stage('Push Image to AWS ECR'){
            steps
            {
//                 sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 714089092330.dkr.ecr.us-east-1.amazonaws.com"
//                 sh 'docker push ${CONTAINER_REPOSITORY}:latest'

                script
                {
                     docker.withRegistry('https://714089092330.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:5d099983-3972-42a9-8545-246ceb6b7b44')
                     {
                        docker.image('714089092330.dkr.ecr.us-east-1.amazonaws.com/devops-demo').push('latest')
                     }
                }
            }
        }


        stage('Login K8s Cluster')
        {
            steps
            {
                sh "kubectl config set-context devops-demo --cluster=devops-demo --user=arn:aws:eks:us-west-1:714089092330:cluster/devops-demo"
                sh "kubectl config use-context devops-demo"
            }
        }
        stage('Deploy to Kubernetes Cluster')
        {
            steps
            {
                sh "kubectl apply -f k8s-app-deployment.yaml"
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