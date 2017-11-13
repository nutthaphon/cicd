pipeline {
    agent any
    
    environment {
    	ETE_SVN_HOST='http://10.175.230.180:8080'
		ETE_REPO='svn/ETESystem'
		
		ETE_WORKSPACE='svn\\ETESystem'
		
		SIT_APPS_HOME1 = 'env\\SIT\\ETE\\App\\mule-esb-3.7.3-SIT\\apps'
		SIT_APPS_HOME2 = 'env\\SIT\\ETE\\App\\mule-esb-3.7.3-SIT-ATM\\apps'
		VIT_APPS_HOME1 = 'env\\VIT\\ETE\\App\\mule-esb-3.7.3-VIT\\apps'
		UAT_APPS_HOME1 = 'env\\UAT\\ETE\\App\\mule-esb-3.7.3\\apps'
		UAT_APPS_HOME2 = 'env\\UAT\\ETE\\App\\mule-esb-3.7.3-ATM\\apps'
    }
    
    stages {
    	stage('Preparation') {
            steps {
            	script {
	                if (params.DELETE_DIR == true) {
	                	echo "Clean temporary directory."
			            bat "IF EXIST ${ETE_WORKSPACE} rmdir /s /q ${ETE_WORKSPACE}"
		            	bat "mkdir ${ETE_WORKSPACE}"
			        } 
			    }
            }
        }

    	stage ('Check program type') {

    	when {
                expression { params.IS_DOMAIN == true }
            }
            steps {
            	echo "Build domain."
            	withEnv(['MY_HOME=C:\\']) {
				    bat '''
				    	cd $MY_HOME
				    	cd
				    '''
				}
            }
        }
    	     
        stage('Build applications') {
       		environment {
                ETE_SERVER='127.0.0.1'
            }
            when {
                expression { params.IS_DOMAIN == false }
            }
            steps {
            
            	 script {
                    if (params.ETE_BRANCH == 'SIT') {
                        echo 'I am in SIT'
                    } else {
                        echo 'I am in elsewhere'
                    }

                }
                
            	echo "Checking out source code from SVN..."
            	bat "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/branches/${params.ETE_BRANCH}/apps/${params.ETE_APP_NAME} ${ETE_REPO}/branches/${params.ETE_BRANCH}/apps/${params.ETE_APP_NAME}"
                
                dir ("${ETE_REPO}/branches/${params.ETE_BRANCH}/apps/${params.ETE_APP_NAME}") {
                    bat "svn status"
                	bat "mvn --version"
                	
                	bat '''
					    IF EXIST "pom.xml" (
						    mvn clean package
						    
						) ELSE (
						    echo "pom.xml not found."
						)
					
					'''
					
				}
				
				script {
				
					switch (params.ETE_BRANCH) {

						case ~/SIT/: 
							if (params.ETE_APP_NAME =~ /^atm/) { 
		                        bat "if not exist $SIT_APPS_HOME2 mkdir $SIT_APPS_HOME2"
		                        bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\apps\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${SIT_APPS_HOME2}"
		                    } else {
		                        bat "if not exist $SIT_APPS_HOME1 mkdir $SIT_APPS_HOME1"
		                        bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\apps\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${SIT_APPS_HOME1}"
		                    }
							println "Packing VIT";
							bat "if not exist $VIT_APPS_HOME1 mkdir $VIT_APPS_HOME1"
		                    bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\apps\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${VIT_APPS_HOME1}"
							break;
				        case ~/UAT/: 
					        if (params.ETE_APP_NAME =~ /^atm/) { 
		                        bat "if not exist $UAT_APPS_HOME2 mkdir $UAT_APPS_HOME2"
		                        bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\apps\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${UAT_APPS_HOME2}"
		                    } else {
		                        bat "if not exist $UAT_APPS_HOME1 mkdir $SIT_APPS_HOME1"
		                        bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\apps\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${UAT_APPS_HOME1}"
		                    }
					        break;
				        case ~/PRD/: 
					        println "PRD"; 
					        break;
				        default: input "Do not known your build environment !";           

					}
 
				
                    

                }
				
            }
        } 
        
        stage('Test') {
            steps {
            	script {
	                if (params.ETE_BRANCH == 'SIT') {
	            		echo 'Testing in SIT'
			        } else {
			            echo 'Testing in another'
			        }
			    }
            }
        }
        
        stage('Human check') {
            steps {
                input "Can deployment step continue ?"
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

        
    }
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
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