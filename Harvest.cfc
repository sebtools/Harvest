<cfcomponent output="no">

<cffunction name="init" access="public" returntype="any" output="no">
	<cfargument name="subdomain" type="string" required="true">
	<cfargument name="username" type="string" required="true">
	<cfargument name="password" type="string" required="true">
	
	<cfset Variables.instance = Arguments>
	
	<cfsavecontent variable="Variables.XmlDefinitions">
	<harvest>
		<definition name="clients" xmlpath="/clients/client/" columns="id,name,active,details,currency,currency_symbol,highrise_id,created_at,updated_at,default_invoice_timeframe,last_invoice_kind,cache_version" />
		<definition name="contacts" xmlpath="/contacts/contact/" columns="id,title,last_name,first_name,email,phone_mobile,fax,client_id,phone_office" />
		<definition name="projects" xmlpath="/projects/project/" columns="id,name,active,billable,bill_by,hourly_rate,client_id,code,notes,budget_by,budget,hint_latest_record_at,hint_earliest_record_at" />
		<definition name="tasks" xmlpath="/tasks/task/" columns="id,name,billable_by_default,deactivated,default_hourly_rate,is_default,updated_at,created_at" />
	</harvest>
	</cfsavecontent>
	
	<cfreturn This>
</cffunction>

<cffunction name="getClients" access="public" output="no">
	<cfargument name="updated_since" type="date" required="no">
	
	<cfset var path = modifyPath("/clients",Arguments)>
	
	<cfreturn convertToQuery(callAPI('GET',path),"/clients/client/","id,name,active,details,currency,currency_symbol,highrise_id,created_at,updated_at,default_invoice_timeframe,last_invoice_kind,cache_version")>
</cffunction>

<cffunction name="getContacts" access="public" output="no">
	<cfargument name="updated_since" type="date" required="no">
	<cfargument name="client_id" type="numeric" required="no">
	
	<cfset var path = "/contacts">
	
	<cfif StructKeyExists(Arguments,"client_id")>
		<cfset path = "/clients/###Arguments.client_id#/contacts">
	</cfif>
	
	<cfset path = modifyPath(path,Arguments)>
	
	<cfreturn convertToQuery(callAPI('GET',path),"/contacts/contact/","id,title,last_name,first_name,email,phone_mobile,fax,client_id,phone_office")>
</cffunction>

<cffunction name="getProjects" access="public" output="no">
	
	<cfreturn convertToQuery(callAPI('GET','/projects'),"/projects/project/","id,name,active,billable,bill_by,hourly_rate,client_id,code,notes,budget_by,budget,hint_latest_record_at,hint_earliest_record_at")>
</cffunction>

<cffunction name="getTasks" access="public" output="no">
	
	<cfreturn convertToQuery(callAPI('GET','/tasks'),"/tasks/task/","id,name,billable_by_default,deactivated,default_hourly_rate,is_default,updated_at,created_at")>
</cffunction>

<cffunction name="getTimeEntries" access="public" output="no">
</cffunction>

<cffunction name="saveClient" access="public" output="no">
	<cfargument name="Name" type="string" required="true">
	<cfargument name="Active" type="boolean" required="false">
	<cfargument name="Details" type="string" required="false">
	<cfargument name="id" type="numeric" required="false">
	<cfargument name="highrise_id" type="numeric" required="false">
	
	<cfset var sArgs = makeAPIArgs("/clients/")>
	
	<cfif StructKeyExists(Arguments,"id")>
		<cfset sArgs.path = "#sArgs.path####Arguments.id#">
		<cfset sArgs.method = "PUT">
	</cfif>
	
	<cfsavecontent variable="sArgs.xml"><cfoutput>
	<client>
	  <name>#XmlFormat(Arguments.Name)#</name>
	  <cfif StructKeyExists(Arguments,"highrise_id")><highrise-id type="integer">#Int(Arguments.highrise_id)#</highrise-id></cfif>
	  <!---<currency>United States Dollars - USD</currency>
	  <currency-symbol>$</currency-symbol>--->
	  <cfif StructKeyExists(Arguments,"active")><active type="boolean"><cfif Arguments.active>true<cfelse>false</cfif></active></cfif>
	  <cfif StructKeyExists(Arguments,"details") AND Len(Arguments.details)><details>#XmlFormat(Arguments.details)#</details></cfif>
	</client>
	</cfoutput></cfsavecontent>
	
	<cfset callAPI(ArgumentCollection=sArgs)>
	
</cffunction>

