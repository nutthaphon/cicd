pipeline {
    agent any
    
    environment {
    	ETE_SVN_HOST	= 'http://10.175.230.180:8080'
		ETE_REPO		= 'svn/ETESystem'
		ETE_WORKSPACE	= 'svn/ETESystem'
		
    }
    
    stages {
    	stage('Preparation') {
            steps {
            	script {
            	
            		IS_BATCH		= false
            		DELETE_DIR		= params.DELETE_DIR
            		SEND_RA			= params.SEND_RA
            		ETE_BRANCH		= params.ETE_BRANCH
            		ETE_DOMAIN_NAME	= params.ETE_DOMAIN_NAME
            		ETE_APP_NAME	= params.ETE_APP_NAME
            		ETE_BATCH_NAME	= params.ETE_BATCH_NAME
            		ETE_CONF_FILE	= params.ETE_CONF_FILE
            		ETE_PP			= params.ETE_PP
            		
				    if(ETE_APP_NAME != '') { 
				        ETE_TYPE = 'apps'

				    } else if (ETE_BATCH_NAME != '') { 
				        ETE_TYPE = 'apps'
				        ETE_APP_NAME = ETE_BATCH_NAME
				        IS_BATCH = true

				    } else if (ETE_DOMAIN_NAME != '') {
				        ETE_TYPE = 'domains'
				        ETE_APP_NAME = ETE_DOMAIN_NAME

				    } else if (ETE_CONF_FILE != '') {
    					ETE_TYPE = 'conf'
    					
				    } else {
				        echo "Nothing to do."
				        
				    }
			        
					DEV_APPS_HOME1  = "env/DEV/ETE/App/mule-esb-3.7.3-DEV/${ETE_TYPE}"
					DEV_APPS_HOME2  = "env/DEV/ETE/App/mule-esb-3.7.3-DEV-ATM/${ETE_TYPE}"
					DEV_APPS_HOME3  = "env/DEV/ETE/App/mule-esb-3.7.3-DEV-PP/${ETE_TYPE}"
					SIT_APPS_HOME1  = "env/SIT/ETE/App/mule-esb-3.7.3-SIT/${ETE_TYPE}"
					SIT_APPS_HOME2  = "env/SIT/ETE/App/mule-esb-3.7.3-SIT-ATM/${ETE_TYPE}"
					SIT_APPS_HOME3  = "env/SIT/ETE/App/mule-esb-3.7.3-SIT-PP/${ETE_TYPE}"
					VIT_APPS_HOME1  = "env/VIT/ETE/App/mule-esb-3.7.3-VIT/${ETE_TYPE}"
					UAT_APPS_HOME1  = "env/UAT/ETE/App/mule-esb-3.7.3/${ETE_TYPE}"
					UAT_APPS_HOME2  = "env/UAT/ETE/App/mule-esb-3.7.3-ATM/${ETE_TYPE}"
					UAT_APPS_HOME3  = "env/UAT/ETE/App/mule-esb-3.7.3-PP/${ETE_TYPE}"

					DEV_CONF_HOME1  = "env/DEV/ETE/App/mule-esb-3.7.3-DEV/${ETE_TYPE}"
					DEV_CONF_HOME2  = "env/DEV/ETE/App/mule-esb-3.7.3-DEV-ATM/${ETE_TYPE}"
					DEV_CONF_HOME3  = "env/DEV/ETE/App/mule-esb-3.7.3-DEV-PP/${ETE_TYPE}"
					SIT_CONF_HOME1  = "env/SIT/ETE/App/mule-esb-3.7.3-SIT/${ETE_TYPE}"
					SIT_CONF_HOME2  = "env/SIT/ETE/App/mule-esb-3.7.3-SIT-ATM/${ETE_TYPE}"
					SIT_CONF_HOME3  = "env/SIT/ETE/App/mule-esb-3.7.3-SIT-PP/${ETE_TYPE}"
					VIT_CONF_HOME1  = "env/VIT/ETE/App/mule-esb-3.7.3-VIT/${ETE_TYPE}"
					UAT_CONF_HOME1  = "env/UAT/ETE/App/mule-esb-3.7.3/${ETE_TYPE}"
					UAT_CONF_HOME2  = "env/UAT/ETE/App/mule-esb-3.7.3-ATM/${ETE_TYPE}"
					UAT_CONF_HOME3  = "env/UAT/ETE/App/mule-esb-3.7.3-PP/${ETE_TYPE}"
					
					DEV_BATCH_HOME1 = "env/DEV/ETE/Batch/mule-esb-3.7.3-DEV/${ETE_TYPE}"
                    SIT_BATCH_HOME1 = "env/SIT/ETE/Batch/mule-esb-3.7.3-SIT/${ETE_TYPE}"
					VIT_BATCH_HOME1 = "env/VIT/ETE/Batch/mule-esb-3.7.3-VIT/${ETE_TYPE}"
					UAT_BATCH_HOME1 = "env/UAT/ETE/Batch/mule-esb-3.7.3/${ETE_TYPE}"
					
					DEV_RESULT_HOME1= "env/DEV/ETE/Result/ETEAPP"
					SIT_RESULT_HOME1= "env/SIT/ETE/Result/ETEAPP"
					VIT_RESULT_HOME1= "env/VIT/ETE/Result/ETEAPP"
					UAT_RESULT_HOME1= "env/UAT/ETE/Result/ETEAPP"
					
					DEV_SQL_HOME1   = "env/DEV/ETE/SQL/ETEAPP"
					SIT_SQL_HOME1   = "env/SIT/ETE/SQL/ETEAPP"
					VIT_SQL_HOME1   = "env/VIT/ETE/SQL/ETEAPP"
					UAT_SQL_HOME1   = "env/UAT/ETE/SQL/ETEAPP"
					
	                if (DELETE_DIR == true) {
	                
	                	sh '''
							if [ -d "env" ]
							then
								echo "Delete env directory."
								rm -rf env
							fi
						'''
						sh '''
		                	if [ -d "svn" ]
							then
								echo "Delete svn directory."
								rm -rf svn
							fi
						'''
			            echo "Create required directory for supporting RA"
			            
			            switch (ETE_BRANCH) {

						case ~/DEV/: 
							sh "mkdir -p $DEV_RESULT_HOME1"
			            	sh "mkdir -p $DEV_SQL_HOME1"
							break;
						case ~/SIT/: 
							sh "mkdir -p $SIT_RESULT_HOME1"
			            	sh "mkdir -p $SIT_SQL_HOME1"
			            	sh "mkdir -p $VIT_RESULT_HOME1"
			            	sh "mkdir -p $VIT_SQL_HOME1"
							break;
				        case ~/UAT/: 
							sh "mkdir -p $UAT_RESULT_HOME1"
			            	sh "mkdir -p $UAT_SQL_HOME1"
					        break;
				        case ~/PRD/: 
					        break;
				        default: 
				        	input "Do not known your build environment !";
						}
			        } 

			    }
            }
        }
    	     
        stage('Build applications or domains.') {
			when {
                allOf { 
                    expression { return ETE_TYPE ==~ /(apps|domains)/ };
                    expression { return (!IS_BATCH) }
                    expression { return (ETE_BRANCH != '') } 
                } 
            }
            steps {
            	echo "Checking out source code from SVN..."
            	script {
	            	if (ETE_BRANCH =~ /DEV/) {
	            	    sh "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/trunk/${ETE_TYPE}/${ETE_APP_NAME} ${ETE_REPO}/trunk/${ETE_TYPE}/${ETE_APP_NAME}"
	                
		                dir ("${ETE_REPO}/trunk/${ETE_TYPE}/${ETE_APP_NAME}") {
							
							sh '''
								if [ -f "pom.xml" ]
								then
									export MAVEN_HOME=/home/appusr/bo/apache-maven-3.5.0
									export JAVA_HOME=/home/appusr/bo/jdk1.7.0_80
									export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
									mvn clean package -o
								fi
							'''
						}               	       
	            	} else {
	            		sh "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME} ${ETE_REPO}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}"
	                
		                dir ("${ETE_REPO}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}") {
							
							sh '''
								if [ -f "pom.xml" ]
								then
									export MAVEN_HOME=/home/appusr/bo/apache-maven-3.5.0
									export JAVA_HOME=/home/appusr/bo/jdk1.7.0_80
									export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
									mvn clean package -o
								fi
							'''
						}
	  	
	            	}

				
					switch (ETE_BRANCH) {
						case ~/DEV/:
							println "Wrapping DEV";
							if (ETE_APP_NAME =~ /^atm/) { 
								sh "mkdir -p $DEV_APPS_HOME2"
								sh "cp -rp ${ETE_WORKSPACE}/trunk/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${DEV_APPS_HOME2}"
					
		                    } else if (ETE_APP_NAME =~ /^promptpay/) {
								sh "mkdir -p $DEV_APPS_HOME3"
								sh "cp -rp ${ETE_WORKSPACE}/trunk/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${DEV_APPS_HOME3}"

		                    } else {
		                    	sh "mkdir -p $DEV_APPS_HOME1"
								sh "cp -rp ${ETE_WORKSPACE}/trunk/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${DEV_APPS_HOME1}"
		                    
		                    }				
							break;
						case ~/SIT/: 
							println "Wrapping SIT";
							if (ETE_APP_NAME =~ /^atm/) { 
								sh "mkdir -p $SIT_APPS_HOME2"
								sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${SIT_APPS_HOME2}"
					
		                    } else if (ETE_APP_NAME =~ /^promptpay/) {
								sh "mkdir -p $SIT_APPS_HOME3"
								sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${SIT_APPS_HOME3}"

		                    } else {
		                    	sh "mkdir -p $SIT_APPS_HOME1"
								sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${SIT_APPS_HOME1}"
		                    
		                    }
							println "Wrapping VIT";
							sh "mkdir -p $VIT_APPS_HOME1"
							sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${VIT_APPS_HOME1}"
							break;
				        case ~/UAT/: 
					    	println "Wrapping UAT";    
						    if (ETE_APP_NAME =~ /^atm/) { 
						    	sh "mkdir -p $UAT_APPS_HOME2"
								sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${UAT_APPS_HOME2}"
			                
			                } else if (ETE_APP_NAME =~ /^promptpay/) {
			                    sh "mkdir -p $UAT_APPS_HOME3"
								sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${UAT_APPS_HOME3}"
			                     
			                } else {
			                	sh "mkdir -p $UAT_APPS_HOME1"
								sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${UAT_APPS_HOME1}"
			                
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
        
        stage('Build batches.') {
			when {
                allOf { 
                    expression { return (IS_BATCH) }
                    expression { return (ETE_BRANCH != '') } 
                } 
            }
            steps {

            	echo "Checking out source code from SVN..."

				script {
				
					if (ETE_BRANCH =~ /DEV/) {
	            	    sh "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/trunk/${ETE_TYPE}/${ETE_APP_NAME} ${ETE_REPO}/trunk/${ETE_TYPE}/${ETE_APP_NAME}"
	                
		                dir ("${ETE_REPO}/trunk/${ETE_TYPE}/${ETE_APP_NAME}") {
							
							sh '''
								if [ -f "pom.xml" ]
								then
									export MAVEN_HOME=/home/appusr/bo/apache-maven-3.5.0
									export JAVA_HOME=/home/appusr/bo/jdk1.7.0_80
									export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
									mvn clean package -o
								fi
							'''
						}               	       
	            	} else {
	            		sh "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME} ${ETE_REPO}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}"
	                
		                dir ("${ETE_REPO}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}") {
							
							sh '''
								if [ -f "pom.xml" ]
								then
									export MAVEN_HOME=/home/appusr/bo/apache-maven-3.5.0
									export JAVA_HOME=/home/appusr/bo/jdk1.7.0_80
									export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
									mvn clean package -o
								fi
							'''
						}
	  	
	            	}
					
					switch (ETE_BRANCH) {
						case ~/DEV/:
							sh "mkdir -p $DEV_BATCH_HOME1"
							sh "cp -rp ${ETE_WORKSPACE}/trunk/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${DEV_BATCH_HOME1}"					
							break;
						case ~/SIT/: 
							sh "mkdir -p $SIT_BATCH_HOME1"
							sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${SIT_BATCH_HOME1}"
							sh "mkdir -p $VIT_BATCH_HOME1"
							sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${VIT_BATCH_HOME1}"
							break;
				        case ~/UAT/: 
					    	sh "mkdir -p $UAT_BATCH_HOME1"
							sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${UAT_BATCH_HOME1}"
					        break;
				        case ~/PRD/: 
					        println "PRD"; 
					        break;
				        default: input "Do not known your build environment !";           

					}
 
                }
				
            }
        }
        
        stage('Place configuration files') {
            when {
                allOf { 
                    expression { return ETE_TYPE ==~ /(conf)/ };
                    expression { return (ETE_BRANCH != '') } 
                } 
            }
            steps{
            	echo "Checking out source code from SVN..."
            	
                script {
	                
 					if (ETE_BRANCH =~ /DEV/) {
	            	    sh "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/trunk/${ETE_TYPE} ${ETE_REPO}/trunk/${ETE_TYPE}"
	                } else {
	            		sh "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/branches/${ETE_BRANCH}/${ETE_TYPE} ${ETE_REPO}/branches/${ETE_BRANCH}/${ETE_TYPE}"
	                }
 
 
					switch (ETE_BRANCH) {
						case ~/DEV/: 
		                    sh "mkdir -p $DEV_CONF_HOME3 >/dev/null 2>&1"
		                    sh "mkdir -p $DEV_CONF_HOME2 >/dev/null 2>&1"
		                    sh "mkdir -p $DEV_CONF_HOME1 >/dev/null 2>&1"
		                    sh "cp -rp ${ETE_WORKSPACE}/trunk/${ETE_TYPE}/src/mule-app-global.properties ${DEV_CONF_HOME3}/mule-app-global.properties >/dev/null 2>&1"
		                    sh "cp -rp ${ETE_WORKSPACE}/trunk/${ETE_TYPE}/src/mule-app-global.properties ${DEV_CONF_HOME2}/mule-app-global.properties >/dev/null 2>&1"
		                    sh "cp -rp ${ETE_WORKSPACE}/trunk/${ETE_TYPE}/src/mule-app-global.properties ${DEV_CONF_HOME1}/mule-app-global.properties >/dev/null 2>&1"
					        break;
					        
						case ~/SIT/: 
							sh "mkdir -p $SIT_CONF_HOME3"
		                    sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/src/mule-app-global-SIT.properties ${SIT_CONF_HOME3}/mule-app-global.properties >/dev/null 2>&1"		                    
							sh "mkdir -p $SIT_CONF_HOME2"
		                    sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/src/mule-app-global-SIT.properties ${SIT_CONF_HOME2}/mule-app-global.properties >/dev/null 2>&1"		                    
		                    sh "mkdir -p $SIT_CONF_HOME1"
		                    sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/src/mule-app-global-SIT.properties ${SIT_CONF_HOME1}/mule-app-global.properties >/dev/null 2>&1"
							sh "mkdir -p $VIT_CONF_HOME1"
							sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/src/mule-app-global-VIT.properties ${VIT_CONF_HOME1}/mule-app-global.properties >/dev/null 2>&1"
							break;
							
				        case ~/UAT/: 
				        	sh "mkdir -p $UAT_CONF_HOME3"
		                    sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/src/mule-app-global-UAT.properties ${UAT_CONF_HOME3}/mule-app-global.properties >/dev/null 2>&1"		                    
							sh "mkdir -p $UAT_CONF_HOME2"
		                    sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/src/mule-app-global-UAT.properties ${UAT_CONF_HOME2}/mule-app-global.properties >/dev/null 2>&1"		                    
		                    sh "mkdir -p $UAT_CONF_HOME1"
		                    sh "cp -rp ${ETE_WORKSPACE}/branches/${ETE_BRANCH}/${ETE_TYPE}/src/mule-app-global-UAT.properties ${UAT_CONF_HOME1}/mule-app-global.properties >/dev/null 2>&1"		                    
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
                allOf { 
                    expression { return (SEND_RA) };
                    expression { return (ETE_BRANCH != '') } 
                } 
            }
            steps {
            	script {
	                
	                switch (ETE_BRANCH) {
	                	case ~/DEV/:
	                		dir ("env/DEV") {
								sh "svn export ${ETE_SVN_HOST}/${ETE_REPO}/trunk/docs/ETE_config_manifest.xml ETE"
	                			sh "jar -cMf ETE.zip ETE"           
	                		}
	                		break;
	                	case ~/SIT/:
	                		dir ("env/SIT") {
	                			
								sh "svn export ${ETE_SVN_HOST}/${ETE_REPO}/trunk/docs/ETE_config_manifest.xml ETE"
	                			sh "jar -cMf ETE.zip ETE"        
	                		        
	                		}
							dir ("env/VIT") {
								sh "svn export ${ETE_SVN_HOST}/${ETE_REPO}/trunk/docs/ETE_config_manifest.xml ETE"
	                		    sh "jar -cMf ETE.zip ETE"   
	                		        
	                		}
	                		break;
	                	case ~/UAT/:
	                		dir ("env/UAT") {
	                			sh "svn export ${ETE_SVN_HOST}/${ETE_REPO}/trunk/docs/ETE_config_manifest.xml ETE"
	                		    sh "jar -cMf ETE.zip ETE"   
	                		        
	                		}
	                		break;
	                	case ~/PRD/:
	                		dir ("env/PRD") {
	                			sh "svn export ${ETE_SVN_HOST}/${ETE_REPO}/trunk/docs/ETE_config_manifest.xml ETE"
	                		    sh "jar -cMf ETE.zip ETE"   
	                		        
	                		}
	                		break;
	                	default: input "Do not known your build environment !";             
	                           
	                }

	                
			    }
            }
        }
                        
        stage('Transfering') {
        	when {
                allOf { 
                    expression { return (SEND_RA) };
                    expression { return (ETE_BRANCH != '') } 
                } 
            }
            steps {
                
                script {
	                
	                switch (ETE_BRANCH) {
	                	case ~/DEV/:
	                		dir ("env/DEV") {
	                		    sh "sshpass -p P@ssete17 scp  ETE.zip root@10.200.115.196:/app/DevOps/DEV"  
	                		}
	                		break;
	                	case ~/SIT/:
	                		dir ("env/SIT") {      
	                		    sh "sshpass -p P@ssete17 scp  ETE.zip root@10.200.115.196:/app/DevOps/SIT"    
	                		}
							dir ("env/VIT") { 
	                		    sh "sshpass -p P@ssete17 scp  ETE.zip root@10.200.115.196:/app/DevOps/VIT"   
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
	                	default: echo "Leave it in workspace.";             
	                           
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