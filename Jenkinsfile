pipeline {
  agent any

  environment {
    // Docker Hub details
    DOCKERHUB_REPO = "shrutika91/java-docker-application" 
    DOCKERHUB_CREDENTIALS_ID = "dockerhub-cred"
    IMAGE_TAG = "${BUILD_NUMBER}"               // auto tag with build number
    IMAGE_NAME = "${DOCKERHUB_REPO}:${IMAGE_TAG}"
    GIT_REPO = "https://github.com/shrutika0910/Java-Docker-Application.git"
  }

  stages {
    stage('Cleanup') {
      steps {
        deleteDir()  // cleans old files
      }
    }

    stage('Checkout') {
      steps {
        git branch: 'main', url: "${GIT_REPO}"
      }
    }

    stage('Build (Maven)') {
      steps {
        bat 'mvn -B -DskipTests clean package'
      }
    }

    stage('Build Docker Image') {
      steps {
        bat "docker build -t ${DOCKERHUB_REPO}:latest ."
      }
    }

    stage('Tag and Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          bat """
            docker login -u %DOCKER_USER% -p %DOCKER_PASS%
            docker tag java-docker-app %DOCKERHUB_REPO%:${IMAGE_TAG}
            docker push %DOCKERHUB_REPO%:${IMAGE_TAG}
            docker tag java-docker-app %DOCKERHUB_REPO%:latest
            docker push %DOCKERHUB_REPO%:latest
          """
        }
      }
    }
  }

  post {
    success {
      echo "✅ Build and Docker push successful!"
      echo "Image pushed to: https://hub.docker.com/r/${DOCKERHUB_REPO}"
    }
    failure {
      echo "❌ Build or push failed. Check Jenkins console output."
    }
  }
}
