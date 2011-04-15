<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common"
	extension-element-prefixes="exsl"
	xmlns:OpenClinica="http://www.openclinica.org/ns/odm_ext_v130/v3.1"
	xmlns:odm="http://www.cdisc.org/ns/odm/v1.3">

	<xsl:variable name="language">
		<xsl:text>en</xsl:text>
	</xsl:variable>
	<xsl:variable name="E" select="'E'" />
	<xsl:variable name="C" select="'C'" />
	<xsl:variable name="datasetDesc" select="/odm:ODM/@Description" />
	<xsl:variable name="study" select="/odm:ODM/odm:Study[1]" />
	<xsl:variable name="protocolNameStudy"
		select="$study/odm:GlobalVariables/odm:ProtocolName" />
	<xsl:variable name="studyName"
		select="$study/odm:GlobalVariables/odm:StudyName" />
	<xsl:variable name="crfDetails"
		select="/odm:ODM/odm:Study/odm:MetaDataVersion/odm:FormDef" />
	<xsl:variable name="groupDetails"
		select="/odm:ODM/odm:Study/odm:MetaDataVersion/odm:ItemGroupDef" />
	<xsl:variable name="itemDef"
		select="/odm:ODM/odm:Study/odm:MetaDataVersion/odm:ItemDef" />
	<xsl:variable name="codeList"
		select="/odm:ODM/odm:Study/odm:MetaDataVersion/odm:CodeList" />
	<xsl:variable name="eventDefCount"
		select="count(/odm:ODM/odm:Study/odm:MetaDataVersion/odm:StudyEventDef)" />

	<!-- Getting the Dataset Name -->
	<xsl:variable name="fileName" select="/odm:ODM/@FileOID" />
	<xsl:variable name="year"
		select="substring(/odm:ODM/@CreationDateTime, 1, 4)" />
	<xsl:variable name="D_year" select="concat('D', $year)" />
	<xsl:variable name="datasetName" select="substring-before($fileName, $D_year)" />

	<xsl:variable name="desc" select="/odm:ODM/@Description" />
	<xsl:variable name="subject_count"
		select="count(/odm:ODM/odm:ClinicalData/odm:SubjectData)" />

	<xsl:key name="studyEvents" match="odm:StudyEventData" use="@StudyEventOID"></xsl:key>
	<xsl:key name="eventCRFs" match="odm:FormData" use="@FormOID"></xsl:key>
	<xsl:key name="itemDataKey" match="odm:ItemData" use="@ItemOID"></xsl:key>

	<xsl:variable name="sexExist" select="//odm:SubjectData/@OpenClinica:Sex" />
	<xsl:variable name="uniqueIdExist"
		select="//odm:SubjectData/@OpenClinica:UniqueIdentifier" />
	<xsl:variable name="dobExist"
		select="//odm:SubjectData/@OpenClinica:DateOfBirth" />
	<xsl:variable name="subjectStatusExist" select="//odm:SubjectData/@OpenClinica:Status" />

	<xsl:variable name="eventLocationExist"
		select="//odm:StudyEventData/@OpenClinica:StudyEventLocation" />
	<xsl:variable name="eventStartDateExist"
		select="//odm:StudyEventData/@OpenClinica:StartDate" />
	<xsl:variable name="eventEndDateExist"
		select="//odm:StudyEventData/@OpenClinica:EndDate" />
	<xsl:variable name="eventStatusExist"
		select="//odm:StudyEventData/@OpenClinica:Status" />
	<xsl:variable name="ageExist"
		select="//odm:StudyEventData/@OpenClinica:SubjectAgeAtEvent" />

	<xsl:variable name="crfVersionExist" select="//odm:FormData/@OpenClinica:Version" />
	<xsl:variable name="interviewerNameExist"
		select="//odm:FormData/@OpenClinica:InterviewerName" />
	<xsl:variable name="interviewDateExist"
		select="//odm:FormData/@OpenClinica:InterviewDate" />
	<xsl:variable name="crfStatusExist" select="//odm:FormData/@OpenClinica:Status" />

	<xsl:strip-space elements="*" />
	<xsl:template match="/">
		<html>
			<script language="JavaScript1.2">
				function openWin(ele) {
				
				newwin =
				window.open('', 'windowname1', 'width=900', 'height=500','scrollbars=1');
				var divTxt = document.getElementById(ele);
				var newdiv
				= newwin.document.createElement('div');
				newdiv.innerHTML =
				divTxt.innerHTML;
				newwin.document.body.appendChild(newdiv);
				}

            </script>


			<body>
				<br />
				<h1>
					View Dataset
					<xsl:value-of select="$datasetName" />
				</h1>

				<div class="tablebox_center" align="left">
					<table border="1" cellpadding="0" cellspacing="0">
					<!-- Fix for 0007973 -->
					<!--
						<tr valign="top">
							<td class="table_header_column_top">Database Export Header Metadata</td>
							<td class="table_cell_top">
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
							</td>
							<td class="table_cell_top">
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
							</td>
						</tr>
						--><tr>
							<td class="table_header_column">Dataset Name:</td>
							<td class="table_cell">
								<xsl:value-of select="$datasetName" />
							</td>
							<td class="table_cell">
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
							</td>
						</tr>
						<tr>
							<td class="table_header_column">Dataset Description:</td>
							<td class="table_cell">
								<xsl:value-of select="$desc" />
							</td>
							<td class="table_cell">
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
							</td>
						</tr>
						<tr>
							<td class="table_header_column">Study Name:</td>
							<td class="table_cell">
								<xsl:value-of select="$study/odm:GlobalVariables/odm:StudyName" />
							</td>
							<td class="table_cell">
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
							</td>
						</tr>
						<tr>
							<td class="table_header_column">Protocol ID:</td>
							<td class="table_cell">
								<xsl:value-of select="$protocolNameStudy" />
							</td>
							<td class="table_cell">
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
							</td>
						</tr>
						<tr>
							<td class="table_header_column">Date:</td>
							<td class="table_cell">
								<xsl:call-template name="FormatDate">
									<xsl:with-param name="DateTime"
										select="/odm:ODM/@CreationDateTime" />
								</xsl:call-template>
							</td>
							<td class="table_cell">
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
							</td>
						</tr>
						<tr>
							<td class="table_header_column">Subjects:</td>
							<td class="table_cell">
								<xsl:value-of select="$subject_count" />
							</td>
							<td class="table_cell">
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
							</td>
						</tr>
						<tr>
							<td class="table_header_column">Study Event Definitions:</td>
							<td class="table_cell">
								<xsl:value-of select="$eventDefCount" />
							</td>
							<td class="table_cell">
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
							</td>
						</tr>
	<xsl:apply-templates
			select="//odm:ODM/odm:Study/odm:MetaDataVersion"
			 mode="metadataDisplay"/>

						<!-- placeholder 1 studyeventdata -->
						<!--<xsl:apply-templates
							select="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData[generate-id() = generate-id(key('studyEvents',@StudyEventOID)[1])]"
							mode="studyEventData1" />

						--><!-- End of Study Event Data -->
					</table>
				</div>
				<br />
				<!-- Main Table Starting -->
				<div class="tablebox_center" align="center">
					<table border="1" cellpadding="0" cellspacing="0">
						<tr valign="top">
							<td class="table_header_row">
								<xsl:text>Subject ID</xsl:text>
							</td>
							<xsl:if test="$uniqueIdExist">
								<td class="table_header_row">
									<xsl:text>Unique ID</xsl:text>
								</td>
							</xsl:if>
							<xsl:if test="$subjectStatusExist">
								<td class="table_header_row">
									<xsl:text>Subject Status</xsl:text>
								</td>
							</xsl:if>
							<xsl:if test="$sexExist">
								<td class="table_header_row">
									<xsl:text>Sex</xsl:text>
								</td>
							</xsl:if>
							<xsl:if test="$dobExist">
								<td class="table_header_row">
									<xsl:text>Date of Birth</xsl:text>
								</td>
							</xsl:if>
							<!--Starting Study Event Column Headers -->
							<!-- place holder 2 --><!--
							<xsl:apply-templates
								select="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData[generate-id() = generate-id(key('studyEvents',@StudyEventOID)[1])]"
								mode="studyeventData2" />
								
							--><!-- Selecting Event CRF column headers -->
										<xsl:apply-templates
			select="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData"
			mode="studyEventInfo" />
							
								<xsl:apply-templates
			select="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData"
			mode="studyEventHeader" />
							
							<!-- place holder 3 -->


							<!-- Item Headers -->
							<!-- placeholder 4 --><!-- <xsl:apply-templates select="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData[generate-id() 
								= generate-id(key('eventCRFs',@FormOID)[1])]" mode="itemHeader4" /> -->
						</tr>
						<!-- ====================================================================================================================== -->
						<!-- Place holder 5 -->
			<xsl:apply-templates select="/odm:ODM/odm:ClinicalData/odm:SubjectData"
			mode="allSubjectData" />

					</table>
				</div>
				<!-- ====================================================================================================================== -->
				<!-- For the MetaData PopUp -->
				<br />

				<!-- place holder 6 -->
				<xsl:apply-templates select="/odm:ODM/odm:ClinicalData"  mode="clinicalMetadata">
			
				</xsl:apply-templates>
				

            
				<!-- Clinical For Each -->
				<!-- End For the MetaData PopUp -->
			</body>
		</html>
	</xsl:template>
	
		<xsl:template match="/odm:ODM/odm:ClinicalData/odm:SubjectData"
		mode="allSubjectData">
	<tr valign="top">
			<td class="table_cell_left">
				<xsl:value-of select="@OpenClinica:StudySubjectID"></xsl:value-of>
			</td>
			<xsl:if test="$uniqueIdExist">
				<td class="table_cell">
					<xsl:choose>
						<xsl:when test="@OpenClinica:UniqueIdentifier">
							<xsl:value-of select="@OpenClinica:UniqueIdentifier"></xsl:value-of>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="$subjectStatusExist">
				<td class="table_cell">
					<xsl:choose>
						<xsl:when test="@OpenClinica:Status">
							<xsl:value-of select="@OpenClinica:Status"></xsl:value-of>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="$sexExist">
				<td class="table_cell">
					<xsl:choose>
						<xsl:when test="@OpenClinica:Sex">
							<xsl:value-of select="@OpenClinica:Sex"></xsl:value-of>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="$dobExist">
				<td class="table_cell">
					<xsl:choose>
						<xsl:when test="@OpenClinica:DateOfBirth">
							<xsl:value-of select="@OpenClinica:DateOfBirth"></xsl:value-of>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
	<xsl:apply-templates mode="studyEventInfoData" select="odm:StudyEventData"/>
								
		<xsl:variable name="subjectEvents" select="./odm:StudyEventData" />
		<!-- <xsl:apply-templates mode="studyEventsData" select="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData[generate-id() 
			= generate-id(key('studyEvents',@StudyEventOID)[1])]"> <xsl:with-param name="subjectEvents" 
			select="$subjectEvents"></xsl:with-param> </xsl:apply-templates> -->
		<xsl:variable name="subjectItems"
			select="./odm:StudyEventData/odm:FormData/odm:ItemGroupData/odm:ItemData" />
		<xsl:apply-templates
			select="odm:StudyEventData/odm:FormData"
			mode="eventCRFData">
			<xsl:with-param name="subjectForms"
				select="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData"/>
			<xsl:with-param name="subjectEvents" select="$subjectEvents"/>
			<xsl:with-param name="subjectItems" select="$subjectItems"/>
		</xsl:apply-templates>
		</tr>
		
	</xsl:template>
	
		<xsl:template mode="eventCRFData"
		match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData[@FormOID]">
		<xsl:param name="subjectEvents" />
		<xsl:param name="subjectForms"/>
		<xsl:param name="subjectItems"/>
		<xsl:variable name="currentForm" select="current()" />
		<xsl:variable name="subjectFormData"
			select="$subjectForms[@FormOID=$currentForm/@FormOID]" />
		<xsl:variable name="subjectEvent" select="$subjectFormData/.." />
		<xsl:variable name="parentEvent" select=".." />
		<xsl:apply-templates mode="allEventCrfData"
			select="//odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData[generate-id() = generate-id(key('studyEvents',@StudyEventOID)[1])]">
			<xsl:with-param name="subjectForms" select="$subjectForms"/>
			<xsl:with-param name="currentForm" select="$currentForm"/>
			<xsl:with-param name="subjectEvent" select="$subjectEvent"/>
			<xsl:with-param name="parentEvent" select="$parentEvent"/>
			<xsl:with-param name="subjectFormData" select="$subjectFormData"/>
		</xsl:apply-templates>


		<xsl:apply-templates mode="allItemData"
			select="odm:ItemGroupData/odm:ItemData">
			<xsl:with-param name="currentFormOID" select="@FormOID"/>
			<xsl:with-param name="subjectItems" select="$subjectItems"/>
		</xsl:apply-templates>
	</xsl:template>

	
