pipeline {
    agent any
    stages {
        stage('Checkout') {
            agent { label 'build' }
            steps {
                script {
                    sh 'rm -rf nginx-ssl'
                    sh 'git clone https://github.com/wupdp/nginx-ssl.git'
                }
            }
        }
        stage('Build Docker Image') {
            agent { label 'build' }
            steps {
                script {
                    sh '''
                    sudo docker build -t nginx-ssl:${BUILD_ID} ./
                    sudo docker tag nginx-ssl:${BUILD_ID} nginx-ssl:latest
                    '''
                }
            }
        }
        stage('Push Docker Image') {
            agent { label 'build' }
            steps {
                script {
                        sh '''
                        docker tag nginx-ssl:${BUILD_ID} wupdp/nginx-ssl:${BUILD_ID}
                        docker tag nginx-ssl:latest wupdp/nginx-ssl:latest
                        docker push wupdp/nginx-ssl:${BUILD_ID}
                        docker push wupdp/nginx-ssl:latest
                        '''
                }
            }
        }
        stage('Deploy') {
            agent { label 'build' }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'a42e88b7-a731-4f5b-af31-d2a7f624f53d', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh '''
                        kubectl apply -f deploy.yml
                        '''
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
