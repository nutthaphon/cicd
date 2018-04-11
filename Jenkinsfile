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
			        JAVA_VERSION	= params.JAVA_VERSION
			        MAVEN_VERSION	= params.MAVEN_VERSION
			        WORKSPACE_URL	= ''

            		if(params.ETE_BRANCH != '') {
            			ETE_BRANCH	 	= params.ETE_BRANCH
            			ETE_TYPE	 	= ''
	            		if (ETE_BRANCH =~ /DEV/) { SVN_BRANCH_PATH = 'trunk/' } else { SVN_BRANCH_PATH = "branches/${ETE_BRANCH}/" }
            		}
            			
            		if(params.SVN_APP_NAME != '') { 
            			SVN_APP_NAME	= params.SVN_APP_NAME
            			ETE_APP_NAME 	= SVN_APP_NAME.toLowerCase()
				        ETE_TYPE	 	= 'apps'
						RA_PATH		 	= 'App/'
						
				    } else if (params.SVN_BATCH_NAME != '') {
				    	SVN_BATCH_NAME	= params.SVN_BATCH_NAME
				    	ETE_BATCH_NAME	= SVN_BATCH_NAME.toLowerCase()
				        ETE_TYPE	 	= 'apps'
				        ETE_APP_NAME 	= ETE_BATCH_NAME
				        SVN_APP_NAME 	= SVN_BATCH_NAME
				        RA_PATH		 	= 'Batch/'

				    } else if (params.SVN_DOMAIN_NAME != '') {
				    	SVN_DOMAIN_NAME	= params.SVN_DOMAIN_NAME
				    	ETE_DOMAIN_NAME	= SVN_DOMAIN_NAME.toLowerCase()
				        ETE_TYPE	 	= 'domains'
				        ETE_APP_NAME 	= ETE_DOMAIN_NAME
				        SVN_APP_NAME 	= SVN_DOMAIN_NAME
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
										
					//For build app
					BRANCH_TO_ENV	   = [
							DEV	 : ['DEV'],
							SIT	 : ['SIT', 'VIT'],
							UAT	 : ['UAT'],
							PRD	 : ['PRD', 'PPRD']
					]
					
					//For deployment
					ENV_TO_SERVER	   = [
							DEV	 : ['DEV'],
							SIT	 : ['SIT'],
							VIT	 : ['VIT'],
							UAT	 : ['UAT'],
							PRD	 : ['PRD1', 'PRD3', 'PRD4', 'PRDB', 'PPRD']
					]
						
					ENV_APPS_INFO  = [
					        DEV	 : [	conf	: 'mule-app-global{.,-[1-9].}properties'	  	, 		dir		: ['mule-esb-3.7.3-DEV','mule-esb-3.7.3-DEV'	 ,'mule-esb-3.7.3-DEV'		,'mule-esb-3.9.0-DEV']],	
					        VIT	 : [	conf	: 'mule-app-global{-vit.,-[1-9]-vit.}properties',		dir		: ['mule-esb-3.7.3-VIT','mule-esb-3.7.3-VIT'	 ,'mule-esb-3.7.3-VIT'		,'mule-esb-3.9.0-VIT']],
					        SIT	 : [	conf	: 'mule-app-global{-sit.,-[1-9]-sit.}properties',		dir		: ['mule-esb-3.7.3-SIT','mule-esb-3.7.3-SIT-ATM' ,'mule-esb-3.7.3-SIT-PP'	,'mule-esb-3.9.0-SIT']],
					        UAT	 : [	conf	: 'mule-app-global{-uat.,-[1-9]-uat.}properties',		dir		: ['mule-esb-3.7.3'    ,'mule-esb-3.7.3-ATM'     ,'mule-esb-3.7.3-PP'		,'mule-esb-3.9.0']],
					        PPRD : [	conf	: 'mule-app-global{-uat.,-[1-9]-uat.}properties',		dir		: ['mule-esb-3.7.3'    ,'mule-esb-3.7.3-ATM'     ,'mule-esb-3.7.3-PP'		,'mule-esb-3.9.0']],
					        PRD	 : [	conf	: 'mule-app-global{-uat.,-[1-9]-uat.}properties',		dir		: ['mule-esb-3.7.3'    ,'mule-esb-3.7.3-ATM'     ,'mule-esb-3.7.3-PP'		,'mule-esb-3.9.0']]
					]
					
					ENV_BATCH_INFO = [
					        DEV	 : [	conf	: 'mule-batch-global{.,-[1-9].}properties'		, 	dir		: ['mule-esb-3.7.3-DEV']],	
					        VIT	 : [	conf	: 'mule-batch-global{-vit.,-[1-9]-vit.}properties',	dir		: ['mule-esb-3.7.3-VIT']],
					        SIT	 : [	conf	: 'mule-batch-global{-sit.,-[1-9]-sit.}properties',	dir		: ['mule-esb-3.7.3-SIT']],
					        UAT	 : [	conf	: 'mule-batch-global{-uat.,-[1-9]-uat.}properties',	dir		: ['mule-esb-3.7.3']],
					        PPRD : [	conf	: 'mule-batch-global{-uat.,-[1-9]-uat.}properties',	dir		: ['mule-esb-3.7.3']],
					        PRD	 : [	conf	: 'mule-batch-global{-uat.,-[1-9]-uat.}properties',	dir		: ['mule-esb-3.7.3']]
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

		            BRANCH_TO_ENV[ETE_BRANCH].eachWithIndex { envname, envidx ->
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

					sh "svn checkout --force ${ETE_SVN_HOST}/${ETE_REPO}/${SVN_BRANCH_PATH}${ETE_TYPE}/${SVN_APP_NAME} ${ETE_REPO}/${SVN_BRANCH_PATH}${ETE_TYPE}/${ETE_APP_NAME}"
	                CURRENT_DIR = "${ETE_REPO}/${SVN_BRANCH_PATH}${ETE_TYPE}/${ETE_APP_NAME}"
					
					dir (CURRENT_DIR) {
							
							sh '''
								if [ -f "pom.xml" ]
								then
									export MAVEN_HOME=/app/installed/${MAVEN_VERSION}
									export JAVA_HOME=/app/installed/${JAVA_VERSION}
									export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
									mvn -v
									mvn clean package -o
									
									cd target
									zip -g *.zip classes/* > /dev/null 2>&1 || echo "Empty Directory"
									unzip -v *.zip
									
								fi
							'''
					}
					
					switch(ETE_APP_NAME) {
					case ~/^atm/:
									DIR_IDX = 1;
									break;
					case ~/^promptpay/:
									DIR_IDX = 2;
									break;
					case ~/^eventtrigger/:
									DIR_IDX = 3;
									break;
					default:
									DIR_IDX = 0;
					}
					
					BRANCH_TO_ENV[ETE_BRANCH].eachWithIndex { envname, envidx ->
					    RA_BASE_PATH = "env/${envname}/ETE/"
						sh "mkdir -p ${RA_BASE_PATH}${RA_PATH}${ENV_APPS_INFO[envname]['dir'][DIR_IDX]}/${ETE_TYPE}"
						sh "cp -rp ${ETE_WORKSPACE}/${SVN_BRANCH_PATH}${ETE_TYPE}/${ETE_APP_NAME}/target/${ETE_APP_NAME}.??? ${RA_BASE_PATH}${RA_PATH}${ENV_APPS_INFO[envname]['dir'][DIR_IDX]}/${ETE_TYPE}"
					}
					
					WORKSPACE_URL	= "${env.BUILD_URL}execution/node/3/ws/${ETE_WORKSPACE}/${SVN_BRANCH_PATH}${ETE_TYPE}/${ETE_APP_NAME}/target/"

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
				
			        BRANCH_TO_ENV[ETE_BRANCH].eachWithIndex { envname, envidx ->
			        	RA_BASE_PATH = "env/${envname}/ETE/"
			        	ENV_LOWERCASE = envname.toLowerCase()
 					
	 					if (RA_PATH == 'App/') {
							ENV_APPS_INFO[envname]['dir'].eachWithIndex { name, diridx ->
	    						
	    						sh "mkdir -p ${RA_BASE_PATH}${RA_PATH}${name}/conf"
								
								sh "cp -rp ${ETE_WORKSPACE}/${SVN_BRANCH_PATH}${ETE_TYPE}/src/${ENV_APPS_INFO[envname]['conf']} ${RA_BASE_PATH}${RA_PATH}${name}/conf || echo Copy files fail!; rename -- '-${ENV_LOWERCASE}' '' ${RA_BASE_PATH}${RA_PATH}${name}/conf/*"   
	    						
							}
	 						       
	 					} else {
	 					    ENV_BATCH_INFO[envname]['dir'].eachWithIndex { name, diridx ->
	    						
	    						sh "mkdir -p ${RA_BASE_PATH}${RA_PATH}${name}/conf"
	    						
	    						sh "cp -rp ${ETE_WORKSPACE}/${SVN_BRANCH_PATH}${ETE_TYPE}/src/${ENV_BATCH_INFO[envname]['conf']} ${RA_BASE_PATH}${RA_PATH}${name}/conf || echo Copy files fail!; rename -- '-${ENV_LOWERCASE}' '' ${RA_BASE_PATH}${RA_PATH}${name}/conf/*"
	    							    						
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
                	
	                BRANCH_TO_ENV[ETE_BRANCH].eachWithIndex { envname, envidx ->
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
            		BRANCH_TO_ENV[ETE_BRANCH].eachWithIndex { envname, envidx ->
			        	
		                dir ("env/${envname}") {
							sh "svn export --force ${ETE_SVN_HOST}/${ETE_REPO}/${SVN_BRANCH_PATH}docs/jenkins/ETE_config_manifest.xml ETE"
							
							//choice 1
							sh "zip -vr ETE-3.zip ./ETE -x \"ETE/App/*-ATM/*\" -x \"ETE/App/*-PP/*\""
							//choice 2
							sh "zip -vr ETE-NOPP.zip ./ETE -x \"ETE/App/*-PP/*\""
							//choice 3
							sh "zip -vr ETE-NOATM.zip ./ETE -x \"ETE/App/*-ATM/*\""
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
                	CURR_DIR = ENV_TO_SERVER.find{ value -> value =~ /${RA_ENV_SERVERS}/ }.key
		        	dir ("env/${CURR_DIR}") {
		            	sh "svn export --force ${ETE_SVN_HOST}/${ETE_REPO}/${SVN_BRANCH_PATH}docs/jenkins/ete"
		            	sh "chmod 600 ete"
		            	sh "scp -i ete -P ${RA_ENV_SERVERS_INFO[RA_ENV_SERVERS]['server'][1]} ${RA_DEPLOY_TYPE}.zip ${RA_ENV_SERVERS_INFO[RA_ENV_SERVERS]['account'][0]}@${RA_ENV_SERVERS_INFO[RA_ENV_SERVERS]['server'][0]}:${RA_ENV_SERVERS_INFO[RA_ENV_SERVERS]['server'][2]}/ETE.zip"
		            }
			    }
            }
        }

        
    }
    
    post {
        success {
        	mail (to: "${ETE_CM_EMAIL}",
         	subject: "ETE Build Job '${env.JOB_NAME}' (${env.BUILD_NUMBER}) Success.",
         	mimeType: 'text/html',
         	body: "${ETE_TYPE} ${SVN_APP_NAME}${SVN_DOMAIN_NAME}${SVN_BATCH_NAME}${ETE_CONF_FILE} on branch ${ETE_BRANCH} built <font color=\'green\'>SUCCESS</font>. <br> FTP => ${RA_DEPLOY_TYPE}. <br> access <a href=\'${WORKSPACE_URL}\'>Workspace</a> <br> see <a href=\'${env.BUILD_URL}consoleText\'>Console Log</a>");
        }
        failure {
        	mail (to: "${ETE_CM_EMAIL}",
         	subject: "ETE Build Job '${env.JOB_NAME}' (${env.BUILD_NUMBER}) Fail.",
         	mimeType: 'text/html',
         	body: "${ETE_TYPE} ${SVN_APP_NAME}${SVN_DOMAIN_NAME}${SVN_BATCH_NAME}${ETE_CONF_FILE} on branch ${ETE_BRANCH} built <font color=\'red\'>FAIL</font>.  <br> FTP => ${RA_DEPLOY_TYPE}. <br> access <a href=\'${WORKSPACE_URL}\'>Workspace</a> <br> see <a href=\'${env.BUILD_URL}consoleText\'>Console Log</a>");
        }
    }
    
}