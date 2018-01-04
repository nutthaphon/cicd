pipeline {
    agent any
    
    environment {
    	ETE_SVN_HOST	= 'http://10.175.230.180:8080'
		ETE_REPO		= 'svn/ETESystem'
		ETE_WORKSPACE	= 'svn/ETESystem'

    }
    
    stages {
    	stage('(1) Preparation') {
            steps {
            	script {
					
			        DELETE_DIR		= params.DELETE_DIR
			        ZIP_DIR			= params.ZIP_DIR
			        RA_DEPLOY_TYPE	= params.RA_DEPLOY_TYPE
			        RA_ENV_SERVERS	= params.RA_ENV_SERVERS

            		if(params.ETE_BRANCH != '') {
            			ETE_BRANCH	 	= params.ETE_BRANCH
            			ETE_TYPE	 	= ''
	            		if (ETE_BRANCH =~ /DEV/) { SVN_BRANCH_PATH = 'trunk/' } else { SVN_BRANCH_PATH = "branches/${ETE_BRANCH}/" }
            		}
            			
            		if(params.ETE_APP_NAME != '') { 
            			ETE_APP_NAME 	= params.ETE_APP_NAME
				        ETE_TYPE	 	= 'apps'
						RA_PATH		 	= 'App/'
						
				    } else if (params.ETE_BATCH_NAME != '') {
				    	ETE_BATCH_NAME	= params.ETE_BATCH_NAME
				        ETE_TYPE	 	= 'apps'
				        ETE_APP_NAME 	= ETE_BATCH_NAME
				        RA_PATH		 	= 'Batch/'

				    } else if (params.ETE_DOMAIN_NAME != '') {
				    	ETE_DOMAIN_NAME	= params.ETE_DOMAIN_NAME
				        ETE_TYPE	 	= 'domains'
				        ETE_APP_NAME 	= ETE_DOMAIN_NAME
				        RA_PATH		 	= 'App/'

				    } else if (params.ETE_CONF_FILE != '') {
				    	ETE_CONF_FILE	= params.ETE_CONF_FILE
    					ETE_TYPE	 	= 'conf'
    					
    					if (ETE_CONF_FILE == 'Application') { RA_PATH = 'App/' } else { RA_PATH = 'Batch/' }

				    } else if (params.ETE_SQL_FILE != '') {
				    	ETE_SQL_FILE	= params.ETE_SQL_FILE
				        spufi		 	= ETE_SQL_FILE.tokenize('\n') 
				        ETE_TYPE	 	= 'spufi'
				        RA_PATH		 	= 'SQL/'        
				        
				    } 
					
					if (params.MAIL_TO != '') {
			        	MAIL_TO		= params.MAIL_TO
			        } else {
			        	MAIL_TO		= ''      
			        }

			        RA_ENV_SERVERS_INFO	= [
			        		DEV	 : [ server : ['10.200.115.196', '22', '/app/DevOps/DEV']	,account : ['appadm', 'TMBete123']],
			        		VIT	 : [ server : ['10.200.115.196', '22', '/app/DevOps/VIT']	,account : ['appadm', 'TMBete123']],
			        		SIT	 : [ server : ['10.200.115.196', '22', '/app/DevOps/SIT']	,account : ['appadm', 'TMBete123']],
			        		UAT	 : [ server : ['10.200.115.45' , '22', '/app/DevOps/UAT']	,account : ['appadm', 'ETEuat123']],
			        		PPRD : [ server : ['10.200.115.47' , '22', '/app/DevOps/PREPRD'],account : ['appadm', 'ETEuat123']],
		        			PRD1 : [ server : ['10.200.115.47' , '22', '/app/DevOps/PRD1']	,account : ['appadm', 'ETEuat123']],
			        		PRD3 : [ server : ['10.200.115.47' , '22', '/app/DevOps/PRD3']	,account : ['appadm', 'ETEuat123']],
			        		PRD4 : [ server : ['10.200.115.47' , '22', '/app/DevOps/PRD4']	,account : ['appadm', 'ETEuat123']],
			        		PRDB : [ server : ['10.200.115.47' , '22', '/app/DevOps/BATCH']	,account : ['appadm', 'ETEuat123']]
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
							PRD	 : ['PRD']
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
					
	                sh 'printenv'
	                
			    }
            }
        }
    	
    	stage('(2) Cleanup') {
        	when {
                allOf { 
                    expression { return (DELETE_DIR == true) };
                    expression { return (ETE_BRANCH != '') } 
                } 
            }
            steps {
                
                script {

	                sh """
			            if [ -d 'svn' ]
						then
							echo Delete ${ETE_WORKSPACE}/${SVN_BRANCH_PATH} directory.
							rm -rf ${ETE_WORKSPACE}/${SVN_BRANCH_PATH}
						fi
					"""

		            ENV_REPLICA[ETE_BRANCH].eachWithIndex { envname, envidx ->
			     		sh """
							if [ -d 'env' ]
							then
								echo Delete env/${envname} directory.
								rm -rf env/${envname}
							fi
						"""

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
    	     
        stage('(3) Build') {
			when {
                allOf { 
                    expression { return (ETE_TYPE ==~ /(apps|domains)/) };
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
        
        stage('(4) Pick configuration files') {
            when {
                allOf { 
                    expression { return (ETE_TYPE ==~ /(conf)/) };
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
		
		stage('(5) Pick SQL files') {
            when {
                allOf { 
                    expression { return (ETE_TYPE ==~ /(spufi)/) };
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
		
        stage('(6) Packaging') {
            when {
                allOf { 
                    expression { return (ZIP_DIR) };
                    expression { return (ETE_BRANCH != '') } 
                } 
            }
            steps {
            	script {
            		ENV_REPLICA[ETE_BRANCH].eachWithIndex { envname, envidx ->
			        	
		                dir ("env/${envname}") {
							sh "svn export --force ${ETE_SVN_HOST}/${ETE_REPO}/${SVN_BRANCH_PATH}docs/ETE_config_manifest.xml ETE"
							
							//choice 1
							sh "zip -vr ETE-3.zip ./ETE -x \"ETE/App/mule-esb-3.7.3-ATM/*\" -x \"ETE/App/mule-esb-3.7.3-PP/*\""
							//choice 2
							sh "zip -vr ETE-NOPP.zip ./ETE -x \"ETE/App/mule-esb-3.7.3-PP/*\""
							//choice 3
							sh "zip -vr ETE-NOATM.zip ./ETE -x \"ETE/App/mule-esb-3.7.3-ATM/*\""
		                	//choice 4
		                	sh "zip -vr ETE-ALL.zip ./ETE" 
		                	  
		                }
		            }    
			    }
            }
        }
                        
        stage('(7) Transfering') {
        	when {
                allOf { 
                    expression { return (RA_DEPLOY_TYPE != '') };
                    expression { return (RA_ENV_SERVERS != '') };
                    expression { return (ETE_BRANCH != '') } 
                } 
            }
            steps {
                
                script {
		        	dir ("env/${ETE_BRANCH}") {
		            	sh "sshpass -v -p ${RA_ENV_SERVERS_INFO[RA_ENV_SERVERS]['account'][1]} scp -P ${RA_ENV_SERVERS_INFO[RA_ENV_SERVERS]['server'][1]} ${RA_DEPLOY_TYPE}.zip ${RA_ENV_SERVERS_INFO[RA_ENV_SERVERS]['account'][0]}@${RA_ENV_SERVERS_INFO[RA_ENV_SERVERS]['server'][0]}:${RA_ENV_SERVERS_INFO[RA_ENV_SERVERS]['server'][2]}/ETE.zip"
		            }
			    }
            }
        }

        
    }
    post {
        success {
        	mail (to: "${MAIL_TO}",
         	subject: "ETE Build Job '${env.JOB_NAME}' (${env.BUILD_NUMBER})",
         	mimeType: 'text/html',
         	body: "${ETE_TYPE} ${ETE_DOMAIN_NAME}${ETE_APP_NAME}${ETE_BATCH_NAME}${ETE_CONF_FILE}${ETE_SQL_FILE} on branch ${ETE_BRANCH} built <font color=\'green\'>SUCCESS</font>. <br> FTP => ${RA_DEPLOY_TYPE}. <br> see <a href=\'${env.BUILD_URL}consoleText\'>Console Log</a>");
        }
        failure {
        	mail (to: "${MAIL_TO}",
         	subject: "ETE Build Job '${env.JOB_NAME}' (${env.BUILD_NUMBER})",
         	mimeType: 'text/html',
         	body: "${ETE_TYPE} ${ETE_DOMAIN_NAME}${ETE_APP_NAME}${ETE_BATCH_NAME}${ETE_CONF_FILE}${ETE_SQL_FILE} on branch ${ETE_BRANCH} built <font color=\'red\'>ERROR</font>.  <br> FTP => ${RA_DEPLOY_TYPE}. <br> see <a href=\'${env.BUILD_URL}consoleText\'>Console Log</a>");
        }
    }
    
}