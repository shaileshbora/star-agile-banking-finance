pipeline {
    agent any
    tools {
        maven "M2_HOME"
        }
    stages {
        stage ('Git checkout') {
            steps {
                git 'https://github.com/shaileshbora/star-agile-banking-finance.git'
                }
            }
        stage ('Build the application') {
            steps {
                sh "mvn clean install package"
                }
            }
        stage ('Publish HTML Reports') {
            steps {
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/Finance_Me_Project/target/surefire-reports', reportFiles: 'index.html', reportName: 'Finance_Me_Project-HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                }
            }
        stage('Build Docker Image') {
            steps {
                sh'sudo docker system prune -af '
                sh 'sudo docker build -t shaileshbora/finance_me_project:1.0 .'
                }
            }
        stage ('Push Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                sh "sudo docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                sh 'sudo docker push shaileshbora/finance_me_project:1.0'
                }
            }
        }
        stage ('Configure Test-server with Terraform, Ansible and then Deploying'){
            steps {
                dir('test-server'){
                sh 'sudo chmod 600 project.pem'
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply --auto-approve'
                }
            }
        }
        stage ('Waiting for Application to Start') {
            steps {
                sh ' sleep 40'
                }
        }
        stage ('Selenium Testing') {
            steps {
                 sh 'sudo java -jar seleniumbank.jar'
                 sh "echo 'Application is logged in Succussfully' "
                 }
        }
        stage ('Setting up Prod-Server with Terraform and Ansible'){
            steps{
                dir('prod-server'){
                sh 'chmod 600 project.pem'
                sh'terraform init'
                sh'terraform validate'
                sh'terraform apply --auto-approve'
                }
             }
         }
     }
}
