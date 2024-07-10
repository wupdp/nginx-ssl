pipeline {
    agent any
    stages {
        stage('Checkout') {
            agent { label 'build' }
            steps {
                script {
                    sh 'rm -rf docker-nginx-apache'
                    sh 'git clone https://github.com/wupdp/docker-nginx-apache.git'
                }
            }
        }
        stage('Build Docker Image') {
            agent { label 'build' }
            steps {
                script {
                    sh '''
                    docker build -t my-nginx:${BUILD_ID} ./docker-nginx-apache/nginx
                    docker build -t my-apache:${BUILD_ID} ./docker-nginx-apache/apache
                    docker tag my-nginx:${BUILD_ID} my-nginx:latest
                    docker tag my-apache:${BUILD_ID} my-apache:latest
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
                        docker tag my-nginx:${BUILD_ID} $USERNAME/my-nginx:${BUILD_ID}
                        docker tag my-nginx:latest $USERNAME/my-nginx:latest
                        docker push $USERNAME/my-nginx:${BUILD_ID}
                        docker push $USERNAME/my-nginx:latest
                        docker tag my-apache:${BUILD_ID} $USERNAME/my-apache:${BUILD_ID}
                        docker tag my-apache:latest $USERNAME/my-apache:latest
                        docker push $USERNAME/my-apache:${BUILD_ID}
                        docker push $USERNAME/my-apache:latest
                        docker logout
                        '''
                    }
                }
            }
        }
        stage('Deploy') {
            agent { label 'deploy' }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'a42e88b7-a731-4f5b-af31-d2a7f624f53d', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh '''
                        docker pull $USERNAME/my-nginx:latest
                        docker pull $USERNAME/my-apache:latest
                        docker stop nginx || true
                        docker stop apache || true
                        docker network create network --driver bridge || true
                        docker rm nginx || true
                        docker rm apache || true
                        docker run -d --name apache --network network $USERNAME/my-apache:latest
                        docker run -d --name nginx --network network -p "80:80" $USERNAME/my-nginx:latest
                        docker image prune -a
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
    }
    post {
        always {
            cleanWs()
        }
    }
}