<cffunction name="saveContact" access="public" output="no">
	<cfargument name="client_id" type="numeric" required="true">
	<cfargument name="first_name" type="string" required="true">
	<cfargument name="last_name" type="string" required="true">
	<cfargument name="email" type="string" required="false">
	<cfargument name="phone_office" type="string" required="false">
	<cfargument name="phone_mobile" type="string" required="false">
	<cfargument name="title" type="string" required="false">
	<cfargument name="fax" type="string" required="false">
	
	<cfset var sArgs = makeAPIArgs("/contacts/")>
	
	<cfif StructKeyExists(Arguments,"id")>
		<cfset sArgs.path = "#sArgs.path####Arguments.id#">
		<cfset sArgs.method = "PUT">
	</cfif>
	
	<cfsavecontent variable="sArgs.xml"><cfoutput>
	<contact>
	  <client-id>#XmlFormat(Arguments.client_id)#</client-id>
	  <cfif StructKeyExists(Arguments,"email")><email>#XmlFormat(Arguments.email)#</email></cfif>
	  <first-name>#XmlFormat(Arguments.first_name)#</first-name>
	  <last-name>#XmlFormat(Arguments.last_name)#</last-name>
	  <cfif StructKeyExists(Arguments,"phone_office")><phone-office>#XmlFormat(Arguments.phone_office)#</phone-office></cfif>
	  <cfif StructKeyExists(Arguments,"phone_mobile")><phone-mobile>#XmlFormat(Arguments.phone_mobile)#</phone-mobile></cfif>
	  <cfif StructKeyExists(Arguments,"title")><title>#XmlFormat(Arguments.title)#</title></cfif>
	  <cfif StructKeyExists(Arguments,"fax")><email>#XmlFormat(Arguments.fax)#</fax></cfif>
	</contact>
	</cfoutput></cfsavecontent>
	
	<cfset callAPI(ArgumentCollection=sArgs)>
	
</cffunction>

<cffunction name="saveProject" access="public" output="no">
	<cfargument name="name" type="string" required="true">
	<cfargument name="client_id" type="numeric" required="true">
	<cfargument name="active" type="boolean" required="false">
	
	<cfset var sArgs = makeAPIArgs("/projects")>
	
	<cfif StructKeyExists(Arguments,"id")>
		<cfset sArgs.path = "#sArgs.path####Arguments.id#">
		<cfset sArgs.method = "PUT">
	</cfif>
	
	<cfsavecontent variable="sArgs.xml"><cfoutput>
	<project>
		<name>#XmlFormat(Arguments.name)#</name>
		<cfif StructKeyExists(Arguments,"active")><active type="boolean"><cfif Arguments.active>true<cfelse>false</cfif></active></cfif>
		<bill-by>none</bill-by>
		<client-id type="integer">#XmlFormat(Arguments.client_id)#</client-id>
		<code></code>
		<notes></notes>
		<budget type="decimal"></budget>
		<budget-by>none</budget-by>
	</project>
	</cfoutput></cfsavecontent>
	
	<cfset callAPI(ArgumentCollection=sArgs)>
	
</cffunction>

<cffunction name="saveTask" access="public" output="no">
	<cfargument name="name" type="string" required="true">
	<cfargument name="billable_by_default" type="boolean" required="true">
	<cfargument name="default_hourly_rate" type="numeric" required="false">
	<cfargument name="is_default" type="boolean" default="false">
	
	<cfset var sArgs = makeAPIArgs("/tasks/")>
	
	<cfif StructKeyExists(Arguments,"id")>
		<cfset sArgs.path = "#sArgs.path####Arguments.id#">
		<cfset sArgs.method = "PUT">
	</cfif>
	
	<cfsavecontent variable="sArgs.xml"><cfoutput>
	<task>
		<billable-by-default type="boolean"><cfif Arguments.billable_by_default>true<cfelse>false</cfif></active></billable-by-default>
		<default-hourly-rate type="decimal">#Arguments.default_hourly_rate#</default-hourly-rate>
		<is-default type="boolean"><cfif Arguments.is_default>true<cfelse>false</cfif></active></is-default>
		<name>#XmlFormat(Arguments.name)#</name>
	</task>
	</cfoutput></cfsavecontent>
	
	<cfset callAPI(ArgumentCollection=sArgs)>
	
</cffunction>

<cffunction name="saveTimeEntry" access="public" output="no">
	<cfargument name="project_id" type="numeric" required="true">
	<cfargument name="task_id" type="numeric" required="true">
	<cfargument name="hours" type="numeric" required="true">
	<cfargument name="date" type="date" required="true">
	<cfargument name="notes" type="string" required="false">
	
	<cfset var sArgs = makeAPIArgs("/daily/add")>
	
	<cfif StructKeyExists(Arguments,"id")>
		<cfset sArgs.path = "#sArgs.path####Arguments.id#">
	</cfif>
	
	<cfsavecontent variable="sArgs.xml"><cfoutput>
	<request>
		<notes><cfif StructKeyExists(Arguments,"notes")>#XmlFormat(Arguments.notes)#</cfif></notes>
		<hours>#Arguments.hours#</hours>
		<project_id type="integer">#Arguments.project_id#</project_id>
		<task_id type="integer">#Arguments.task_id#</task_id>
		<spent_at type="date">#DateFormat(Arguments.date,"ddd, dd mmm yyyy")#</spent_at>
	</request>
	</cfoutput></cfsavecontent>
	
	<cfset callAPI(ArgumentCollection=sArgs)>
	
</cffunction>