<xsl:template mode="allEventCrfData"
		match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData">
		<xsl:param name="subjectForms"/>
		<xsl:param name="currentForm"/>
		<xsl:param name="subjectEvent"/>
		<xsl:param name="parentEvent"/>
		<xsl:param name="subjectFormData"/>


		<xsl:variable name="eventLocationExist" select="@OpenClinica:StudyEventLocation" />
		<xsl:variable name="eventStartDateExist" select="@OpenClinica:StartDate" />

		<xsl:variable name="eventStatusExist" select="@OpenClinica:Status" />
		<xsl:variable name="ageExist" select="@OpenClinica:SubjectAgeAtEvent" />
		<xsl:variable name="eventEndDateExist" select="@OpenClinica:EndDate" />
		<xsl:variable name="crfVersionExist" select="odm:FormData/@OpenClinica:Version" />
		<xsl:variable name="interviewerNameExist"
			select="odm:FormData/@OpenClinica:InterviewerName" />
		<xsl:variable name="interviewDateExist"
			select="odm:FormData/@OpenClinica:InterviewDate" />
		<xsl:variable name="crfStatusExist" select="odm:FormData/@OpenClinica:Status" />
	
		<xsl:if test="@StudyEventOID = $parentEvent/@StudyEventOID">

			<xsl:choose>
				<xsl:when test="@StudyEventRepeatKey">
					<xsl:variable name="allStudyEvents">
						<xsl:for-each select="//odm:StudyEventData[@StudyEventOID]">
							<xsl:sort select="@StudyEventRepeatKey" data-type="number" />
							<xsl:copy-of select="." />
						</xsl:for-each>
					</xsl:variable>
						
					<xsl:for-each select="exsl:node-set($allStudyEvents)/odm:StudyEventData">
						<xsl:choose>
							<xsl:when test="position()=1">

								<!-- Subjects event Data --><!--

								<xsl:choose>
									<xsl:when test="$subjectEvent/node()">
										<xsl:if test="$eventLocationExist">
											<xsl:value-of select="@OpenClinica:StudyEventLocation"></xsl:value-of>
											<xsl:value-of select="$delimiter" />
										</xsl:if>

										<xsl:if test="$eventStartDateExist">
											<xsl:value-of select="@OpenClinica:StartDate"></xsl:value-of>
											<xsl:value-of select="$delimiter" />
										</xsl:if>

										<xsl:if test="$eventEndDateExist">
											<xsl:value-of select="@OpenClinica:EndDate"></xsl:value-of>
											<xsl:value-of select="$delimiter" />

										</xsl:if>
										<xsl:if test="$eventStatusExist">
											<xsl:value-of select="@OpenClinica:Status"></xsl:value-of>
											<xsl:value-of select="$delimiter" />
										</xsl:if>
										<xsl:if test="$ageExist">
											<xsl:value-of select="@OpenClinica:SubjectAgeAtEvent"></xsl:value-of>
											<xsl:value-of select="$delimiter" />
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="$eventLocationExist">
											<xsl:value-of select="$delimiter" />
										</xsl:if>
										<xsl:if test="$eventStartDateExist">
											<xsl:value-of select="$delimiter" />
										</xsl:if>
										<xsl:if test="$eventEndDateExist">
											<xsl:value-of select="$delimiter" />
										</xsl:if>
										<xsl:if test="$eventStatusExist">
											<xsl:value-of select="$delimiter" />
										</xsl:if>
										<xsl:if test="$ageExist">
											<xsl:value-of select="$delimiter" />
										</xsl:if>
									</xsl:otherwise>

								</xsl:choose>



								--><xsl:choose>

									<xsl:when
										test="$subjectFormData/node()
                                                    and $subjectEvent/@StudyEventOID=@StudyEventOID
                                                    and $subjectEvent/@StudyEventRepeatKey=@StudyEventRepeatKey">
										<xsl:if test="$interviewerNameExist">
										<td class="table_cell">
											<xsl:value-of select="$currentForm/@OpenClinica:InterviewerName"/>
										</td>
										</xsl:if>
										<xsl:if test="$interviewDateExist">
										<td class="table_cell">
											<xsl:value-of select="$currentForm/@OpenClinica:InterviewDate"/>
										</td>
										</xsl:if>
										<xsl:if test="$crfStatusExist">
										<td class="table_cell">
											<xsl:value-of select="$currentForm/@OpenClinica:Status"/>
										</td>
										</xsl:if>
										<xsl:if test="$crfVersionExist">
										<td class="table_cell">
											<xsl:value-of select="$currentForm/@OpenClinica:Version"/>
										</td>
										</xsl:if>

									</xsl:when>
									<xsl:otherwise>
									<xsl:if test="$eventLocationExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									<xsl:if test="$eventStartDateExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									<xsl:if test="$eventEndDateExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									<xsl:if test="$eventStatusExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									<xsl:if test="$ageExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if
									test="preceding-sibling::odm:StudyEventData[1]/@StudyEventRepeatKey != @StudyEventRepeatKey">
								<xsl:choose>
										<xsl:when
											test="$subjectFormData/node()
                                                        and $subjectEvent/@StudyEventOID=@StudyEventOID
                                                        and $subjectEvent/@StudyEventRepeatKey=@StudyEventRepeatKey">
										<xsl:if test="$interviewerNameExist">
										<td class="table_cell">
											<xsl:value-of select="$currentForm/@OpenClinica:InterviewerName"/>
										</td>
										</xsl:if>
										<xsl:if test="$interviewDateExist">
										<td class="table_cell">
											<xsl:value-of select="$currentForm/@OpenClinica:InterviewDate"/>
										</td>
										</xsl:if>
										<xsl:if test="$crfStatusExist">
										<td class="table_cell">
											<xsl:value-of select="$currentForm/@OpenClinica:Status"/>
										</td>
										</xsl:if>
										<xsl:if test="$crfVersionExist">
										<td class="table_cell">
											<xsl:value-of select="$currentForm/@OpenClinica:Version"/>
										</td>
										</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="$eventLocationExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									<xsl:if test="$eventStartDateExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									<xsl:if test="$eventEndDateExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									<xsl:if test="$eventStatusExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									<xsl:if test="$ageExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$subjectFormData/node()"><!--
							<xsl:if test="$eventLocationExist">
								<xsl:value-of select="@OpenClinica:StudyEventLocation"></xsl:value-of>
								<xsl:value-of select="$delimiter" />
							</xsl:if>

							<xsl:if test="$eventStartDateExist">
								<xsl:value-of select="@OpenClinica:StartDate"></xsl:value-of>
								<xsl:value-of select="$delimiter" />
							</xsl:if>

							<xsl:if test="$eventEndDateExist">
								<xsl:value-of select="@OpenClinica:EndDate"></xsl:value-of>
								<xsl:value-of select="$delimiter" />

							</xsl:if>
							<xsl:if test="$eventStatusExist">
								<xsl:value-of select="@OpenClinica:Status"></xsl:value-of>
								<xsl:value-of select="$delimiter" />
							</xsl:if>
							<xsl:if test="$ageExist">
								<xsl:value-of select="@OpenClinica:SubjectAgeAtEvent"></xsl:value-of>
								<xsl:value-of select="$delimiter" />
							</xsl:if>
							--><xsl:if test="$interviewerNameExist">
										<td class="table_cell">
											<xsl:value-of select="$currentForm/@OpenClinica:InterviewerName"/>
										</td>
										</xsl:if>
										<xsl:if test="$interviewDateExist">
										<td class="table_cell">
											<xsl:value-of select="$currentForm/@OpenClinica:InterviewDate"/>
										</td>
										</xsl:if>
										<xsl:if test="$crfStatusExist">
										<td class="table_cell">
											<xsl:value-of select="$currentForm/@OpenClinica:Status"/>
										</td>
										</xsl:if>
										<xsl:if test="$crfVersionExist">
										<td class="table_cell">
											<xsl:value-of select="$currentForm/@OpenClinica:Version"/>
										</td>
										</xsl:if>
						</xsl:when>
						<xsl:otherwise><!--
							<xsl:if test="$eventLocationExist">
								<xsl:value-of select="$delimiter" />
							</xsl:if>
							<xsl:if test="$eventStartDateExist">
								<xsl:value-of select="$delimiter" />
							</xsl:if>
							<xsl:if test="$eventEndDateExist">
								<xsl:value-of select="$delimiter" />
							</xsl:if>
							<xsl:if test="$eventStatusExist">
								<xsl:value-of select="$delimiter" />
							</xsl:if>
							<xsl:if test="$ageExist">
								<xsl:value-of select="$delimiter" />
							</xsl:if>
							--><xsl:if test="$eventLocationExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									<xsl:if test="$eventStartDateExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									<xsl:if test="$eventEndDateExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									<xsl:if test="$eventStatusExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
									<xsl:if test="$ageExist">
										<td class="table_cell">
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
									</xsl:if>
						</xsl:otherwise>

					</xsl:choose>

				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>
	</xsl:template>

	<xsl:template mode="allItemData"
		match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData/odm:ItemGroupData/odm:ItemData">
		<xsl:param name="subjectItems" />
		<xsl:param name="currentFormOID" />
		<xsl:variable name="itemData" select="current()" />
		<xsl:variable name="itemFormOID" select="$itemData/../../@FormOID" />
		<xsl:variable name="itemOID" select="@ItemOID" />
		<xsl:variable name="eventRepeatKey"
			select="$itemData/../../../@StudyEventRepeatKey" />
		<xsl:variable name="subjectItemRepeating"
			select="$subjectItems[@ItemOID = $itemOID
                                                                            and $itemFormOID =../../@FormOID
                                                                            and $eventRepeatKey=../../../@StudyEventRepeatKey]" />
		<xsl:variable name="subjectItemSingle"
			select="$subjectItems[@ItemOID = $itemOID and $itemFormOID =../../@FormOID]" />
		<xsl:apply-templates mode="printItemData"
			select="//odm:ODM/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$itemOID]">
			<xsl:with-param name="itemData" select="$itemData"/>
			<xsl:with-param name="itemFormOID" select="$itemFormOID" />
			<xsl:with-param name="itemOID" select="$itemOID" />
			<xsl:with-param name="eventRepeatKey" select="$eventRepeatKey" />
			<xsl:with-param name="subjectItemRepeating" select="$subjectItemRepeating" />
			<xsl:with-param name="subjectItemSingle" select="$subjectItemSingle" />
			<xsl:with-param name="currentFormOID" select="$currentFormOID" />
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="//odm:ODM/odm:Study/odm:MetaDataVersion/odm:ItemDef"
		mode="printItemData">

		<xsl:param name="itemData"/>
		<xsl:param name="itemFormOID" />
		<xsl:param name="itemOID" />
		<xsl:param name="eventRepeatKey" />
		<xsl:param name="subjectItemRepeating" />
		<xsl:param name="subjectItemSingle" />
		<xsl:param name="currentFormOID" />
		<xsl:variable name="formOID"
			select="OpenClinica:ItemDetails/OpenClinica:ItemPresentInForm[@FormOID = $itemFormOID]/@FormOID" />
		<xsl:if test="$currentFormOID = $formOID">
			<xsl:choose>
				<xsl:when test="$eventRepeatKey">
					<xsl:choose>
						<xsl:when test="count($subjectItemRepeating) &gt; 0">
						
												<td class="table_cell">
												<xsl:value-of select="$itemData/@Value" />
											</td>
						
						</xsl:when>
						<xsl:otherwise>
							<td class="table_cell">
												<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											</td>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="count($subjectItemSingle) &gt; 0">
							<td class="table_cell">
							<xsl:value-of select="$itemData/@Value" />
						</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="table_cell">
							<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	

	
	
	
	<xsl:template mode="studyEventInfoData" match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData">
	<xsl:variable name="eventLocationExist" select="@OpenClinica:StudyEventLocation" />
		<xsl:variable name="eventStartDateExist" select="@OpenClinica:StartDate" />

		<xsl:variable name="eventStatusExist" select="@OpenClinica:Status" />
		<xsl:variable name="ageExist" select="@OpenClinica:SubjectAgeAtEvent" />
		<xsl:variable name="eventEndDateExist" select="@OpenClinica:EndDate" />
	
									<xsl:if test="$eventLocationExist">
										<td class="table_cell">
										
												
													<xsl:value-of
														select="@OpenClinica:StudyEventLocation"></xsl:value-of>
												
												
										</td>
									</xsl:if>
									<xsl:if test="$eventStartDateExist">
										<td class="table_cell">
													<xsl:value-of select="@OpenClinica:StartDate"></xsl:value-of>
												
										</td>
									</xsl:if>
									<xsl:if test="$eventEndDateExist">
										<td class="table_cell">
													<xsl:value-of select="@OpenClinica:EndDate"></xsl:value-of>
										</td>
									</xsl:if>
									<xsl:if test="$eventStatusExist">
										<td class="table_cell">
													<xsl:value-of select="@OpenClinica:Status"></xsl:value-of>
										</td>
									</xsl:if>
									<xsl:if test="$ageExist">
										<td class="table_cell">
													<xsl:value-of
														select="@OpenClinica:SubjectAgeAtEvent"></xsl:value-of>
										</td>
									</xsl:if>
	</xsl:template>
	<xsl:template match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData" mode="studyEventInfo">
		<xsl:variable name="eventPosition">
		<xsl:for-each select="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData[generate-id() 	= generate-id(key('studyEvents',@StudyEventOID)[1])]">
		<xsl:copy-of select="position()" />
		</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="crfStatusExist" select="odm:FormData/@OpenClinica:Status" />
		<xsl:variable name="eventLocationExist" select="@OpenClinica:StudyEventLocation" />
		<xsl:variable name="eventStartDateExist" select="@OpenClinica:StartDate" />

		<xsl:variable name="eventStatusExist" select="@OpenClinica:Status" />
		<xsl:variable name="ageExist" select="@OpenClinica:SubjectAgeAtEvent" />
		<xsl:variable name="eventEndDateExist" select="@OpenClinica:EndDate" />
				<xsl:if test="$eventLocationExist">
					<td class="table_header_row">
									<xsl:text>Location_</xsl:text>
									<xsl:value-of select="$E" />
									<xsl:value-of select="$eventPosition" />
								<xsl:if test="@StudyEventRepeatKey">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@StudyEventRepeatKey" />
										</xsl:if>
										<xsl:text>_</xsl:text>
									</td>
								</xsl:if>

								<xsl:if test="$eventStartDateExist">
									<td class="table_header_row">
									<xsl:text>StartDate_</xsl:text>
									<xsl:value-of select="$E" />
									<xsl:value-of select="$eventPosition" />
								<xsl:if test="@StudyEventRepeatKey">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@StudyEventRepeatKey" />
										</xsl:if>
										<xsl:text>_</xsl:text>
									</td>
								</xsl:if>

								<xsl:if test="$eventEndDateExist">
									<td class="table_header_row">
									<xsl:text>EndDate_</xsl:text>
									<xsl:value-of select="$E" />
									<xsl:value-of select="$eventPosition" />
								<xsl:if test="@StudyEventRepeatKey">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@StudyEventRepeatKey" />
										</xsl:if>
										<xsl:text>_</xsl:text>
	</td>
								</xsl:if>

								<xsl:if test="$eventStatusExist">
									<td class="table_header_row">
									<xsl:text>Event Status_</xsl:text>
									<xsl:value-of select="$E" />
									<xsl:value-of select="$eventPosition" />
									<xsl:if test="@StudyEventRepeatKey">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@StudyEventRepeatKey" />
										</xsl:if>
										<xsl:text>_</xsl:text>
	</td>
								</xsl:if>

								<xsl:if test="$ageExist">
									<td class="table_header_row">
									<xsl:text>Age_</xsl:text>
									<xsl:value-of select="$E" />
									<xsl:value-of select="$eventPosition" />
								<xsl:if test="@StudyEventRepeatKey">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@StudyEventRepeatKey" />
										</xsl:if>
										<xsl:text>_</xsl:text>
							</td>
								</xsl:if>
	</xsl:template>
	<xsl:template match="/odm:ODM/odm:ClinicalData" mode="clinicalMetadata">
	<xsl:apply-templates select="odm:SubjectData" mode="SubjectMetaData"/>
	</xsl:template>
	<xsl:template match="/odm:ODM/odm:ClinicalData/odm:SubjectData" mode="SubjectMetaData">
	<xsl:apply-templates select="odm:StudyEventData" mode="studyEventMetadata"/>
	</xsl:template>
	<xsl:template match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData" mode="studyEventMetadata">
	<xsl:apply-templates select="odm:FormData" mode="FormMetaData"/>
	</xsl:template>
	<xsl:template match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData" mode="FormMetaData">
	<xsl:apply-templates select="odm:ItemGroupData" mode="itemGroupMetadata"/>
	</xsl:template>
	<xsl:template match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData/odm:ItemGroupData" mode="itemGroupMetadata">
	<xsl:apply-templates select="odm:ItemData" mode="itemDataMetadata"/>
	</xsl:template>
	<xsl:template match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData/odm:ItemGroupData/odm:ItemData" mode="itemDataMetadata">
	   
	   <xsl:variable name="OID_Item" select="@ItemOID"/>
                                        <xsl:for-each select="$itemDef[@OID=$OID_Item]">
                                            <xsl:variable name="codeListOID" select="./odm:CodeListRef/@CodeListOID"/>
                                            <xsl:variable name="phi"
                                                          select="./OpenClinica:ItemDetails/OpenClinica:ItemPresentInForm/@PHI"/>
                                            <xsl:variable name="crfOID" select="@OpenClinica:FormOIDs"/>
                                            <div style="display:none;">
                                                <xsl:attribute name="id">
                                                    <xsl:apply-templates select="@OID"/>
                                                </xsl:attribute>
                                                <h1>
                                                    <span class="title_manage">Item Metadata: Global Attributes</span>
                                                </h1>
                                                <table border="1" cellpadding="0" cellspacing="0">
                                                    <tr valign="top">
                                                        <td class="table_header_column_top">CRF Name:</td>
                                                        <td class="table_cell_top">
                                                            <xsl:for-each select="$crfDetails[@OID=$crfOID]">
                                                                <xsl:value-of select="@Name"/>
                                                            </xsl:for-each>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="table_header_column">Item Name:</td>
                                                        <td class="table_cell">
                                                            <xsl:value-of select="@Name"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="table_header_column">OID:</td>
                                                        <td class="table_cell">
                                                            <xsl:value-of select="@OID"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="table_header_column">Description:</td>
                                                        <td class="table_cell">
                                                            <xsl:value-of select="@Comment"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="table_header_column">Data Type:</td>
                                                        <td class="table_cell">
                                                            <xsl:value-of select="@DataType"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="table_header_column">PHI:</td>
                                                        <td class="table_cell">
                                                            <xsl:value-of select="$phi"/>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <br/>
                                                <span class="table_title_Manage">Item Metadata: CRF Version Level
                                                    Attributes
                                                </span>
                                                <br/>
                                                <xsl:for-each
                                                        select="./OpenClinica:ItemDetails/OpenClinica:ItemPresentInForm">
                                                    <xsl:variable name="formOID" select="@FormOID"/>
                                                    <xsl:for-each select="$crfDetails[@OID=$formOID]">
                                                        <br/>
                                                        <span class="expandFormLink">
                                                            <a>
                                                                <xsl:attribute name="href">#</xsl:attribute>
                                                                <xsl:attribute name="onclick">
                                                                    showDiv('<xsl:value-of select="$formOID"/>');return
                                                                    false;
                                                                </xsl:attribute>
                                                                <xsl:value-of select="@Name"/>
                                                            </a>
                                                        </span>
                                                    </xsl:for-each>
                                                    <div class="tablebox_center" align="center" style="display:block;">
                                                        <xsl:attribute name="id">
                                                            <xsl:value-of select="@FormOID"/>
                                                        </xsl:attribute>
                                                        <script language="javascript">
                                                            function showDiv(n) {
                                                            s = document.getElementById(n);
                                                            if (s.style.display == "block") {
                                                            s.style.display = "none";
                                                            } else {
                                                            s.style.display = "block";
                                                            }
                                                            }
                                                        </script>
                                                        <table border="1" cellpadding="0" cellspacing="0">
                                                            <tr valign="top">
                                                                <td class="table_header_row">
                                                                    <xsl:text>Left Item Text</xsl:text>
                                                                </td>
                                                                <td class="table_header_row">
                                                                    <xsl:text>Right Item Text</xsl:text>
                                                                </td>
                                                                <td class="table_header_row">
                                                                    <xsl:text>Default Value</xsl:text>
                                                                </td>
                                                                <td class="table_header_row">
                                                                    <xsl:text>Response Layout</xsl:text>
                                                                </td>
                                                                <td class="table_header_row">
                                                                    <xsl:text>Response Type</xsl:text>
                                                                </td>
                                                                <td class="table_header_row">
                                                                    <xsl:text>Response Label</xsl:text>
                                                                </td>
                                                                <td class="table_header_row">
                                                                    <xsl:text>Response Options/Response Values</xsl:text>
                                                                </td>
                                                                <td class="table_header_row">
                                                                    <xsl:text>Section Label</xsl:text>
                                                                </td>
                                                                <td class="table_header_row">
                                                                    <xsl:text>Group Name</xsl:text>
                                                                </td>
                                                                <td class="table_header_row">
                                                                    <xsl:text>Validation</xsl:text>
                                                                </td>
                                                                <td class="table_header_row">
                                                                    <xsl:text>Validation Error Message</xsl:text>
                                                                </td>
                                                                <td class="table_header_row">
                                                                    <xsl:text>Required</xsl:text>
                                                                </td>
                                                            </tr>
                                                            <tr valign="top">
                                                                <td class="table_cell_left">
                                                                    <xsl:value-of select="./OpenClinica:LeftItemText"/>
                                                                </td>
                                                                <td class="table_cell">
                                                                    <xsl:value-of select="./OpenClinica:RightItemTextText"/>
                                                                </td>
                                                                <td class="table_cell">
                                                                    <xsl:value-of select="@DefaultValue"/>
                                                                </td>
                                                                <td class="table_cell">
                                                                    <xsl:value-of
                                                                            select="./OpenClinica:ItemResponse/@ResponseLayout"/>
                                                                </td>
                                                                <td class="table_cell">
                                                                    <xsl:value-of
                                                                            select="./OpenClinica:ItemResponse/@ResponseType"/>
                                                                </td>
                                                                <td class="table_cell">
                                                                    <xsl:value-of
                                                                            select="./OpenClinica:ItemResponse/@ResponseLabel"/>
                                                                </td>
                                                                <td class="table_cell">
                                                                    <xsl:for-each select="$codeList[@OID=$codeListOID]">
                                                                        <xsl:for-each select="./odm:CodeListItem">
                                                                            <xsl:value-of
                                                                                    select="./odm:Decode/odm:TranslatedText"/>
                                                                            |
                                                                            <xsl:value-of select="@CodedValue"/>
                                                                            <br/>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </td>

                                                                <td class="table_cell">
                                                                    <xsl:value-of select="./OpenClinica:SectionLabel"/>
                                                                </td>
                                                                <xsl:for-each
                                                                        select="$groupDetails/odm:ItemRef[@ItemOID=$OID_Item]">
                                                                    <td class="table_cell">
                                                                        <xsl:value-of select="../@Name"/>
                                                                    </td>
                                                                </xsl:for-each>
                                                                <td class="table_cell">
                                                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                                                </td>
                                                                <td class="table_cell">
                                                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                                                </td>
                                                                <xsl:for-each
                                                                        select="$groupDetails/odm:ItemRef[@ItemOID=$OID_Item]">
                                                                    <td class="table_cell">
                                                                        <xsl:value-of select="@Mandatory"/>
                                                                    </td>
                                                                </xsl:for-each>
                                                            </tr>

                                                        </table>
                                                    </div>
                                                </xsl:for-each>
                                                
                                                   <style type="text/css">
                                                    .expandFormLink {
                                                    font-family: Tahoma, Arial, Helvetica, Sans-Serif;
                                                    font-size: 11px;
                                                    line-height: 15px;
                                                    color: #4D4D4D;font-weight: bold;
                                                    }
                                                    H1 { font-family: Tahoma, Arial, Helvetica, sans-serif;
                                                    font-size: 18px;
                                                    line-height: 24px;
                                                    font-weight: bold;
                                                    color: #789EC5;
                                                    }

                                                    td { font-family: Tahoma, Arial, Helvetica, Sans-Serif;
                                                    font-size: 11px;
                                                    line-height: 15px;
                                                    color: #4D4D4D;
                                                    }

                                                    a:link, a:visited { color: #789EC5;
                                                    text-decoration: none;
                                                    }


                                                    a:hover, a:active { color: #789EC5;
                                                    text-decoration: underline;
                                                    }


                                                    .tablebox_center { padding-left: 1px;
                                                    padding-right: 6px;
                                                    padding-top: 1px;
                                                    padding-bottom: 7px;
                                                    }

                                                    .table_title_Manage { font-family: Tahoma, Arial, Helvetica,
                                                    sans-serif;
                                                    font-size: 14px;
                                                    line-height: 18px;
                                                    font-weight: bold;
                                                    color: #D4A718;
                                                    padding-bottom: 6px;
                                                    }

                                                    .table_header_row { padding-top: 3px;
                                                    padding-left: 2px;
                                                    padding-right: 1px;
                                                    padding-bottom: 3px;
                                                    border-style: solid;
                                                    border-top-width: 0px;
                                                    border-left-width: 1px;
                                                    border-right-width: 0px;
                                                    border-bottom-width: 1px;
                                                    border-left-color: #CCCCCC;
                                                    border-bottom-color: #CCCCCC;
                                                    font-weight: bold;
                                                    color: #666666;
                                                    vertical-align: top;
                                                    }
                                                    .table_header_column { padding-top: 3px;
                                                    padding-left: 6px;
                                                    padding-right: 6px;
                                                    padding-bottom: 3px;
                                                    border-style: solid;
                                                    border-top-width: 1px;
                                                    border-left-width: 0px;
                                                    border-right-width: 1px;
                                                    border-bottom-width: 0px;
                                                    border-right-color: #CCCCCC;
                                                    border-top-color: #CCCCCC;
                                                    font-weight: bold;
                                                    color: #666666;
                                                    vertical-align: top;
                                                    }

                                                    .table_header_column_top { padding-top: 3px;
                                                    padding-left: 6px;
                                                    padding-right: 6px;
                                                    padding-bottom: 3px;
                                                    border-style: solid;
                                                    border-top-width: 0px;
                                                    border-left-width: 0px;
                                                    border-right-width: 1px;
                                                    border-bottom-width: 0px;
                                                    border-right-color: #CCCCCC;
                                                    font-weight: bold;
                                                    color: #666666;
                                                    vertical-align: top;
                                                    }

                                                    .table_cell {
                                                    padding: 0.2em;
                                                    border-style: solid;
                                                    border-top-width: 1px;
                                                    border-left-width: 1px;
                                                    border-right-width: 0;
                                                    border-bottom-width: 0;
                                                    border-left-color: #CCCCCC;
                                                    border-top-color: #E6E6E6;
                                                    vertical-align: top;
                                                    }


                                                    .table_cell_left {
                                                    padding: 0.2em;
                                                    border-style: solid;
                                                    border-top-width: 1px;
                                                    border-left-width: 0px;
                                                    border-right-width: 0px;
                                                    border-bottom-width: 0px;
                                                    border-top-color: #E6E6E6;
                                                    vertical-align: top;
                                                    }

                                                    .table_cell_top {
                                                    padding: 0.2em;
                                                    border-style: solid;
                                                    border-top-width: 0px;
                                                    border-left-width: 1px;
                                                    border-right-width: 0px;
                                                    border-bottom-width: 0px;
                                                    border-left-color: #CCCCCC;
                                                    vertical-align: top;
                                                    }
                                                </style>
                                            </div>
                                            </xsl:for-each>
	</xsl:template>
	<xsl:template name="FormatDate">
		<xsl:param name="DateTime" />
		<xsl:variable name="month">
			<xsl:value-of select="substring($DateTime, 6, 2)" />
		</xsl:variable>

		<xsl:variable name="days">
			<xsl:value-of select="substring($DateTime, 9, 2)" />
		</xsl:variable>

		<xsl:variable name="year_of_date">
			<xsl:value-of select="substring($DateTime, 1, 4)" />
		</xsl:variable>

		<xsl:value-of select="$year_of_date" />
		<xsl:value-of select="'-'" />
		<xsl:choose>
			<xsl:when test="$month = '01'">
				Jan
			</xsl:when>
			<xsl:when test="$month = '02'">
				Feb
			</xsl:when>
			<xsl:when test="$month = '03'">
				Mar
			</xsl:when>
			<xsl:when test="$month = '04'">
				Apr
			</xsl:when>
			<xsl:when test="$month = '05'">
				May
			</xsl:when>
			<xsl:when test="$month = '06'">
				Jun
			</xsl:when>
			<xsl:when test="$month = '07'">
				Jul
			</xsl:when>
			<xsl:when test="$month = '08'">
				Aug
			</xsl:when>
			<xsl:when test="$month = '09'">
				Sep
			</xsl:when>
			<xsl:when test="$month = '10'">
				Oct
			</xsl:when>
			<xsl:when test="$month = '11'">
				Nov
			</xsl:when>
			<xsl:when test="$month = '12'">
				Dec
			</xsl:when>
		</xsl:choose>

		<xsl:value-of select="'-'" />
		<xsl:if test="(string-length($days) &lt; 2)">
			<xsl:value-of select="0" />
		</xsl:if>

		<xsl:value-of select="$days" />
	</xsl:template>



