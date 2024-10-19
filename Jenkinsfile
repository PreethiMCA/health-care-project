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
        stage('codetesting'){
            steps{
                sh 'mvn test'
            }
        }
        stage('package the code'){
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
                sh 'docker build -t preethiadmin/healthcare:1.0 . '
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
       stage('AWS-Login') {
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Awsaccess', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
         }
      }
    }
    stage('Terraform Operations for test workspace') {
      steps {
        script {
          sh '''
            terraform workspace select test || terraform workspace new test
            terraform init
            terraform plan
            terraform destroy -auto-approve
          '''
        }
      }
    }
    stage('Terraform destroy & apply for test workspace') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
    stage('get kubeconfig') {
      steps {
        sh 'aws eks update-kubeconfig --region us-east-1 --name test-cluster'
        sh 'kubectl get nodes'
      }
    }
    stage('Deploying the application') {
      steps {
        sh 'kubectl apply -f deployment.yml'
        sh 'kubectl get svc'
      }
    }
    stage('Terraform Operations for Production workspace') {
      when {
        expression {
          return currentBuild.currentResult == 'SUCCESS'
        }
      }
      steps {
        script {
          sh '''
            terraform workspace select prod || terraform workspace new prod
            terraform init
            terraform plan
            terraform destroy -auto-approve
          '''
        }
      }
    }
    stage('Terraform destroy & apply for production workspace') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
    stage('get kubeconfig for production') {
      steps {
        sh 'aws eks update-kubeconfig --region us-east-1 --name prod-cluster'
        sh 'kubectl get nodes'
      }
    }
    stage('Deploying the application to production') {
      steps {
        sh 'kubectl apply -f deployment.yml'
        sh 'kubectl get svc'
      }
    }
}
}
