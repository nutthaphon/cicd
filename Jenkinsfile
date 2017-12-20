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
					
            		//IS_BATCH		= false
            		DELETE_DIR		= params.DELETE_DIR
            		SEND_RA			= params.SEND_RA
            		ETE_BRANCH		= params.ETE_BRANCH
            		ETE_DOMAIN_NAME	= params.ETE_DOMAIN_NAME
            		ETE_APP_NAME	= params.ETE_APP_NAME
            		ETE_BATCH_NAME	= params.ETE_BATCH_NAME
            		ETE_CONF_FILE	= params.ETE_CONF_FILE
            		ETE_PP			= params.ETE_PP
            		
            		if (ETE_BRANCH =~ /DEV/) {
            			SVN_BRANCH_PATH = 'trunk/'
            			
            		} else {
						SVN_BRANCH_PATH = "branches/${ETE_BRANCH}/"
						
            		}
            			
            		if(ETE_APP_NAME != '') { 
				        ETE_TYPE	 = 'apps'
						RA_PATH		 = 'App/'
						
				    } else if (ETE_BATCH_NAME != '') { 
				        ETE_TYPE	 = 'apps'
				        ETE_APP_NAME = ETE_BATCH_NAME
				        //IS_BATCH	 = true
				        RA_PATH		 = 'Batch/'

				    } else if (ETE_DOMAIN_NAME != '') {
				        ETE_TYPE	 = 'domains'
				        ETE_APP_NAME = ETE_DOMAIN_NAME
				        RA_PATH		 = 'App/'

				    } else if (ETE_CONF_FILE != '') {
    					ETE_TYPE	 = 'conf'
    					
    					if (ETE_CONF_FILE == 'Application') { RA_PATH = 'App/' } else { RA_PATH = 'Batch/' }

    					
				    } else if (ETE_SQL_FILE != '') {
				        ETE_TYPE	 = 'spufi'
				        spufi		 = ETE_SQL_FILE.tokenize('\n') 
				        RA_PATH		 = 'SQL/'        
				        
				    } 
			        
			        RA_BASE_PATH	 = "env/${ETE_BRANCH}/ETE/"
			       	
                    RA_REQ_DIR	  = ['App','Batch','Result', 'SQL']
                    RESULT_DIR	  = ['ETEAPP']
                    SQL_DIR		  = ['ETEAPP']
					
					MULE_CONF_NAME = ['mule-app-global.properties'		,'mule-batch-global.properties']
									
					ENV_APPS_INFO = [
					        DEV	 : [	conf	: 'mule-app-global.properties'	  , 	dir		: ['mule-esb-3.7.3-DEV','mule-esb-3.7.3-DEV'	 ,'mule-esb-3.7.3-DEV']],	
					        VIT	 : [	conf	: 'mule-app-global-vit.properties',		dir		: ['mule-esb-3.7.3-VIT','mule-esb-3.7.3-VIT'	 ,'mule-esb-3.7.3-VIT']],
					        SIT	 : [	conf	: 'mule-app-global-sit.properties',		dir		: ['mule-esb-3.7.3-SIT','mule-esb-3.7.3-SIT-ATM' ,'mule-esb-3.7.3-SIT-PP']],
					        UAT	 : [	conf	: 'mule-app-global-uat.properties',		dir		: ['mule-esb-3.7.3'    ,'mule-esb-3.7.3-ATM'     ,'mule-esb-3.7.3-PP']],
					        PPRD : [	conf	: 'mule-app-global-uat.properties',		dir		: ['mule-esb-3.7.3'    ,'mule-esb-3.7.3-ATM'     ,'mule-esb-3.7.3-PP']],
					        PRD	 : [	conf	: 'mule-app-global-uat.properties',		dir		: ['mule-esb-3.7.3'    ,'mule-esb-3.7.3-ATM'     ,'mule-esb-3.7.3-PP']]
					]
					
					ENV_BATCH_INFO = [
					        DEV	 : [	conf	: 'mule-batch-global.properties'	, 	dir		: ['mule-esb-3.7.3-DEV']],	
					        VIT	 : [	conf	: 'mule-batch-global-vit.properties',	dir		: ['mule-esb-3.7.3-VIT']],
					        SIT	 : [	conf	: 'mule-batch-global-sit.properties',	dir		: ['mule-esb-3.7.3-SIT']],
					        UAT	 : [	conf	: 'mule-batch-global-uat.properties',	dir		: ['mule-esb-3.7.3']],
					        PPRD : [	conf	: 'mule-batch-global-uat.properties',	dir		: ['mule-esb-3.7.3']],
					        PRD	 : [	conf	: 'mule-batch-global-uat.properties',	dir		: ['mule-esb-3.7.3']]
					]
					
	                if (DELETE_DIR) {
	                
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
			            
			            dir (RA_BASE_PATH) {
			            	RA_REQ_DIR.eachWithIndex { name, index ->
    							sh "mkdir -p ${name}"
							}     
			            }   
			        } 
			    }
            }
        }
    	     
        stage('Build') {
			when {
                allOf { 
                    expression { return ETE_TYPE ==~ /(apps|domains)/ };
                    expression { return (ETE_BRANCH != '') } 
                } 
            }
            steps {
            	echo "Checking out source code from SVN..."
            	script {

					sh "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/${SVN_BRANCH_PATH}${ETE_TYPE}/${ETE_APP_NAME} ${ETE_REPO}/${SVN_BRANCH_PATH}${ETE_TYPE}/${ETE_APP_NAME}"
	                CURRENT_DIR = "${ETE_REPO}/${SVN_BRANCH_PATH}${ETE_TYPE}/${ETE_APP_NAME}"
					
					dir (CURRENT_DIR) {
							
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
					
					if (ETE_APP_NAME =~ /^atm/) { DIR_IDX = 1; } 
					else if (ETE_APP_NAME =~ /^promptpay/) { DIR_IDX = 2; } 
					else { DIR_IDX = 0; }
					
					sh "mkdir -p ${RA_BASE_PATH}${RA_PATH}${ENV_APPS_INFO[ETE_BRANCH]['dir'][DIR_IDX]}/${ETE_TYPE}"
					sh "cp -rp ${ETE_WORKSPACE}/${SVN_BRANCH_PATH}${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${RA_BASE_PATH}${RA_PATH}${ENV_APPS_INFO[ETE_BRANCH]['dir'][DIR_IDX]}/${ETE_TYPE}"
					
                }
				
            }
        } 
        
        stage('Pick configuration files') {
            when {
                allOf { 
                    expression { return ETE_TYPE ==~ /(conf)/ };
                    expression { return (ETE_BRANCH != '') } 
                } 
            }
            steps{

                script {
                
                	sh "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/${SVN_BRANCH_PATH}${ETE_TYPE} ${ETE_REPO}/${SVN_BRANCH_PATH}${ETE_TYPE}"
					
 					if (RA_PATH == 'App/') {
						ENV_APPS_INFO[ETE_BRANCH]['dir'].eachWithIndex { name, index ->
    						sh "mkdir -p ${RA_PATH}${name}/conf"
    						sh "cp -rp ${ETE_WORKSPACE}/${SVN_BRANCH_PATH}${ETE_TYPE}/src/${ENV_APPS_INFO[ETE_BRANCH]['conf']} ${RA_BASE_PATH}${RA_PATH}${name}/conf/${MULE_CONF_NAME[0]}"
						}
 						       
 					} else {
 					    ENV_BATCH_INFO[ETE_BRANCH]['dir'].eachWithIndex { name, index ->
    						sh "mkdir -p ${RA_PATH}${name}/conf"
    						sh "cp -rp ${ETE_WORKSPACE}/${SVN_BRANCH_PATH}${ETE_TYPE}/src/${ENV_BATCH_INFO[ETE_BRANCH]['conf']} ${RA_BASE_PATH}${RA_PATH}${name}/conf/${MULE_CONF_NAME[1]}"
						}	     
 					}

			    }
                
            }

        }
		
		stage('Pick SQL files') {
            when {
                allOf { 
                    expression { return ETE_TYPE ==~ /(spufi)/ };
                    expression { return (ETE_BRANCH != '') } 
                } 
            }
            steps{
            
                script {
	                
 					if (ETE_BRANCH =~ /DEV/) {
	            	    sh "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/trunk/DBScripts/${ETE_TYPE} ${ETE_REPO}/trunk/DBScripts/${ETE_TYPE}"
	            	    spufi.each {
							sh "cp -rp ${ETE_REPO}/trunk/DBScripts/${ETE_TYPE}/${it} env/${ETE_BRANCH}/ETE/SQL/ETEAPP" 
						} 
	                } else {
	            		sh "svn checkout ${ETE_SVN_HOST}/${ETE_REPO}/branches/${ETE_BRANCH}/DBScripts/${ETE_TYPE} ${ETE_REPO}/branches/${ETE_BRANCH}/DBScripts/${ETE_TYPE}"
	                	spufi.each {
							sh "cp -rp ${ETE_REPO}/branches/${ETE_BRANCH}/DBScripts/${ETE_TYPE}/${it} env/${ETE_BRANCH}/ETE/SQL/ETEAPP"
						}
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