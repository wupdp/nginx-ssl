pipeline {
    agent any
    stages {
        stage('Checkout') {
            agent { label 'build' }
            steps {
                script {
                    sh 'rm -rf docker-nginx-apache'
                    sh 'git clone https://github.com/wupdp/nginx-ssl.git'
                }
            }
        }
        stage('Build Docker Image') {
            agent { label 'build' }
            steps {
                script {
                    sh '''
                    docker build -t nginx-ssl:${BUILD_ID} ./
                    docker tag nginx-ssl:${BUILD_ID} nginx-ssl:latest
                    '''
                }
            }
        }
        stage('Push Docker Image') {
            agent { label 'build' }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'a42e88b7-a731-4f5b-af31-d2a7f624f53d', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh '''
                        echo $PASSWORD | docker login -u $USERNAME --password-stdin
                        docker tag nginx-ssl:${BUILD_ID} $USERNAME/nginx-ssl:${BUILD_ID}
                        docker tag nginx-ssl:latest $USERNAME/nginx-ssl:latest
                        docker push $USERNAME/nginx-ssl:${BUILD_ID}
                        docker push $USERNAME/nginx-ssl:latest
                        docker logout
                        '''
                    }
                }
            }
        }
        /*stage('Deploy') {
            agent { label 'deploy' }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'a42e88b7-a731-4f5b-af31-d2a7f624f53d', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh '''

                        '''
                    }
                }
            }
        }
        stage('Healthcheck') {
            agent { label 'deploy' }
            steps {
                script {
                    sh '''
                    response=$(curl -s -o /dev/null -w "%{http_code}" http://your-app-url)
                    if [ "$response" = "200" ]; then
                        echo "Healthcheck passed: HTTP status 200"
                    else
                        echo "Healthcheck failed: HTTP status $response"
                        exit 1
                    fi
                    '''
                }
            }
        }
    }*/
    post {
        always {
            cleanWs()
        }
    }
}
