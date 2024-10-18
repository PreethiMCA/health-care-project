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
        stage ('Generate test report'){
            steps{
                echo 'Generating test reports using HTML Publisher'
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/HealthCare/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
            }
        } 
        stage('Create docker image') {
          steps   {
                echo 'creating docker image'
                sh 'docker build -t preethiadmin/healthcare:1.0 '
          }
        }
        stage('Dockerhub login') {
          steps {
              echo 'logging in Dokcerhub with username and password'
              withCredentials([usernamePassword(credentialsId: '45a0aeee-adb4-4712-a747-b472a0f3ec07', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
              sh 'docker login -u ${docker_user} -p ${docker_pass}'
              }
          }
        }
       stage('Docker Push Image') {
           steps {
               echo 'Pushing image to docker hub'
               sh 'docker push preethiadmin/healthcare:1.0'
           }
       }
    }
}