<xsl:template match="//odm:ODM/odm:Study/odm:MetaDataVersion" mode="metadataDisplay">

<xsl:apply-templates select="odm:StudyEventDef" mode="studyEventDefinition"/>

<xsl:apply-templates select="odm:FormDef" mode="formDataTemplate"/>

</xsl:template><!--

	<xsl:template
		match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData"
		mode="studyEventData1">
		<xsl:variable name="eventPosition" select="position()" />
		<xsl:variable name="eventOID" select="@StudyEventOID" />
		<xsl:apply-templates
			select="//odm:ODM/odm:Study/odm:MetaDataVersion/odm:StudyEventDef[@OID=$eventOID]"
			mode="studyeventDef1">
			<xsl:with-param name="eventPosition" select="$eventPosition" />
			<xsl:with-param name="eventOID" select="$eventOID" />
		</xsl:apply-templates>
		<xsl:apply-templates
			select="//odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData[generate-id() = generate-id(key('eventCRFs',@FormOID)[1])]"
			mode="formData1">
			<xsl:with-param name="eventPosition" select="$eventPosition" />
			<xsl:with-param name="eventOID" select="$eventOID" />
		</xsl:apply-templates>
	</xsl:template>
	-->
	
		<xsl:template
		match="//odm:ODM/odm:Study/odm:MetaDataVersion/odm:StudyEventDef"
		mode="studyEventDefinition">
		<xsl:variable name="eventPosition" select="position()" />
		<xsl:variable name="OID" select="@OID" />
		<xsl:variable name="studyName" select="@Name" />
		<xsl:variable name="oid" select="$OID" />

		<xsl:variable name="isRepeating" select="@Repeating" />

		<xsl:apply-templates select="//odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData[generate-id() = generate-id(key('studyEvents',@StudyEventOID)[1])]" mode="studyEventDefList">
			<xsl:with-param name="oid" select="$oid"/>
				<xsl:with-param name="studyName" select="$studyName"/>
		</xsl:apply-templates>
		</xsl:template>
	<xsl:template	mode="studyEventDefList"		match="//odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData">
