pipeline {
    agent any
    
    environment {
    	ETE_SVN_HOST='http://10.175.230.180:8080'
		ETE_REPO='svn/ETESystem'
		
		ETE_WORKSPACE='svn\\ETESystem'
		
    }
    
    stages {
    	stage('Preparation') {
            steps {
            	script {
	                if (params.DELETE_DIR == true) {
	                	echo "Clean temporary directory."
			            bat "IF EXIST svn rmdir /s /q svn"
			            bat "IF EXIST env rmdir /s /q env"
			        } 
			        
			        switch (params.ETE_TYPE) {
			        case ~/domains/ :
			        	ETE_TYPE='domains'
			        	break;
			        case ~/conf/ :
			        	ETE_TYPE='conf'
			        	break;
			        default :          
			            ETE_TYPE='apps'       
			        }

			        
			    }
            }
        }
    	     
        stage('Build applications or domains') {
			when {
                expression { return ETE_TYPE ==~ /(apps|domain)/  }
            }
            steps {
            
            	 script {
					SIT_APPS_HOME1 = "env\\SIT\\ETE\\App\\mule-esb-3.7.3-SIT\\${ETE_TYPE}"
					SIT_APPS_HOME2 = "env\\SIT\\ETE\\App\\mule-esb-3.7.3-SIT-ATM\\${ETE_TYPE}"
					VIT_APPS_HOME1 = "env\\VIT\\ETE\\App\\mule-esb-3.7.3-VIT\\${ETE_TYPE}"
					UAT_APPS_HOME1 = "env\\UAT\\ETE\\App\\mule-esb-3.7.3\\${ETE_TYPE}"
					UAT_APPS_HOME2 = "env\\UAT\\ETE\\App\\mule-esb-3.7.3-ATM\\${ETE_TYPE}"

                }
                
            	echo "Checking out source code from SVN..."
            	bat "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME} ${ETE_REPO}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME}"
                
                dir ("${ETE_REPO}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME}") {
					
					input "Continue ?"
					bat 'if exist pom.xml mvn clean package'
				
				}
				
				script {
				
					switch (params.ETE_BRANCH) {

						case ~/SIT/: 
							if (params.ETE_APP_NAME =~ /^atm/) { 
		                        bat "if not exist $SIT_APPS_HOME2 mkdir $SIT_APPS_HOME2"
		                        bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${SIT_APPS_HOME2}"
		                    } else {
		                        bat "if not exist $SIT_APPS_HOME1 mkdir $SIT_APPS_HOME1"
		                        bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${SIT_APPS_HOME1}"
		                    }
							println "Packing VIT";
							bat "if not exist $VIT_APPS_HOME1 mkdir $VIT_APPS_HOME1"
		                    bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${VIT_APPS_HOME1}"
							break;
				        case ~/UAT/: 
					        if (params.ETE_APP_NAME =~ /^atm/) { 
		                        bat "if not exist $UAT_APPS_HOME2 mkdir $UAT_APPS_HOME2"
		                        bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${UAT_APPS_HOME2}"
		                    } else {
		                        bat "if not exist $UAT_APPS_HOME1 mkdir $SIT_APPS_HOME1"
		                        bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${UAT_APPS_HOME1}"
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
        
        stage('Copy configuration and SQL files') {
            when {
                expression { return ETE_TYPE ==~ /(conf)/  }
            }
            steps{
            	echo "Checking out source code from SVN..."
            	bat "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/branches/${params.ETE_BRANCH}/${ETE_TYPE} ${ETE_REPO}/branches/${params.ETE_BRANCH}/${ETE_TYPE}"

                script {
	                SIT_CONF_HOME1 = "env\\SIT\\ETE\\App\\mule-esb-3.7.3-SIT\\${ETE_TYPE}"
					SIT_CONF_HOME2 = "env\\SIT\\ETE\\App\\mule-esb-3.7.3-SIT-ATM\\${ETE_TYPE}"
					VIT_CONF_HOME1 = "env\\VIT\\ETE\\App\\mule-esb-3.7.3-VIT\\${ETE_TYPE}"
					UAT_CONF_HOME1 = "env\\UAT\\ETE\\App\\mule-esb-3.7.3\\${ETE_TYPE}"
					UAT_CONF_HOME2 = "env\\UAT\\ETE\\App\\mule-esb-3.7.3-ATM\\${ETE_TYPE}"
 
					switch (params.ETE_BRANCH) {

						case ~/SIT/: 
							
		                    bat "if not exist $SIT_CONF_HOME2 mkdir $SIT_CONF_HOME2"
		                    bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\src\\mule-app-global-SIT.properties ${SIT_CONF_HOME2}"
		                    
		                    bat "if not exist $SIT_CONF_HOME1 mkdir $SIT_CONF_HOME1"
		                    bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\src\\mule-app-global-SIT.properties ${SIT_CONF_HOME1}"

							println "Packing VIT";
							bat "if not exist $VIT_CONF_HOME1 mkdir $VIT_CONF_HOME1"
		                    bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\src\\mule-app-global-VIT.properties ${VIT_CONF_HOME1}"
							break;
				        case ~/UAT/: 

		                    bat "if not exist $UAT_CONF_HOME2 mkdir $UAT_CONF_HOME2"
		                    bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\src\\mule-app-global-UAT.properties ${UAT_CONF_HOME2}"
		                    
		                    bat "if not exist $UAT_CONF_HOME1 mkdir $SIT_CONF_HOME1"
		                    bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\src\\mule-app-global-UAT.properties ${UAT_CONF_HOME1}"
		                    
					        break;
				        case ~/PRD/: 
					        println "PRD"; 
					        break;
				        default: input "Do not known your build environment !";

					}
	                
			    }
                
            }

        }

        stage('Packaging') {
        	when {
                expression { params.SEND_RA == true }
            }
            steps {
            	script {
	                
	                switch (params.ETE_BRANCH) {
	                	case ~/SIT/:
	                		dir ("env/SIT") {
	                			bat "jar -cMf ETE.zip ETE"        
	                		        
	                		}
							dir ("env/VIT") {
	                		    bat "jar -cMf ETE.zip ETE"   
	                		        
	                		}
	                		break;
	                	case ~/UAT/:
	                		dir ("env/UAT") {
	                		    bat "jar -cMf ETE.zip ETE"   
	                		        
	                		}
	                		break;
	                	case ~/PRD/:
	                		dir ("env/PRD") {
	                		    bat "jar -cMf ETE.zip ETE"   
	                		        
	                		}
	                		break;
	                	default: input "Do not known your build environment !";             
	                           
	                }

	                
			    }
            }
        }
        
        stage('Human check') {
            steps {
                input "Continue transfer ETE.zip to Release Automation server ?"
            }
        }
        
        stage('Transfering') {
        	when {
                expression { params.SEND_RA == true }
            }
            steps {
                
                script {
	                
	                switch (params.ETE_BRANCH) {
	                	case ~/SIT/:
	                		dir ("env/SIT") {
	                			bat "pscp -pw P@ssete17 ETE.zip root@10.200.115.196:/app/DevOps/SIT"        
	                		        
	                		}
							dir ("env/VIT") {
	                		    bat "pscp -pw P@ssete17 ETE.zip root@10.200.115.196:/app/DevOps/VIT"   
	                		        
	                		}
	                		break;
	                	case ~/UAT/:
	                		dir ("env/UAT") {
	                		    
	                		        
	                		}
	                		break;
	                	case ~/PRD/:
	                		dir ("env/PRD") {
	                		     
	                		        
	                		}
	                		break;
	                	default: input "Do not known your build environment !";             
	                           
	                }

	                
			    }
            }
        }

        
    }
    post {
        always {
            echo 'Thank you for using.'
        }
        success {
            echo 'Successful.'
        }
        failure {
            echo 'Fail.'
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