<cffunction name="saveUser" access="public" output="no">
	<cfargument name="first_name" type="string" required="true">
	<cfargument name="last_name" type="string" required="true">
	<cfargument name="email" type="string" required="false">
	<cfargument name="telephone" type="string" required="false">
	<cfargument name="timezone" type="string" required="false">
	<cfargument name="is_admin" type="boolean" default="false">
	
	<cfset var sArgs = makeAPIArgs("/people/")>
	
	<cfif StructKeyExists(Arguments,"id")>
		<cfset sArgs.path = "#sArgs.path####Arguments.id#">
		<cfset sArgs.method = "PUT">
	</cfif>
	
	<cfsavecontent variable="sArgs.xml"><cfoutput>
	<user>
		<first-name>#XmlFormat(Arguments.first_name)#</first-name>
		<last-name>#XmlFormat(Arguments.last_name)#</last-name>
		<email>#XmlFormat(Arguments.email)#</email>
		<timezone>Central Time (US & Canada)</timezone><!--- ToDo: Need ability to specify time zones? --->
		<is-admin type="boolean"><cfif Arguments.is_admin>true<cfelse>false</cfif></is-admin>
		<telephone>#XmlFormat(Arguments.telephone)#</telephone>
	</user>
	</cfoutput></cfsavecontent>
	
	<cfset callAPI(ArgumentCollection=sArgs)>
	
</cffunction>

<cffunction name="callAPI" access="public" returntype="any" output="no">
	<cfargument name="method" type="string" required="true">
	<cfargument name="path" type="string" required="true">
	<cfargument name="xml" type="string" default="">
	
	<cfset var CFHTTP = "">
	<cfset var result = "">
	
	<cfif Left(Arguments.path,1) NEQ "/">
		<cfset Arguments.path = "/#Arguments.path#">
	</cfif>
	
	<cfhttp
		url="http://#Variables.instance.subdomain#.harvestapp.com#Arguments.path#"
		username="#Variables.instance.username#"
		password="#Variables.instance.password#"
		method="#Arguments.method#"
	>
		<cfhttpparam type="header" name="Accept" value="application/xml">
		<cfhttpparam type="header" name="Content-Type" value="application/xml">
		<cfif Len(Arguments.xml) AND isXml(Trim(Arguments.xml))>
			<cfhttpparam type="XML" value="#Trim(Arguments.xml)#">
		</cfif>
	</cfhttp>
	
	<cfif Left(Trim(CFHTTP.Statuscode),1) NEQ "2">
		<cfthrow message="#CFHTTP.FileContent#" type="HarvestAPI">
	</cfif>
	
	<cfif isXml(CFHTTP.FileContent)>
		<cfset result = XmlParse(CFHTTP.FileContent)>
	<cfelse>
		<cfset result = CFHTTP.FileContent>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="convertToQuery" access="private" returntype="query" output="no">
	<cfargument name="xResponse" type="xml" required="true">
	<cfargument name="XmlPath" type="string" required="true">
	<cfargument name="Columns" type="string" required="false">
	
	<cfset var axResults = XmlSearch(xResponse,Arguments.XmlPath)>
	<cfset var qResults = 0>
	<cfset var ii = 0>
	<cfset var key = "">
	<cfset var col = "">
	
	<cfset qResults = QueryNew(Arguments.Columns)>
	
	<cfloop index="ii" from="1" to="#ArrayLen(axResults)#">
		<cfset QueryAddRow(qResults)>
		<cfloop index="key" from="1" to="#ArrayLen(axResults[ii].XmlChildren)#">
			<cfset col = ListChangeDelims(axResults[ii].XmlChildren[key].XmlName,"_","-")>
			<cfif ListFindNoCase(Arguments.Columns,col)>
				<cfset QuerySetCell(qResults,col,axResults[ii].XmlChildren[key].XmlText)>
			</cfif>
		</cfloop>
	</cfloop>
	
	<cfreturn qResults>
</cffunction>

<cffunction name="getURLDateString" access="private" returntype="string" output="no">
	<cfargument name="date" type="date" required="true">
	
	<cfset var result = DateFormat(Arguments.date,"yyyy-mm-dd") & TimeFormat(Arguments.date,"HH:mm")>
	
	<cfset var result = URLEncodedFormat(result)>
	
	<cfreturn result>
</cffunction>

<cffunction name="makeAPIArgs" access="private" returntype="struct" output="no">
	<cfargument name="path" type="string" required="true">
	<cfargument name="method" type="string" default="POST">
	<cfargument name="xml" type="string" default="">
	
	<cfreturn StructCopy(Arguments)>
</cffunction>

<cffunction name="modifyPath" access="private" returntype="string" output="no">
	<cfargument name="path" type="string" required="true">
	<cfargument name="Args" type="struct" required="true">
	
	<cfif StructKeyExists(Args,"updated_since")>
		<cfset path = "#path#?updated_since=#getURLDateString(Args.updated_since)#">
	</cfif>
	
	<cfreturn path>
</cffunction>

</cfcomponent>