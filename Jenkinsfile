pipeline {
  agent any
  options { timestamps() }

  environment {
    IMAGE_NAME = "hello-api"
    CONTAINER_NAME = "hello-api-ci"
    // Docker Desktop Windowsista Jenkins-konttiin host-portin tavoittamiseen:
    BASE_URL = "http://host.docker.internal:5000"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Ensure Docker CLI') {
      steps {
        sh '''
          set -e
          command -v docker >/dev/null 2>&1 || (apt-get update && apt-get install -y docker.io)
          docker version
        '''
      }
    }

    stage('Docker Build') {
      steps {
        sh '''
          set -eux
          docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
        '''
      }
    }

    stage('Run API (detached)') {
      steps {
        sh '''
          set -eux
          # Varmista ettei vanhaa konttia ole
          docker rm -f ${CONTAINER_NAME} >/dev/null 2>&1 || true
          docker run -d --name ${CONTAINER_NAME} -p 5000:5000 ${IMAGE_NAME}:${BUILD_NUMBER}

          # Odota että API vastaa
          for i in $(seq 1 30); do
            if curl -fsS ${BASE_URL}/hello >/dev/null; then
              echo "API is up"
              exit 0
            fi
            echo "Waiting API..."
            sleep 1
          done
          echo "API did not start in time" >&2
          exit 1
        '''
      }
    }

  stage('Install Robot & Run Tests') {
    steps {
      sh '''
        set -eux
        # Tarvittavat paketit konttiin
        apt-get update
        apt-get install -y python3 python3-venv

        # Virtuaaliympäristö ja kirjastot
        python3 -m venv .venv
        . .venv/bin/activate
        pip install --upgrade pip
        pip install robotframework==7.3.2 robotframework-requests==0.9.7

        # Aja testit; BASE_URL tulee environmentista
        robot -v BASE_URL:${BASE_URL} -d robot_output tests/robot
      '''
    }
  }


  post {
    always {
      // Tuo raportit talteen
      archiveArtifacts artifacts: 'robot_output/**', onlyIfSuccessful: false
      // Sammuta & poista API-kontti
      sh 'docker rm -f ${CONTAINER_NAME} >/dev/null 2>&1 || true'
      // Pieni siivous imageista (valinnainen)
      sh 'docker image prune -f || true'
      echo "Build finished with status: ${currentBuild.currentResult}"
    }
  }
}
