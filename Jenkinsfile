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

    stage('Build & Push Image to AWS ECR'){
            steps
            {
                script
                {
                //must install jenkins plugins : aws credentials , ecr , docker pipeline
                     docker.withRegistry('https://714089092330.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:d1d91614-b200-4a33-9ff9-94d11960ba2b')
                     {
                        def myImage = docker.build('devops-demo')
                        myImage.push('latest')
                     }
                }
            }

        }
    stage('Deploy to Kubernetes Cluster...')
            {
                steps
                {
                    sh "/usr/local/bin/kubectl apply -f k8s-app-deployment.yaml"
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