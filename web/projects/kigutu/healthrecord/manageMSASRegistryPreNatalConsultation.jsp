<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"msas.registry.prenatal","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
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
    
    <table class="list" width="100%" cellspacing="1">
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>" colspan="2">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)' onchange='calculateAge();'>
                <script>writeTranDate();</script>
            </td>
        </tr>

        <tr>
        	<td width="100%" valign='top'>
	        	<table width='100%'>
	        		
					<tr>
			            <td class='admin'><%=getTran(request,"web","cpn.order",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_CPNORDER" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.cpnordernew",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_CPNORDER"),sWebLanguage,false,true) %>
			                </select>
							<select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PREGNANCY_QUARTER" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.pregnancy.age",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PREGNANCY_QUARTER"),sWebLanguage,false,true) %>
			                </select>
			            </td>
						
						
	        		</tr>
					
					
					
					<tr>
			            <td class='admin'><%=getTran(request,"web","gestity",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'>
						<input id="gestity" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_GESTITY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_GESTITY" property="value"/>"/>
						</td>
			            <td class="admin"><%=getTran(request,"web","milda",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_MILDA" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_MILDA;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","yes",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_MILDA" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_MILDA;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","no",sWebLanguage) %></label>
			            </td>
	        		</tr>
	        		
					
					<tr>
					<td class='admin'><%=getTran(request,"web","parity",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'>
							<input id="parity" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PARITY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PARITY" property="value"/>"/></td>
						<td class="admin"><%=getTran(request,"web","iron",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_IRON" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_IRON;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","yes",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_IRON" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_IRON;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","no",sWebLanguage) %></label>
			            </td>
					</tr>
					<tr>
					<td class='admin'><%=getTran(request,"web","alivechild",sWebLanguage)%>&nbsp;</td>
						<td class='admin2'>
							<input id="childalive" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_CHILD_ALIVE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_CHILD_ALIVE" property="value"/>"/></td>

						<td class="admin"><%=getTran(request,"web","albendazole",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_ALBENDAZOLE" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_ALBENDAZOLE;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","yes",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_ALBENDAZOLE" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_ALBENDAZOLE;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","no",sWebLanguage) %></label>
			            </td>							
					</tr>
					<tr>
					<td class='admin'><%=getTran(request,"web","deadchild",sWebLanguage)%>&nbsp;</td>

					<td class='admin2'>
							<input id="deadchild" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_CHILD_DEAD" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_CHILD_DEAD" property="value"/>"/></td>
							
					<td class='admin'><%=getTran(request,"web","ptme",sWebLanguage)%>&nbsp;</td>
					<td class="admin2">
			            <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PTME_PROPOSED" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PTME_PROPOSED;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","yes",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PTME_PROPOSED" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_IRON;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","no",sWebLanguage) %></label>
			            </td>						

					</tr>
					
					
					<tr>
					<td class='admin'><%=getTran(request,"web","abortedchild",sWebLanguage)%>&nbsp;</td>
					<td class='admin2'>
							<input id="abortedchild" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_CHILD_ABORTED" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_CHILD_ABORTED" property="value"/>"/></td>
					<td class='admin'><%=getTran(request,"web","pregnancy.risk",sWebLanguage)%>&nbsp;</td>
					<td class='admin2'>
						<input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PREGNANCY_RISK" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PREGNANCY_RISK;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","yes",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PREGNANCY_RISK" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PREGNANCY_RISK;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","no",sWebLanguage) %></label>
						</td>
					</tr>
					<tr>
					<td class='admin'><%=getTran(request,"web","borndeadchild",sWebLanguage)%>&nbsp;</td>
					<td class='admin2' colspan="1">
							<input id="borndeadchild" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_CHILD_BORN_DEAD" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_CHILD_BORN_DEAD" property="value"/>"/></td>
					<td class='admin'><%=getTran(request,"web","pregnancy.problem",sWebLanguage)%>&nbsp;</td>
					<td class='admin2'>
						<input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PREGNANCY_PROBLEM" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PREGNANCY_PROBLEM;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","yes",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PREGNANCY_PROBLEM" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PREGNANCY_PROBLEM;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","no",sWebLanguage) %></label>
						</td>
					
					
					</tr>
					<tr>
					<td class="admin"><%=getTran(request,"web","vih",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="1">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_HEARTSOUNDS" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_VIH;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","yes",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_VIH" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_VIH;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","no",sWebLanguage) %></label>
			            </td>
						
						<td class='admin'><%=getTran(request,"web","brachial.perimeter",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_BRACHIALPERIMETER")%> id="weight" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_BRACHIALPERIMETER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_BRACHIALPERIMETER" property="value"/>"/>mm</td>
					</tr>

					<tr>
					<td class='admin'><%=getTran(request,"web","uterus.height",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_MSAS_PRENATAL_UTERUSHEIGHT")%> id="weight" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_UTERUSHEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_UTERUSHEIGHT" property="value"/>"/></td>
					
					<td class='admin'><%=getTran(request,"web","qualification",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_QUALIFICATION" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.qualification",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_QUALIFICATION"),sWebLanguage,false,true) %>
			                </select>
			            </td>
					</tr>
					<tr>
					<td class="admin"><%=getTran(request,"web","heart.sounds",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="1">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_HEARTSOUNDS" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_HEARTSOUNDS;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","yes",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_HEARTSOUNDS" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_HEARTSOUNDS;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","no",sWebLanguage) %></label>
			            </td>
					<td class="admin"><%=getTran(request,"web", "consultation.observations", sWebLanguage)%></td>
			            <td colspan="3" class="admin2">
			                <textarea rows="2" onKeyup="resizeTextarea(this,10);" class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_OBSERVATIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_OBSERVATIONS" property="value"/></textarea>
			            </td>
					</tr>
					<tr>
					<td class='admin'><%=getTran(request,"web","foetus.mouvement",sWebLanguage)%>&nbsp;</td>
					<td class="admin2" colspan="3">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_HEARTSOUNDS" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_HEARTSOUNDS;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","yes",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_FOETUS_MOUVEMENT" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_FOETUS_MOUVEMENT;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","no",sWebLanguage) %></label>
			            </td>
					</tr>
					<tr>
					<td class='admin'><%=getTran(request,"web","presentation",sWebLanguage)%>&nbsp;</td>
					<td class="admin2" colspan="3">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PRESENTATION" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.presentation",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_PRESENTATION"),sWebLanguage,false,true) %>
			                </select>
							</td>
						</tr>
						
					<tr>
					<td class="admin"><%=getTran(request,"web","tpi",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'colspan="3">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_TPI" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.tpi",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_TPI"),sWebLanguage,false,true) %>
			                </select>
						</td>
					</tr>					
					
					<tr>
			            <td class='admin'><%=getTran(request,"web","vat",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2' colspan="3">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_VATRANK" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.vatrank",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_VATRANK"),sWebLanguage,false,true) %>
			                </select>
	                        <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_VATDATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_VATDATE" property="value" formatType="date"/>" id="vatdate" onblur='checkDate(this);'/>
	                        <script>writeMyDate("vatdate", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
			            </td>
			        </tr>
					<tr>
						<td colspan="4">
					      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
						</td>
					</tr>
	            </table>
	        </td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"msas.registry.prenatal",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if( document.getElementById('encounteruid').value=="" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERRAL_SOURCESITE").length()==0 && request.getParameter("nobuttons")==null?"":" && 1==0"%>){
  	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
  	searchEncounter();
  }	

  function searchUser(managerUidField,managerNameField){
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTEyeRegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }

  function submitForm(){
    transactionForm.saveButton.disabled = true;
    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
    %>
  }
  
  function calculateAge(){
    var trandate = new Date();
    var d1 = document.getElementById('trandate').value.split("/");
    if(d1.length == 3){
        // actual transaction date
        trandate.setDate(d1[0]);
        trandate.setMonth(d1[1] - 1);
        trandate.setFullYear(d1[2]);
        var deldate = new Date();
        var d1 = document.getElementById('deliverydate').value.split("/");
        if(d1.length == 3){
        	deldate.setDate(d1[0]);
        	deldate.setMonth(d1[1] - 1);
        	deldate.setFullYear(d1[2]);
            //Calculate number of days elapsed between last menstruation date and actual transaction date 
            var timeElapsed = trandate.getTime() - deldate.getTime();
            timeElapsed = timeElapsed / (1000 * 3600 * 24);
    		if (!isNaN(timeElapsed) && timeElapsed >= 0 && timeElapsed < 4) {
    			document.getElementById("cponorder").innerHTML="<b>CPoN 1 / J1-J3</b>";
    		}
    		else if (!isNaN(timeElapsed) && timeElapsed >= 4 && timeElapsed < 9) {
    			document.getElementById("cponorder").innerHTML="<b>CPoN 1 / J4-J8</b>";
    		}
    		else if (!isNaN(timeElapsed) && timeElapsed >= 9 && timeElapsed < 16) {
    			document.getElementById("cponorder").innerHTML="<b>CPoN 2 / J9-J15</b>";
    		}
    		else if (!isNaN(timeElapsed) && timeElapsed >= 16 && timeElapsed < 42) {
    			document.getElementById("cponorder").innerHTML="<b>CPoN 3 / J16-J41</b>";
    		}
    		else if (!isNaN(timeElapsed) && timeElapsed >= 42) {
    			document.getElementById("cponorder").innerHTML="<b>CPoN 3 / J42</b>";
    		}
        }
    }
  }
  
  calculateAge();
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>