#!groovy
def awsrole = 'arn:aws:iam::139714795802:role/Jenkins'

pipeline {
    agent {
        label 'ec2-docker'
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '20'))
        disableConcurrentBuilds()
    }
    stages {
        stage('Build Lambda Deployment Packages') {
            agent {
                docker {
                    reuseNode true
                    image 'node:12.18-alpine'
                }
            }
            steps {
                sh '''
                cd application; npm install; npm build
                ls
                '''
            }
        }    
    }
    post {
        always {
            clean()
            slackNotification("#prdfam-dlt-ci")
        }
    }
}