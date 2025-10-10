pipeline {
  agent any

  environment {
    // change these to your Docker Hub username/repo
    DOCKERHUB_REPO = "shrutika91/java-docker-application" 
    // credential id you created in Jenkins (username/password or token)
    DOCKERHUB_CREDENTIALS_ID = "dockerhub-cred"
    // image tag - use build number for uniqueness
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    IMAGE_NAME = "${env.DOCKERHUB_REPO}:${IMAGE_TAG}"
    GIT_REPO="https://github.com/shrutika0910/Java-Docker-Application.git"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build (Maven)') {
      steps {
        // if Maven is on the agent PATH:
        sh 'mvn -B -DskipTests clean package'
      }
      post {
        success {
          archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME} --build-arg JAR_FILE=target/java-hello-1.0.0-jar-with-dependencies.jar ."
      }
    }

    stage('Docker Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDENTIALS_ID, usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh 'echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin'
          sh "docker push ${IMAGE_NAME}"
          sh 'docker logout'
        }
      }
    }
  }

  post {
    success {
      echo "Image pushed: ${IMAGE_NAME}"
    }
    failure {
      echo "Build failed."
    }
  }
}
