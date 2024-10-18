pipeline{
    agent any
       tools {
           maven 'M2_HOME'
       }
    stages{
        stage('Git Checkout'){
            steps{
                  git branch: 'master' , url: 'https://github.com/PreethiMCA/health-care-project.git'
                  echo 'github url checkout'
            }
        }
        stage('compile the code'){
            steps{
                echo 'starting compiling'
                sh 'mvn compile'
            }
        }
        stage('codetesting with akshat'){
            steps{
                sh 'mvn test'
            }
        }
        stage('package with akshat'){
            steps{
                sh 'mvn package'
            }
        }               
   }
}
