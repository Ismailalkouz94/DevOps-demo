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



    }


    post
    {
        always
        {
            sh "rm -rf /var/jenkins_home/workspace/${PROJECT}/*"
        }
    }
}