<xsl:param name="oid"/>
<xsl:param name="studyName"/>
			<xsl:variable name="studyEventOID" select="@StudyEventOID" />
			<xsl:if test="$oid=$studyEventOID">
			<tr>
			<td class="table_header_column">
				<xsl:text>Study Event Definition </xsl:text>
				<xsl:value-of select="position()" />
				<xsl:variable name="isRepeating" select="@Repeating" />
				<xsl:if test="$isRepeating='Yes'">
					<xsl:text>(Repeating)</xsl:text>
				</xsl:if>
			
				</td>
				
				<td class="table_cell">
				<xsl:value-of select="$studyName" />
				</td>
				<td class="table_cell">
	
				<xsl:value-of select="$E" />
				<!-- <xsl:value-of select="$eventPosition" />-->
					<xsl:value-of select="position()" />
<!--				<xsl:value-of select="$eol"></xsl:value-of>-->
			</td>
			</tr>
			</xsl:if>
		</xsl:template>




<xsl:template priority="1" mode="formDataTemplate"
		match="//odm:ODM/odm:Study/odm:MetaDataVersion/odm:FormDef">

		<xsl:variable name="FormOID" select="@OID" />
		<xsl:variable name="formName" select="@Name" />
		
		<xsl:variable name="crfPosition" select="position()"/>


		<xsl:apply-templates
			select="//odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData[generate-id() = generate-id(key('eventCRFs',$FormOID)[1])]"
			mode="CrfInfo">
			<xsl:with-param name="oid" select="$FormOID" />
			<xsl:with-param name="formName" select="$formName" />
			<xsl:with-param name="crfPosition" select="$crfPosition"/>
		</xsl:apply-templates>
	</xsl:template>


	<xsl:template mode="CrfInfo"
		match="//odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData">
		<xsl:param name="oid"/>
		<xsl:param name="formName"/>
		<xsl:param name="crfPosition"/>
		<xsl:variable name="formOid" select="@FormOID" />

		<xsl:if test="$oid=@FormOID">
		<tr><td class="table_header_column">
			<xsl:text>CRF</xsl:text>
			<xsl:value-of select="count(preceding-sibling::*) + 1" />
