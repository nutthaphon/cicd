pipeline {
    agent any
    
    environment {
    	ETE_SVN_HOST='http://10.175.230.180:8080'
		ETE_REPO='svn/ETESystem'
		
		ETE_WORKSPACE='svn/ETESystem'
		
    }
    
    stages {
    	stage('Preparation') {
            steps {
            	script {
            		IS_BATCH = false    
            		switch (params.ETE_TYPE) {
			        case ~/apps/ :
			        	ETE_TYPE='apps'
			        	break;
			        case ~/domains/ :
			        	ETE_TYPE='domains'
			        	break;
			        case ~/conf/ :
			        	ETE_TYPE='conf'
			        	break;
			        default :          
			            ETE_TYPE='apps'
			            IS_BATCH = true
			        }
			        
			        DEV_APPS_HOME1  = "env/DEV/ETE/App/mule-esb-3.7.3-DEV/${ETE_TYPE}"
            	    SIT_APPS_HOME1  = "env/SIT/ETE/App/mule-esb-3.7.3-SIT/${ETE_TYPE}"
					SIT_APPS_HOME2  = "env/SIT/ETE/App/mule-esb-3.7.3-SIT-ATM/${ETE_TYPE}"
					VIT_APPS_HOME1  = "env/VIT/ETE/App/mule-esb-3.7.3-VIT/${ETE_TYPE}"
					UAT_APPS_HOME1  = "env/UAT/ETE/App/mule-esb-3.7.3/${ETE_TYPE}"
					UAT_APPS_HOME2  = "env/UAT/ETE/App/mule-esb-3.7.3-ATM/${ETE_TYPE}"

					DEV_CONF_HOME1  = "env/DEV/ETE/App/mule-esb-3.7.3-DEV/${ETE_TYPE}"
					SIT_CONF_HOME1  = "env/SIT/ETE/App/mule-esb-3.7.3-SIT/${ETE_TYPE}"
					SIT_CONF_HOME2  = "env/SIT/ETE/App/mule-esb-3.7.3-SIT-ATM/${ETE_TYPE}"
					VIT_CONF_HOME1  = "env/VIT/ETE/App/mule-esb-3.7.3-VIT/${ETE_TYPE}"
					UAT_CONF_HOME1  = "env/UAT/ETE/App/mule-esb-3.7.3/${ETE_TYPE}"
					UAT_CONF_HOME2  = "env/UAT/ETE/App/mule-esb-3.7.3-ATM/${ETE_TYPE}"
					
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
					
	                if (params.DELETE_DIR == true) {
	                
	                	echo "Clean temporary directory."
	                	sh '''
		                	if [ -d "svn" ]
							then
								rm -rf svn"
							fi
							if [ -d "env" ]
							then
								rm -rf env"
							fi
						'''
			            echo "Create required directory for supporting RA"
			            
			            switch (params.ETE_BRANCH) {

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
    	     
        stage('Build applications and domains') {
			when {
                expression { return ETE_TYPE ==~ /(apps|domains)/ }
            }
            steps {
            	echo "Checking out source code from SVN..."
            	script {
	            	if (params.ETE_BRANCH =~ /DEV/) {
	            	    sh "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/trunk/${ETE_TYPE}/${params.ETE_APP_NAME} ${ETE_REPO}/trunk/${ETE_TYPE}/${params.ETE_APP_NAME}"
	                
		                dir ("${ETE_REPO}/trunk/${ETE_TYPE}/${params.ETE_APP_NAME}") {
							
							input "Continue ?"
							sh '''
								if [ -f "pom.xml" ]
								then
									mvn clean package"
								fi
							'''
						}               	       
	            	} else {
	            		sh "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME} ${ETE_REPO}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME}"
	                
		                dir ("${ETE_REPO}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME}") {
							
							input "Continue ?"
							sh '''
								if [ -f "pom.xml" ]
								then
									mvn clean package
								fi
							'''
						}
	  	
	            	}

				
					switch (params.ETE_BRANCH) {
						case ~/DEV/:
							println "Wrapping DEV";
							sh '''
								if [ ! -d $DEV_APPS_HOME1 ]
								then
									mkdir -p $DEV_APPS_HOME1
								fi
							'''
							sh '''
		                    	bat "cp -rf ${ETE_WORKSPACE}/trunk/${ETE_TYPE}/${params.ETE_APP_NAME}/target/${params.ETE_APP_NAME}.zip ${DEV_APPS_HOME1}"
							'''
							break;
						case ~/SIT/: 
							println "Wrapping SIT";
							if (params.ETE_APP_NAME =~ /^atm/) { 
								sh '''
									if [ ! -d $SIT_APPS_HOME2 ]
									then
										mkdir -p $SIT_APPS_HOME2
									fi
								'''
								sh '''
			                    	bat "cp -rf ${ETE_WORKSPACE}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME}/target/${params.ETE_APP_NAME}.zip ${SIT_APPS_HOME2}"
								'''
		                    } else {
		                    	sh '''
									if [ ! -d $SIT_APPS_HOME1 ]
									then
										mkdir -p $SIT_APPS_HOME1
									fi
								'''
								sh '''
			                    	bat "cp -rf ${ETE_WORKSPACE}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME}/target/${params.ETE_APP_NAME}.zip ${SIT_APPS_HOME1}"
								'''
		                    }
							println "Wrapping VIT";
							sh '''
								if [ ! -d $VIT_APPS_HOME1 ]
								then
									mkdir -p $VIT_APPS_HOME1
								fi
							'''
							sh '''
			                    bat "cp -rf ${ETE_WORKSPACE}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME}/target/${params.ETE_APP_NAME}.zip ${VIT_APPS_HOME1}"
							'''
							break;
				        case ~/UAT/: 
					    	println "Wrapping UAT";    
						    if (params.ETE_APP_NAME =~ /^atm/) { 
						    	sh '''
									if [ ! -d $UAT_APPS_HOME2 ]
									then
										mkdir -p $UAT_APPS_HOME2
									fi
								'''
								sh '''
			                    	bat "cp -rf ${ETE_WORKSPACE}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME}/target/${params.ETE_APP_NAME}.zip ${UAT_APPS_HOME2}"
								'''
			                } else {
			                	sh '''
									if [ ! -d $UAT_APPS_HOME1 ]
									then
										mkdir -p $UAT_APPS_HOME1
									fi
								'''
								sh '''
			                    	bat "cp -rf ${ETE_WORKSPACE}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME}/target/${params.ETE_APP_NAME}.zip ${UAT_APPS_HOME1}"
								'''
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
        
        stage('Build batches') {
			when {
                expression { return IS_BATCH == true }
            }
            steps {
				


            	echo "Checking out source code from SVN..."
            	bat "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME} ${ETE_REPO}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME}"
                
                dir ("${ETE_REPO}/branches/${params.ETE_BRANCH}/${ETE_TYPE}/${params.ETE_APP_NAME}") {
					
					input "Continue ?"
					bat 'if exist pom.xml mvn clean package'
				
				}
				
				
				script {
					switch (params.ETE_BRANCH) {

						case ~/SIT/: 
							
							bat "if not exist $SIT_BATCH_HOME1 mkdir $SIT_BATCH_HOME1"
		                    bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${SIT_BATCH_HOME1}"	       
							bat "if not exist $VIT_BATCH_HOME1 mkdir $VIT_BATCH_HOME1"
		                    bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${VIT_BATCH_HOME1}"	       
							
							break;
				        case ~/UAT/: 
					    	
							bat "if not exist $UAT_BATCH_HOME1 mkdir $UAT_BATCH_HOME1"
		                    bat "copy /y ${ETE_WORKSPACE}\\branches\\${params.ETE_BRANCH}\\${ETE_TYPE}\\${params.ETE_APP_NAME}\\target\\${params.ETE_APP_NAME}.zip ${UAT_BATCH_HOME1}"	       
							
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
	                			
								bat "svn export ${ETE_SVN_HOST}/${ETE_REPO}/trunk/docs/ETE_config_manifest.xml ETE"
	                			bat "jar -cMf ETE.zip ETE"        
	                		        
	                		}
							dir ("env/VIT") {
								bat "svn export ${ETE_SVN_HOST}/${ETE_REPO}/trunk/docs/ETE_config_manifest.xml ETE"
	                		    bat "jar -cMf ETE.zip ETE"   
	                		        
	                		}
	                		break;
	                	case ~/UAT/:
	                		dir ("env/UAT") {
	                			bat "svn export ${ETE_SVN_HOST}/${ETE_REPO}/trunk/docs/ETE_config_manifest.xml ETE"
	                		    bat "jar -cMf ETE.zip ETE"   
	                		        
	                		}
	                		break;
	                	case ~/PRD/:
	                		dir ("env/PRD") {
	                			bat "svn export ${ETE_SVN_HOST}/${ETE_REPO}/trunk/docs/ETE_config_manifest.xml ETE"
	                		    bat "jar -cMf ETE.zip ETE"   
	                		        
	                		}
	                		break;
	                	default: input "Do not known your build environment !";             
	                           
	                }

	                
			    }
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