pipeline {
    agent any
    
    environment {
        DISABLE_AUTH = 'true'
        DB_ENGINE    = 'sqlite'
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
    	AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    
    stages {
        stage('Build') {
            steps {
                bat 'python --version'
            }
        }
        
        stage('Test') {
            steps {
                bat 'python --version'
            }
        }
        
        stage('Deploy') {
            steps {
                retry(3) {
                    bat 'python --version'
                }

                timeout(time: 3, unit: 'MINUTES') {
                    bat 'python --version'
                }
            }
        }
		stage('Human check') {
            steps {
                input "Does the environment look ok?"
            }
        }
        
    }
    post {
        always {
            echo '${currentBuild.fullDisplayName} This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
            mail to: '47238@tmbbank.com',
            	subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
            	body: "Something is wrong with ${env.BUILD_URL}"
            
        }
        unstable {
            echo 'This will run only if the run was marked as unstable'
        }
        changed {
            echo 'This will run only if the state of the Pipeline has changed'
            echo 'For example, if the Pipeline was previously failing but is now successful'
        }
    }
    
}