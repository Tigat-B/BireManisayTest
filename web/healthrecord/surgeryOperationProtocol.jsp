<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%=checkPermission(out,"occup.operationprotocol","select",activeUser)%>

<form id="transactionForm" name="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
  
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>

    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>

    <%
        TransactionVO tran = (TransactionVO)transaction;
    
        String sTransactionStart    = getItemType(tran.getItems(),sPREFIX+"ITEM_TYPE_OPERATION_PROTOCOL_START"),
               sTransactionEnd      = getItemType(tran.getItems(),sPREFIX+"ITEM_TYPE_OPERATION_PROTOCOL_END"),
               sTransactionDuration = getItemType(tran.getItems(),sPREFIX+"ITEM_TYPE_OPERATION_PROTOCOL_DURATION");
    %>

    <table class="list" width="100%" cellspacing="1">
		<tr>
			<td style="vertical-align:top;padding:0;" class="admin2" width="50%">
			    <table class="list" cellspacing="1" cellpadding="0" width="100%">
			        <%-- DATE --%>
			        <tr>
			            <td class="admin" colspan="2">
			                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
			                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
			            </td>
			            <td class="admin2">
			                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
			                <script>writeTranDate();</script>
			            </td>
			        </tr>
			
			        <%-- START HOUR --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","starthour",sWebLanguage)%></td>
						<td class='admin2'>
							<table width='100%' cellpadding="0" cellspacing="0">
								<tr>
						            <td class="admin2" width='20%'>
						                <input <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_START")%> class="text" type="text" size="5" id="startHour" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_START" property="itemId"/>]>.value" value="<%=sTransactionStart%>" onblur="checkTime(this);calculateDuration(this);"onkeypress="keypressTime(this)"> h
						            </td>
						            <td class="admin" width='20%'><%=getTran(request,"openclinic.chuk","endhour",sWebLanguage)%></td>
						            <td class="admin2" width='20%'>
						                <input <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_END")%> class="text" type="text" size="5" id="endHour" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_END" property="itemId"/>]>.value" value="<%=sTransactionEnd%>" onblur="checkTime(this);calculateDuration(this);"onkeypress="keypressTime(this)"> h
						            </td>
						            <td class="admin" width='20%'><%=getTran(request,"openclinic.chuk","duration",sWebLanguage)%></td>
						            <td class="admin2" width='20%'>
						                <input <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_DURATION")%> class="text" type="text" size="5" id="duration" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_DURATION" property="itemId"/>]>.value" value="<%=sTransactionDuration%>" onblur="checkTime(this);" readonly> h
						            </td>
								</tr>
							</table>
						</td>
			        </tr>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","extractionhour",sWebLanguage)%></td>
						<td class='admin2'>
							<table width='100%' cellpadding="0" cellspacing="0">
								<tr>
									<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_EXTRACTION_HOUR", 5) %> h</td>
								</tr>
							</table>
						</td>
			        </tr>
					<tr>
						<td class='admin' colspan="2"><%=getTran(request,"gynecology", "timemdcalled", sWebLanguage)%></td>
						<td class='admin2'>
							<table width='100%' cellpadding="0" cellspacing="0">
								<tr>
									<td class='admin2' width='20%'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_MD_CALLED", 5) %> h</td>
									<td class='admin'  width='30%'><%=getTran(request,"gynecology", "timemdarrived", sWebLanguage)%>&nbsp;&nbsp;&nbsp;</td>
									<td class='admin2' width='*'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_MD_ARRIVED", 5) %> h</td>
								</tr>
							</table>
						</td>
					</tr>
			
			        <%-- INTERVENTION --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","intervention",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_INTERVENTION")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_INTERVENTION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_INTERVENTION" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- GROUP COMPOSITION ------------------------------------------------------%>
			        <%-- SURGEONS --%>
			        <tr>
			            <td class="admin" rowspan="3" width="100"><%=getTran(request,"openclinic.chuk","group.composition",sWebLanguage)%></td>
			            <td class="admin2" width="150"><%=getTran(request,"openclinic.chuk","surgeons",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_SURGEONS")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGEONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGEONS" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- ANESTHESISTS --%>
			        <tr>
			            <td class="admin2"><%=getTran(request,"openclinic.chuk","anasthesists",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_ANASTHESISTS")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANASTHESISTS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANASTHESISTS" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- NURSES --%>
			        <tr>
			            <td class="admin2"><%=getTran(request,"openclinic.chuk","nurses",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_NURSES")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_NURSES" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_NURSES" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- INSTALLATION --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","patient.installation",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_PATIENT_INSTALLATION")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_PATIENT_INSTALLATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_PATIENT_INSTALLATION" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- APROVAL --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","aproval",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_APROVAL")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_APROVAL" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_APROVAL" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- OBSERVATIONS --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","observations",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_OBSERVATION")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_OBSERVATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_OBSERVATION" property="value"/></textarea>
			            </td>
			        </tr>
					
			        <%-- TYPE --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","surgerytype",sWebLanguage)%></td>
			            <td class="admin2">
			                <%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_OPERATION_PROTOCOL_SURGERYTYPE", "surgerytypes",sWebLanguage,"") %>
			            </td>
			        </tr>
					
					<%	if(MedwanQuery.getInstance().getConfigInt("enableBurundi",0)==1){ %>
				        <%-- SURGICAL ACT 1,2,3 --%>
				        <tr>
				            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","anesthesia.act",sWebLanguage)%></td>
				            <td class="admin2">
				            	<table width='100%'>
					                <tr>
					                	<td>
					                		<select id="act1" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACT1" property="itemId"/>]>.value">
						            			<option/>
						            			<%=ScreenHelper.writeSelect(request,"anesthesiaacts.mspls",(((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACT1")).getValue(),sWebLanguage,false,true) %>
					                		</select>
					                	</td>
					                	<td>
											<%=getTran(request,"web","planned",sWebLanguage) %>:
				                            <input class="text" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED1")%> type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED1" property="itemId"/>]>.value" value="medwan.common.true"
				                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
				                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED1;value=medwan.common.true"
				                                                      property="value" outputString="checked"/>><%=getTran(request,"web","yes",sWebLanguage) %>
				                            <input class="text" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED1")%> type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED1" property="itemId"/>]>.value" value="medwan.common.false"
				                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
				                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED1;value=medwan.common.false"
				                                                      property="value" outputString="checked"/>><%=getTran(request,"web","no",sWebLanguage) %>
					                	</td>
					                </tr>
					                <tr>
					                	<td>
					                		<select id="act2" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACT2" property="itemId"/>]>.value">
						            			<option/>
						            			<%=ScreenHelper.writeSelect(request,"anesthesiaacts.mspls",(((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACT2")).getValue(),sWebLanguage,false,true) %>
					                		</select>
					                	</td>
					                	<td>
											<%=getTran(request,"web","planned",sWebLanguage) %>:
				                            <input class="text" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED2")%> type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED2" property="itemId"/>]>.value" value="medwan.common.true"
				                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
				                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED2;value=medwan.common.true"
				                                                      property="value" outputString="checked"/>><%=getTran(request,"web","yes",sWebLanguage) %>
				                            <input class="text" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED2")%> type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED2" property="itemId"/>]>.value" value="medwan.common.false"
				                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
				                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED2;value=medwan.common.false"
				                                                      property="value" outputString="checked"/>><%=getTran(request,"web","no",sWebLanguage) %>
					                	</td>
					                </tr>
					                <tr>
					                	<td>
					                		<select id="act3" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACT3" property="itemId"/>]>.value">
						            			<option/>
						            			<%=ScreenHelper.writeSelect(request,"anesthesiaacts.mspls",(((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACT3")).getValue(),sWebLanguage,false,true) %>
					                		</select>
					                	</td>
					                	<td>
											<%=getTran(request,"web","planned",sWebLanguage) %>:
				                            <input class="text" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED3")%> type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED3" property="itemId"/>]>.value" value="medwan.common.true"
				                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
				                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED3;value=medwan.common.true"
				                                                      property="value" outputString="checked"/>><%=getTran(request,"web","yes",sWebLanguage) %>
				                            <input class="text" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED3")%> type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED3" property="itemId"/>]>.value" value="medwan.common.false"
				                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
				                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACTPLANNED3;value=medwan.common.false"
				                                                      property="value" outputString="checked"/>><%=getTran(request,"web","no",sWebLanguage) %>
					                	</td>
					                </tr>
				                </table>
				            </td>
				        </tr>
				        <tr>
				            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","surgical.act",sWebLanguage)%></td>
				            <td class="admin2">
				            	<table  width='100%'>
					                <tr>
					                	<td>
					                		<select id="act1" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT1" property="itemId"/>]>.value">
						            			<option/>
						            			<%=ScreenHelper.writeSelect(request,"surgicalacts.mspls",(((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT1")).getValue(),sWebLanguage,false,true) %>
					                		</select>
					                	</td>
					                	<td>
											<%=getTran(request,"web","planned",sWebLanguage) %>:
				                            <input class="text" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED1")%> type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED1" property="itemId"/>]>.value" value="medwan.common.true"
				                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
				                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED1;value=medwan.common.true"
				                                                      property="value" outputString="checked"/>><%=getTran(request,"web","yes",sWebLanguage) %>
				                            <input class="text" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED1")%> type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED1" property="itemId"/>]>.value" value="medwan.common.false"
				                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
				                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED1;value=medwan.common.false"
				                                                      property="value" outputString="checked"/>><%=getTran(request,"web","no",sWebLanguage) %>
					                	</td>
					                </tr>
					                <tr>
					                	<td>
					                		<select id="act2" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT2" property="itemId"/>]>.value">
						            			<option/>
						            			<%=ScreenHelper.writeSelect(request,"surgicalacts.mspls",(((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT2")).getValue(),sWebLanguage,false,true) %>
					                		</select>
					                	</td>
					                	<td>
											<%=getTran(request,"web","planned",sWebLanguage) %>:
				                            <input class="text" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED2")%> type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED2" property="itemId"/>]>.value" value="medwan.common.true"
				                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
				                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED2;value=medwan.common.true"
				                                                      property="value" outputString="checked"/>><%=getTran(request,"web","yes",sWebLanguage) %>
				                            <input class="text" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED2")%> type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED2" property="itemId"/>]>.value" value="medwan.common.false"
				                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
				                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED2;value=medwan.common.false"
				                                                      property="value" outputString="checked"/>><%=getTran(request,"web","no",sWebLanguage) %>
					                	</td>
					                </tr>
					                <tr>
					                	<td>
					                		<select id="act3" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT3" property="itemId"/>]>.value">
						            			<option/>
						            			<%=ScreenHelper.writeSelect(request,"surgicalacts.mspls",(((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT3")).getValue(),sWebLanguage,false,true) %>
					                		</select>
					                	</td>
					                	<td>
											<%=getTran(request,"web","planned",sWebLanguage) %>:
				                            <input class="text" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED3")%> type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED3" property="itemId"/>]>.value" value="medwan.common.true"
				                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
				                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED3;value=medwan.common.true"
				                                                      property="value" outputString="checked"/>><%=getTran(request,"web","yes",sWebLanguage) %>
				                            <input class="text" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED3")%> type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED3" property="itemId"/>]>.value" value="medwan.common.false"
				                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
				                                                      compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACTPLANNED3;value=medwan.common.false"
				                                                      property="value" outputString="checked"/>><%=getTran(request,"web","no",sWebLanguage) %>
					                	</td>
					                </tr>
				                </table>
				            </td>
				        </tr>
					
					<%	}
						else{
					%>
				        <%-- SURGICAL ACT 1,2,3 --%>
				        <tr>
				            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","surgical.act",sWebLanguage)%></td>
				            <td class="admin2">
				            	<table cellpadding="0" cellspacing="0">
				                <tr><td><select id="act1" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT1" property="itemId"/>]>.value">
					            	<option/>
					            	<%=ScreenHelper.writeSelect(request,"surgicalacts",(((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT1")).getValue(),sWebLanguage,false,true) %>
				                </select></td></tr>
				                
				                <tr><td><select id="act2" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT2" property="itemId"/>]>.value">
					            	<option/>
					            	<%=ScreenHelper.writeSelect(request,"surgicalacts",(((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT2")).getValue(),sWebLanguage,false,true) %>
				                </select></td></tr>
				                
				                <tr><td><select id="act3" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT3" property="itemId"/>]>.value">
					            	<option/>
					            	<%=ScreenHelper.writeSelect(request,"surgicalacts",(((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT3")).getValue(),sWebLanguage,false,true) %>
				                </select></td></tr>
				                </table>
				            </td>
				        </tr>
					<%
						}
					%>
			        <%-- CLOSURE --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","closure",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_CLOSURE")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_CLOSURE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_CLOSURE" property="value"/></textarea>
			            </td>
			        </tr>
			
				    <tr>
				        <td class="admin" colspan="2"><%=getTran(request,"web.occup","nosocomial.infections",sWebLanguage)%>&nbsp;</td>
				        <td class="admin2">
				  			<table width='100%'>
				  				<tr>
				   					<td class="admin2">
				         				<%=SH.writeDefaultCheckBoxes((TransactionVO)transaction, request, "nosocomial.infections", "ITEM_TYPE_NOSOCOMIAL_INFECTIONS", sWebLanguage, true) %>
				         			</td>
								</tr>
							</table>			            		
				        </td>
				    </tr>
			        <%-- CARE --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","care.post.op",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_CARE")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_CARE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_CARE" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- REMARKS --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","remarks",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_OPERATION_PROTOCOL_REMARKS")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_REMARKS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_REMARKS" property="value"/></textarea>
			            </td>
			        </tr>
			    </table>
			</td>
			
			<%-- DIAGNOSES --%>
			<td style="vertical-align:top;padding:0" class="admin2">
                <%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
			</td>
		</tr>
    </table>

	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.operationprotocol",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>

    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  <%-- SUBMIT FORM --%>
  function submitForm(){
    if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERRAL_SOURCESITE").length()==0 && request.getParameter("nobuttons")==null?"":" && 1==0"%>){
	  alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
	  searchEncounter();
	}	
    else{
	  var temp = Form.findFirstElement(transactionForm); //for ff compatibility
	  document.transactionForm.submit();
	  document.getElementById("buttonsDiv").style.visibility = "hidden";
    }
  }
  
  <%-- SEARCH ENCOUNTER --%>
  function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERRAL_SOURCESITE").length()==0 && request.getParameter("nobuttons")==null?"":" && 1==0"%>){
	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
	searchEncounter();
  }	
  
  <%-- CALCULATE DURATION --%>
  function calculateDuration(obj){
    var vStart = document.getElementById("startHour").value,
        vEnd   = document.getElementById("endHour").value;

    var aStart = vStart.split(":");
    var aEnd = vEnd.split(":");

    var startDate = new Date();
    startDate.setHours(aStart[0]);
    startDate.setMinutes(aStart[1]);
    startDate.setSeconds(0);

    var endDate = new Date();
    endDate.setHours(aEnd[0]);
    endDate.setMinutes(aEnd[1]);
    endDate.setSeconds(0);

    var one_min = 1000*60;
    
    var vDurationDate = new Date();
    vDurationDate.setHours(0);
    vDurationDate.setMinutes(Math.ceil((endDate.getTime()-startDate.getTime())/(one_min)));
    vDurationDate.setSeconds(0);

    if(vStart!="" && vEnd!=""){
      if(endDate > startDate){
    	document.getElementById("duration").value = vDurationDate.getHours()+":"+(vDurationDate.getMinutes()<10?"0"+vDurationDate.getMinutes():vDurationDate.getMinutes());
      }
      else{
        durationObj.value = "";        
        alertDialog("web","endhour_greater_than_starthour");       
        obj.value = "";
      }
    }
    else{
      document.getElementById("duration").value = "";
    }
  }
</script>

<%=writeJSButtons("transactionForm","saveButton")%>