</td><td class="table_cell">
			<xsl:value-of select="$formName" />
			</td>
			<td class="table_cell">
			<xsl:value-of select="$C" />
			<xsl:value-of select="count(preceding-sibling::*) + 1" />
			</td>
		</tr>
</xsl:if>

	</xsl:template><!--


	<xsl:template
		match="//odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData[generate-id() = generate-id(key('eventCRFs',@FormOID)[1])]"
		mode="formData1">
		<xsl:param name="eventPosition" />
		<xsl:param name="eventOID" />
		<xsl:variable name="formOID" />
		<xsl:variable name="crfPosition" select="position()" />
		<xsl:if test="current()/parent::node()/@StudyEventOID=$eventOID">
			<tr>
				<td class="table_header_column">
					<xsl:text>CRF</xsl:text>
				</td>
				<td class="table_cell">
					<xsl:for-each select="//odm:FormDef[@OID=$formOID]">
						<xsl:value-of select="@Name" />
					</xsl:for-each>
				</td>
				<td class="table_cell">
					<xsl:value-of select="$C" />
					<xsl:value-of select="$crfPosition" />
				</td>
			</tr>
		</xsl:if>
	</xsl:template>




	--><xsl:template
		match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData[@StudyEventOID]"
		mode="studyEventHeader">
		<xsl:variable name="eventOID" select="@StudyEventOID" />
		<xsl:variable name="eventPosition">
		<xsl:for-each select="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData[generate-id() 	= generate-id(key('studyEvents',@StudyEventOID)[1])]">
		<xsl:copy-of select="position()" />
		</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="eventLocationExist" select="@OpenClinica:StudyEventLocation" />
		<xsl:variable name="eventStartDateExist" select="@OpenClinica:StartDate" />

		<xsl:variable name="eventStatusExist" select="@OpenClinica:Status" />
		<xsl:variable name="ageExist" select="@OpenClinica:SubjectAgeAtEvent" />
		<xsl:variable name="eventEndDateExist" select="@OpenClinica:EndDate" />
		<xsl:variable name="studyEventRepeatKey" select="@StudyEventRepeatKey"/>
		

		
		<xsl:apply-templates
			select="odm:FormData"
			mode="formDataHeader">
			<xsl:with-param name="eventPosition" select="$eventPosition" />
			<xsl:with-param name="studyEventRepeatKey" select="$studyEventRepeatKey"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template mode="formDataHeader"
		match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData[@FormOID]">
		<!-- <xsl:for-each select="//odm:FormData[generate-id() = generate-id(key('eventCRFs',@FormOID))]"> -->
		<xsl:param name="eventPosition"/>
		<xsl:param name="studyEventRepeatKey"/>
		<xsl:variable name="crfPosition" select="position()" />
		<xsl:variable name="parentEvent" select=".." />
		<xsl:variable name="currentFormOID" select="@FormOID" />
		
		
		<xsl:apply-templates mode="studyEventData"
			select="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData[generate-id() 	= generate-id(key('studyEvents',@StudyEventOID)[1])]">
			<xsl:with-param name="crfPosition" select="$crfPosition" />
			<xsl:with-param name="parentEvent" select="$parentEvent" />
			<xsl:with-param name="eventPosition" select="$eventPosition" />
			
		</xsl:apply-templates>
		
		<xsl:apply-templates select="odm:ItemGroupData/odm:ItemData"
			mode="itemDataColumnHeaders">
			<xsl:with-param name="crfPosition" select="$crfPosition" />
			<xsl:with-param name="currentFormOID" select="$currentFormOID" />
			<xsl:with-param name="eventPosition" select="$eventPosition"/>
			<xsl:with-param name="studyEventRepeatKey" select="$studyEventRepeatKey"/>
		</xsl:apply-templates>

		<!-- </xsl:for-each> -->
	<!-- event crf Header Data -->
	</xsl:template>

	<xsl:template mode="studyEventData"
		match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData">
		<xsl:param name="crfPosition"/>
		<xsl:param name="parentEvent"/>
		<xsl:param name="eventPosition"/>
		<xsl:variable name="eventOID" select="@StudyEventOID" />
		<!-- <xsl:variable name="eventPosition" select="position()" /> -->
		<xsl:variable name="crfVersionExist" select="odm:FormData/@OpenClinica:Version" />
		<xsl:variable name="interviewerNameExist"
			select="odm:FormData/@OpenClinica:InterviewerName" />
		<xsl:variable name="interviewDateExist"
			select="odm:FormData/@OpenClinica:InterviewDate" />
		<xsl:variable name="crfStatusExist" select="odm:FormData/@OpenClinica:Status" />
		<xsl:variable name="eventLocationExist" select="@OpenClinica:StudyEventLocation" />
		<xsl:variable name="eventStartDateExist" select="@OpenClinica:StartDate" />

		<xsl:variable name="eventStatusExist" select="@OpenClinica:Status" />
		<xsl:variable name="ageExist" select="@OpenClinica:SubjectAgeAtEvent" />
		<xsl:variable name="eventEndDateExist" select="@OpenClinica:EndDate" />


		<xsl:if test="@StudyEventOID = $parentEvent/@StudyEventOID">
			<xsl:choose>
				<xsl:when test="@StudyEventRepeatKey">
					<xsl:variable name="allStudyEvents">
						<xsl:for-each select="//odm:StudyEventData">
							<xsl:sort select="@StudyEventRepeatKey" data-type="number" />
							<xsl:copy-of select="." />
						</xsl:for-each>
					</xsl:variable>

					<xsl:for-each select="exsl:node-set($allStudyEvents)/odm:StudyEventData">
						<xsl:choose>
							<xsl:when test="position()=1">
					<xsl:if test="$interviewerNameExist">
								<td class="table_header_row">
									<xsl:text>Interviewer_</xsl:text>
									<xsl:value-of select="$E" />
									<xsl:value-of select="$eventPosition" />
									<xsl:if test="@StudyEventRepeatKey">
										<xsl:text>_</xsl:text>
										<xsl:value-of select="@StudyEventRepeatKey" />
									</xsl:if>
									<xsl:text>_</xsl:text>
									<xsl:value-of select="$C" />
									<xsl:value-of select="$crfPosition" />
						</td>
								</xsl:if>

								<xsl:if test="$interviewDateExist">
									<td class="table_header_row">
									<xsl:text>Interviewer date</xsl:text>
									<xsl:value-of select="$E" />
									<xsl:value-of select="$eventPosition" />
									<xsl:if test="@StudyEventRepeatKey">
										<xsl:text>_</xsl:text>
										<xsl:value-of select="@StudyEventRepeatKey" />
									</xsl:if>
									<xsl:text>_</xsl:text>
									<xsl:value-of select="$C" />
									<xsl:value-of select="$crfPosition" />
									</td>
								</xsl:if>

								<xsl:if test="$crfStatusExist">
									<td class="table_header_row">
									<xsl:text>CRF Version Status_</xsl:text>
									<xsl:value-of select="$E" />
									<xsl:value-of select="$eventPosition" />
									<xsl:text>_</xsl:text>
									<xsl:value-of select="@StudyEventRepeatKey" />
									<xsl:text>_</xsl:text>
									<xsl:value-of select="$C" />
									<xsl:value-of select="$crfPosition" />
									</td>
								</xsl:if>

								<xsl:if test="$crfVersionExist">
									<td class="table_header_row">
									<xsl:text>Version Name_</xsl:text>
									<xsl:value-of select="$E" />
									<xsl:value-of select="$eventPosition" />
									<xsl:text>_</xsl:text>
									<xsl:value-of select="@StudyEventRepeatKey" />
									<xsl:text>_</xsl:text>
									<xsl:value-of select="$C" />
									<xsl:value-of select="$crfPosition" />
									</td>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if
									test="preceding-sibling::odm:StudyEventData[1]/@StudyEventRepeatKey != @StudyEventRepeatKey"><!--
									<xsl:if test="$eventLocationExist">
										<xsl:text>Location_</xsl:text>
										<xsl:value-of select="$E" />
										<xsl:value-of select="$eventPosition" />
									<xsl:if test="@StudyEventRepeatKey">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@StudyEventRepeatKey" />
										</xsl:if>
										<xsl:text>_</xsl:text>
										<xsl:value-of select="$C" />
										<xsl:value-of select="$crfPosition" />
										<xsl:value-of select="$delimiter" />
									</xsl:if>

									<xsl:if test="$eventStartDateExist">
										<xsl:text>StartDate_</xsl:text>
										<xsl:value-of select="$E" />
										<xsl:value-of select="$eventPosition" />
										<xsl:if test="@StudyEventRepeatKey">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@StudyEventRepeatKey" />
										</xsl:if>
										<xsl:text>_</xsl:text>
										<xsl:value-of select="$C" />
										<xsl:value-of select="$crfPosition" />
										<xsl:value-of select="$delimiter" />
									</xsl:if>

									<xsl:if test="$eventEndDateExist">
										<xsl:text>EndDate_</xsl:text>
										<xsl:value-of select="$E" />
										<xsl:value-of select="$eventPosition" />
							<xsl:if test="@StudyEventRepeatKey">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@StudyEventRepeatKey" />
										</xsl:if>
										<xsl:text>_</xsl:text>
										<xsl:value-of select="$C" />
										<xsl:value-of select="$crfPosition" />
										<xsl:value-of select="$delimiter" />
									</xsl:if>

									<xsl:if test="$eventStatusExist">
										<xsl:text>Event Status_</xsl:text>
										<xsl:value-of select="$E" />
										<xsl:value-of select="$eventPosition" />
										<xsl:if test="@StudyEventRepeatKey">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@StudyEventRepeatKey" />
										</xsl:if>
										<xsl:text>_</xsl:text>
										<xsl:value-of select="$C" />
										<xsl:value-of select="$crfPosition" />
										<xsl:value-of select="$delimiter" />
									</xsl:if>

									<xsl:if test="$ageExist">
										<xsl:text>Age_</xsl:text>
										<xsl:value-of select="$E" />
										<xsl:value-of select="$eventPosition" />
										<xsl:if test="@StudyEventRepeatKey">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@StudyEventRepeatKey" />
										</xsl:if>
										<xsl:text>_</xsl:text>
										<xsl:value-of select="$C" />
										<xsl:value-of select="$crfPosition" />
										<xsl:value-of select="$delimiter" />
									</xsl:if>
									--><xsl:if test="$interviewerNameExist">
										<td class="table_header_row">
										<xsl:text>Interviewer_</xsl:text>
										<xsl:value-of select="$E" />
										<xsl:value-of select="$eventPosition" />
										<xsl:if test="@StudyEventRepeatKey">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@StudyEventRepeatKey" />
										</xsl:if>
										<xsl:text>_</xsl:text>
										<xsl:value-of select="$C" />
										<xsl:value-of select="$crfPosition" />
										</td>
									</xsl:if>

									<xsl:if test="$interviewDateExist">
										<td class="table_header_row">
										<xsl:text>Interviewer date</xsl:text>
										<xsl:value-of select="$E" />
										<xsl:value-of select="$eventPosition" />
										<xsl:if test="@StudyEventRepeatKey">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@StudyEventRepeatKey" />
										</xsl:if>
										<xsl:text>_</xsl:text>
										<xsl:value-of select="$C" />
										<xsl:value-of select="$crfPosition" />
										</td>
									</xsl:if>

									<xsl:if test="$crfStatusExist">
										<td class="table_header_row">
										<xsl:text>CRF Version Status_</xsl:text>
										<xsl:value-of select="$E" />
										<xsl:value-of select="$eventPosition" />
										<xsl:text>_</xsl:text>
										<xsl:value-of select="@StudyEventRepeatKey" />
										<xsl:text>_</xsl:text>
										<xsl:value-of select="$C" />
										<xsl:value-of select="$crfPosition" />
