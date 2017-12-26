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
					FTP_CONSOLE		= ''
            		DELETE_DIR		= params.DELETE_DIR
            		SEND_RA			= params.SEND_RA
            		ETE_BRANCH		= params.ETE_BRANCH
            		ETE_DOMAIN_NAME	= params.ETE_DOMAIN_NAME
            		ETE_APP_NAME	= params.ETE_APP_NAME
            		ETE_BATCH_NAME	= params.ETE_BATCH_NAME
            		ETE_CONF_FILE	= params.ETE_CONF_FILE
            		ETE_PP			= params.ETE_PP
            		
            		if (ETE_BRANCH =~ /DEV/) {	SVN_BRANCH_PATH = 'trunk/'} else {	SVN_BRANCH_PATH = "branches/${ETE_BRANCH}/"}
            			
            		if(ETE_APP_NAME != '') { 
				        ETE_TYPE	 = 'apps'
						RA_PATH		 = 'App/'
						
				    } else if (ETE_BATCH_NAME != '') { 
				        ETE_TYPE	 = 'apps'
				        ETE_APP_NAME = ETE_BATCH_NAME
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
			        
			        FTP_SERVER_INFO	= [
			        		DEV	 : [ server : ['10.200.115.196', '22', '/app/DevOps/DEV'], account : ['root', 'P@ssete17']],
			        		VIT	 : [ server : ['10.200.115.196', '22', '/app/DevOps/VIT'], account : ['root', 'P@ssete17']],
			        		SIT	 : [ server : ['10.200.115.196', '22', '/app/DevOps/SIT'], account : ['root', 'P@ssete17']],
			        		UAT	 : [ server : ['10.200.115.196', '22', '/app/DevOps/UAT'], account : ['root', 'P@ssete17']],
			        		PPRD : [ server : ['10.200.115.196', '22', '/app/DevOps/PPRD'],account : ['root', 'P@ssete17']],
			        		PRD	 : [ server : ['10.200.115.196', '22', '/app/DevOps/PRD'], account : ['root', 'P@ssete17']]
			        ]
			        
					RA_REQ_DIR	  = [
							prog : 	[	'App',	'Batch'],
							db 	 : 	[
										[ 	sql		: 'Result/ETEAPP',		result		: 'SQL/ETEAPP']
								  	]
					]
					
					MULE_CONF_NAME = ['mule-app-global.properties'		,'mule-batch-global.properties']
					
					ENV_REPLICA	   = [
							DEV	 : ['DEV'],
							SIT	 : ['SIT', 'VIT'],
							UAT	 : ['UAT'],
							PRD	 : ['PRD', 'PPRD']
					]
							
					ENV_APPS_INFO  = [
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
								rm -rf env/*
							fi
						'''
						sh '''
		                	if [ -d "svn" ]
							then
								echo "Delete svn directory."
								rm -rf svn/*
							fi
						'''

			            ENV_REPLICA[ETE_BRANCH].eachWithIndex { envname, envidx ->
			            	RA_BASE_PATH = "env/${envname}/ETE/"
				            dir (RA_BASE_PATH) {
				            	RA_REQ_DIR['prog'].eachWithIndex { dir, diridx ->
	    							sh "mkdir -p ${dir}"
								}
								RA_REQ_DIR['db'].eachWithIndex { dir, diridx ->
	    							sh "mkdir -p ${dir['sql']}"
	    							sh "mkdir -p ${dir['result']}"
								}    
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

            	script {

					sh "svn checkout --force ${ETE_SVN_HOST}/${ETE_REPO}/${SVN_BRANCH_PATH}${ETE_TYPE}/${ETE_APP_NAME} ${ETE_REPO}/${SVN_BRANCH_PATH}${ETE_TYPE}/${ETE_APP_NAME}"
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
					
					ENV_REPLICA[ETE_BRANCH].eachWithIndex { envname, envidx ->
					    RA_BASE_PATH = "env/${envname}/ETE/"
						sh "mkdir -p ${RA_BASE_PATH}${RA_PATH}${ENV_APPS_INFO[envname]['dir'][DIR_IDX]}/${ETE_TYPE}"
						sh "cp -rp ${ETE_WORKSPACE}/${SVN_BRANCH_PATH}${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.zip ${RA_BASE_PATH}${RA_PATH}${ENV_APPS_INFO[envname]['dir'][DIR_IDX]}/${ETE_TYPE}"
					}
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
                
                	sh "svn checkout --force ${ETE_SVN_HOST}/${ETE_REPO}/${SVN_BRANCH_PATH}${ETE_TYPE} ${ETE_REPO}/${SVN_BRANCH_PATH}${ETE_TYPE}"
				
			        ENV_REPLICA[ETE_BRANCH].eachWithIndex { envname, envidx ->
			        	RA_BASE_PATH = "env/${envname}/ETE/"
 					
	 					if (RA_PATH == 'App/') {
							ENV_APPS_INFO[envname]['dir'].eachWithIndex { name, diridx ->
	    						sh "mkdir -p ${RA_BASE_PATH}${RA_PATH}${name}/conf"
	    						sh "cp -rp ${ETE_WORKSPACE}/${SVN_BRANCH_PATH}${ETE_TYPE}/src/${ENV_APPS_INFO[envname]['conf']} ${RA_BASE_PATH}${RA_PATH}${name}/conf/${MULE_CONF_NAME[0]}"
							}
	 						       
	 					} else {
	 					    ENV_BATCH_INFO[envname]['dir'].eachWithIndex { name, diridx ->
	    						sh "mkdir -p ${RA_BASE_PATH}${RA_PATH}${name}/conf"
	    						sh "cp -rp ${ETE_WORKSPACE}/${SVN_BRANCH_PATH}${ETE_TYPE}/src/${ENV_BATCH_INFO[envname]['conf']} ${RA_BASE_PATH}${RA_PATH}${name}/conf/${MULE_CONF_NAME[1]}"
							}	     
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
                
                	sh "svn checkout --force ${ETE_SVN_HOST}/${ETE_REPO}/${SVN_BRANCH_PATH}DBScripts/${ETE_TYPE} ${ETE_REPO}/${SVN_BRANCH_PATH}DBScripts/${ETE_TYPE}"
                	
	                ENV_REPLICA[ETE_BRANCH].eachWithIndex { envname, envidx ->
			        	RA_BASE_PATH = "env/${envname}/ETE/"
			        	
	 					if (envname =~ /DEV/) {
		            	    spufi.each {
								sh "cp -rp ${ETE_REPO}/trunk/DBScripts/${ETE_TYPE}/${it} ${RA_BASE_PATH}SQL/ETEAPP" 
							} 
		                } else {
		                	spufi.each {
								sh "cp -rp ${ETE_REPO}/branches/${ETE_BRANCH}/DBScripts/${ETE_TYPE}/${it} ${RA_BASE_PATH}SQL/ETEAPP"
							}
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
            		ENV_REPLICA[ETE_BRANCH].eachWithIndex { envname, envidx ->
			        	
		                dir ("env/${envname}") {
							sh "svn export --force ${ETE_SVN_HOST}/${ETE_REPO}/${SVN_BRANCH_PATH}docs/ETE_config_manifest.xml ETE"
		                	sh "jar -cMf ETE.zip ETE"           
		                }
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
                	ENV_REPLICA[ETE_BRANCH].eachWithIndex { envname, envidx ->
		                dir ("env/${envname}") {
		                	FTP_CONSOLE = sh returnStdout: true, script: "sshpass -p ${FTP_SERVER_INFO[envname]['account'][1]} scp -P ${FTP_SERVER_INFO[envname]['server'][1]} ETE.zip ${FTP_SERVER_INFO[envname]['account'][0]}@${FTP_SERVER_INFO[envname]['server'][0]}:${FTP_SERVER_INFO[envname]['server'][2]}"
		                }
	                } 
			    }
            }
        }

        
    }
    post {
        success {
        	mail (to: '47238@tmbbank.com',
         	subject: "ETE Build Job '${env.JOB_NAME}' (${env.BUILD_NUMBER})",
         	body: "${ETE_DOMAIN_NAME}${ETE_APP_NAME}${ETE_BATCH_NAME}${ETE_CONF_FILE}${ETE_SQL_FILE} on branch ${ETE_BRANCH} built with successful. \n ${FTP_CONSOLE}");
        }
        failure {
        	mail (to: '47238@tmbbank.com',
         	subject: "ETE Build Job '${env.JOB_NAME}' (${env.BUILD_NUMBER})",
         	body: "${ETE_DOMAIN_NAME}${ETE_APP_NAME}${ETE_BATCH_NAME}${ETE_CONF_FILE}${ETE_SQL_FILE} on branch ${ETE_BRANCH} built with error.  \n ${FTP_CONSOLE}");
        }
    }
    
}