cat << EOF > Jenkinsfile
pipeline {
    agent any
   
    environment {
        DOCKER_IMAGE = 'my-python-project:latest'
    }
   
    stages {
        stage('Checkout') {
            steps {
                // For local Git repo (adjust path if needed)
                dir('/home/user/my_python_project') {
                    git branch: 'main', url: 'file:///home/user/my_python_project'
                }
            }
        }
       
        stage('Build Wheel') {
            steps {
                sh 'pip install build'
                sh 'python -m build --wheel'
            }
        }
       
        stage('Test') {
            steps {
                sh 'pip install pytest'
                sh 'pytest tests/'
            }
        }
       
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }
       
        stage('Deploy') {
            steps {
                sh 'docker stop my-python-container || true'
                sh 'docker rm my-python-container || true'
                sh 'docker run -d --name my-python-container ${DOCKER_IMAGE}'
            }
        }
    }
   
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
EOF