</td>										
									</xsl:if>

									<xsl:if test="$crfVersionExist">
										<td class="table_header_row">
										<xsl:text>Version Name_</xsl:text>
										<xsl:value-of select="$E" />
										<xsl:value-of select="$eventPosition" />
										<xsl:text>_</xsl:text>
										<xsl:value-of select="@StudyEventRepeatKey" />
										<xsl:text>_</xsl:text>
										<xsl:value-of select="$C" />
										<xsl:value-of select="$crfPosition" />
										</td>
									</xsl:if>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
				<xsl:if test="$interviewerNameExist">
						<td class="table_header_row">
						<xsl:text>Interviewer_</xsl:text>
						<xsl:value-of select="$E" />
						<xsl:value-of select="$eventPosition" />
						<xsl:text>_</xsl:text>
						<xsl:value-of select="$C" />
						<xsl:value-of select="$crfPosition" />
		</td>
					</xsl:if>

					<xsl:if test="$interviewDateExist">
						<td class="table_header_row">
						<xsl:text>Interviewer date</xsl:text>
						<xsl:value-of select="$E" />
						<xsl:value-of select="$eventPosition" />
						<xsl:text>_</xsl:text>
						<xsl:value-of select="$C" />
						<xsl:value-of select="$crfPosition" />
				</td>
					</xsl:if>

					<xsl:if test="$crfStatusExist">
					<td class="table_header_row">
						<xsl:text>CRF Version Status_</xsl:text>
						<xsl:value-of select="$E" />
						<xsl:value-of select="$eventPosition" />
						<xsl:text>_</xsl:text>
						<xsl:value-of select="$C" />
						<xsl:value-of select="$crfPosition" />
					</td>
					</xsl:if>

					<xsl:if test="$crfVersionExist">
						<td class="table_header_row">
						<xsl:text>Version Name_</xsl:text>
						<xsl:value-of select="$E" />
						<xsl:value-of select="$eventPosition" />
						<xsl:text>_</xsl:text>
						<xsl:value-of select="$C" />
						<xsl:value-of select="$crfPosition" />
						</td>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>


<xsl:template mode="itemDataColumnHeaders"
		match="/odm:ODM/odm:ClinicalData/odm:SubjectData/odm:StudyEventData/odm:FormData/odm:ItemGroupData/odm:ItemData">

		<xsl:param name="crfPosition" />
		<xsl:param name="currentFormOID" />
		<xsl:param name="studyEventRepeatKey" />
				<xsl:param name="eventPosition" />
		<xsl:variable name="itemData" select="." />
		<xsl:variable name="itemOID" select="@ItemOID" />
		
		<xsl:apply-templates
			select="//odm:ODM/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$itemOID]"
			mode="ItemDefColHeaders">
			<xsl:with-param name="crfPosition" select="$crfPosition" />
			<xsl:with-param name="currentFormOID" select="$currentFormOID" />
			<xsl:with-param name="itemData" select="$itemData" />
			<xsl:with-param name="itemOID" select="$itemOID" />
			<xsl:with-param name="studyEventRepeatKey" select="$studyEventRepeatKey"/>
			<xsl:with-param name="ePosition" select="$eventPosition"/>
		</xsl:apply-templates>
	</xsl:template>


	<xsl:template mode="ItemDefColHeaders"
		match="//odm:ODM/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID]">
		<xsl:param name="crfPosition" />
		<xsl:param name="currentFormOID" />
		<xsl:param name="itemData" />
		<xsl:param name="itemOID" />
		<xsl:param name="studyEventRepeatKey"/>
		<xsl:param name="ePosition"/>
		<xsl:variable name="formOID"
			select="OpenClinica:ItemDetails/OpenClinica:ItemPresentInForm[@FormOID = $itemData/../../@FormOID]/@FormOID" />
	<td class="table_header_row">

		<xsl:if test="$currentFormOID = $formOID"> <!-- Changed from$currentFormOID = $formOID -->
		 <a href="javascript: void(0)">
					<xsl:attribute name="onclick">
                                            openWin('<xsl:value-of	select="$itemOID" />'); return  false;
                                            </xsl:attribute>
			<xsl:value-of select="@Name" />
			<xsl:text>_</xsl:text>
			<xsl:value-of select="$C" />
			<xsl:value-of select="$crfPosition" />
		
			
		
		
		<xsl:variable name="group" select="$itemData/parent::node()" />
			<xsl:variable name="groupOID" select="$group/@ItemGroupOID" />
			<!-- JN: Commenting out the logic for now, not sure if this is right as per Paul's suggestion -->
			<!--<xsl:for-each select="//odm:ItemGroupDef[@OID=$groupOID]">
				<xsl:if test="@Name !='Ungrouped'">
					<xsl:value-of select="@Name" />
				</xsl:if>
			</xsl:for-each>
			--><xsl:if test="$group/@ItemGroupRepeatKey">
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$group/@ItemGroupRepeatKey" />
			</xsl:if>
		<xsl:text>_</xsl:text>	<xsl:value-of select="$E"/>	<xsl:value-of select="$ePosition"/>
			<xsl:if test="$studyEventRepeatKey">
			<xsl:text>_</xsl:text>
			<xsl:value-of select="$studyEventRepeatKey"/>
			</xsl:if>
			</a>
		</xsl:if>
		</td>
	</xsl:template><!--



	

	--><!--<xsl:template name="repeatKey"> -->
	<!--<xsl:param name="testOID"/> -->
	<!--<xsl:param name="studyEventData"/> -->
	<!--<xsl:value-of select="$studyEventData[@StudyEventOID=$testOID and generate-id() 
		= -->
	<!--generate-id(key('studyEvents', @StudyEventRepeatKey)[1])]"/> -->
	<!--<xsl:value-of select="@StudyEventRepeatKey"/> -->
	<!--</xsl:template> -->

</xsl:stylesheet>
