<%@page import="be.mxs.common.model.vo.healthrecord.TransactionVO,
                be.mxs.common.model.vo.healthrecord.ItemVO,
                be.openclinic.pharmacy.Product,
                java.text.DecimalFormat,
                be.openclinic.medical.Problem,
                be.openclinic.medical.Diagnosis,
                be.openclinic.system.Transaction,
                be.openclinic.system.Item,
                be.openclinic.medical.Prescription,
                java.util.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="be.openclinic.medical.PaperPrescription" %>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String accessright="mspls.adulthiv.followup";
%>
<%=checkPermission(accessright,"select",activeUser)%>
<%!
    private class TransactionID {
        public int transactionid = 0;
        public int serverid = 0;
    }

    //--- GET MY TRANSACTION ID -------------------------------------------------------------------
    private TransactionID getMyTransactionID(String sPersonId, String sItemTypes, JspWriter out) {
        TransactionID transactionID = new TransactionID();
        Transaction transaction = Transaction.getSummaryTransaction(sItemTypes, sPersonId);
        try {
            if (transaction != null) {
                String sUpdateTime = ScreenHelper.getSQLDate(transaction.getUpdatetime());
                transactionID.transactionid = transaction.getTransactionId();
                transactionID.serverid = transaction.getServerid();
                out.print(sUpdateTime);
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (Debug.enabled) Debug.println(e.getMessage());
        }
        return transactionID;
    }

    //--- GET MY ITEM VALUE -----------------------------------------------------------------------
    private String getMyItemValue(TransactionID transactionID, String sItemType, String sWebLanguage) {
        String sItemValue = "";
        Vector vItems = Item.getItems(Integer.toString(transactionID.transactionid), Integer.toString(transactionID.serverid), sItemType);
        Iterator iter = vItems.iterator();

        Item item;

        while (iter.hasNext()) {
            item = (Item) iter.next();
            sItemValue = item.getValue();//checkString(rs.getString(1));
            sItemValue = getTranNoLink("Web.Occup", sItemValue, sWebLanguage);
        }
        return sItemValue;
    }
%>
<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
   
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CONTEXT_DEPARTMENT") %>
    <%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CONTEXT_CONTEXT") %>
    
    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    
    <table class="list" width="100%" cellspacing="1" cellpadding='0'>
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>" colspan="4">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
        <tr class='admin'>
			<td colspan='4'>I. <%=getTran(request,"web","hivconsultation",sWebLanguage) %></td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"web","hivreasonforencounter",sWebLanguage) %></td>
        	<td class='admin' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_COMPLAINTS", 80, 1)%></td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"web","patientonantituberculosis",sWebLanguage) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_ONANTITB", sWebLanguage, false, "onchange='evaluatetbdate()' onblur='evaluatetbdate()'", "")%></td>
        	<td class='admin' colspan='2'>
				<table width='100%' id='tbsince'>
					<tr>
			        	<td class='admin'><%=getTran(request,"web","treatmentsince",sWebLanguage) %></td>
			        	<td class='admin2'><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ONANTITBSINCE", sWebLanguage, sCONTEXTPATH)%></td>
					</tr>
				</table>
			</td>
        </tr>
        <tr id='tbscreening' style='display: none'>
			<td class='admin'><%=getTran(request,"web","tbscreeningquestionnaire",sWebLanguage) %></td>
        	<td colspan='3'>
        		<table width='100%'>
        			<tr>
			        	<td class='admin'><%=getTran(request,"web","tbquestion1",sWebLanguage) %></td>
			        	<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_TBQUESTIONNAIRE1", sWebLanguage, false, "onblur='evaluatetbquestionnaire()' onchange='evaluatetbquestionnaire()'", "")%></td>
        			</tr>
        			<tr>
			        	<td class='admin'><%=getTran(request,"web","tbquestion2",sWebLanguage) %></td>
			        	<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_TBQUESTIONNAIRE2", sWebLanguage, false, "onblur='evaluatetbquestionnaire()' onchange='evaluatetbquestionnaire()'", "")%></td>
        			</tr>
        			<tr>
			        	<td class='admin'><%=getTran(request,"web","tbquestion3",sWebLanguage) %></td>
			        	<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_TBQUESTIONNAIRE3", sWebLanguage, false, "onblur='evaluatetbquestionnaire()' onchange='evaluatetbquestionnaire()'", "")%></td>
        			</tr>
        			<tr>
			        	<td class='admin'><%=getTran(request,"web","tbquestion4",sWebLanguage) %></td>
			        	<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_TBQUESTIONNAIRE4", sWebLanguage, false, "onblur='evaluatetbquestionnaire()' onchange='evaluatetbquestionnaire()'", "")%></td>
        			</tr>
        			<tr>
			        	<td class='admin'><%=getTran(request,"web","tbquestion5",sWebLanguage) %></td>
			        	<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_TBQUESTIONNAIRE5", sWebLanguage, false, "onblur='evaluatetbquestionnaire()' onchange='evaluatetbquestionnaire()'", "")%></td>
        			</tr>
        			<tr id='tbmessagetr' style='display: none'>
						<td class='admin2' colspan='2' id='tbmessage'></td>
        			</tr>
        		</table>
        	</td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"web","patientoninh",sWebLanguage) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_ONINH", sWebLanguage, false, "onchange='evaluateinhdate()' onblur='evaluateinhdate()'", "")%></td>
        	<td class='admin' colspan='2'>
				<table width='100%'>
					<tr id='inhsince'>
			        	<td class='admin'><%=getTran(request,"web","treatmentsince",sWebLanguage) %></td>
			        	<td class='admin2'><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ONINHSINCE", sWebLanguage, sCONTEXTPATH)%></td>
					</tr>
			        <tr id='inhwhynot'>
			        	<td class='admin'><%=getTran(request,"web","inhwhynot",sWebLanguage) %></td>
			        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ONINHWHYNOT", 40, 1)%></td>
			        </tr>
			        <tr id='inhempty'>
			        	<td class='admin' colspan='2'></td>
			        </tr>
				</table>
        	</td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"web","sideeffet",sWebLanguage) %></td>
        	<td class='admin'><%=getTran(request,"web","duration",sWebLanguage) %></td>
        	<td class='admin'><%=getTran(request,"web","treatment",sWebLanguage) %></td>
        	<td class='admin'><%=getTran(request,"web","observations",sWebLanguage) %></td>
        </tr>
        <%
        	for(int n=1;n<4;n++){
        %>
        <tr>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_SIDEEFFECT"+n, 40, 1)%></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_SIDEEFFECTDURATION"+n, 20)%></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_SIDEEFFECTTREATMENT"+n, 20, 1)%></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_SIDEEFFECTOBSERVATION"+n, 20, 1)%></td>
        </tr>
        <%
        	}
        %>
        <tr>
        	<td class='admin'><%=getTran(request,"web","reasontreatmentinterruption",sWebLanguage) %></td>
        	<td class='admin'><%=getTran(request,"web","duration",sWebLanguage) %></td>
        	<td class='admin'><%=getTran(request,"web","startsagain",sWebLanguage) %></td>
        	<td class='admin'><%=getTran(request,"web","observations",sWebLanguage) %></td>
        </tr>
        <tr>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_REASONTREATMENTINTERRUPTION", 40, 1)%></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_TREATMENTINTERRUPTIONDURATION", 20)%></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_TREATMENTINTERRUPTIONRESTART", sWebLanguage, false, "", "")%></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_TREATMENTINTERRUPTIONOBSERVATION", 20, 1)%></td>
        </tr>
        <tr class='admin'>
			<td colspan='4'>II. <%=getTran(request,"web","hivminimumpackageofpreventionservices",sWebLanguage) %></td>
        </tr>
        <tr>
        	<td colspan='4'>
				<table width='100%'>
					<tr>
						<td class='admin'><%=getTran(request,"web","serviceoffered",sWebLanguage) %></td>
						<td class='admin' colspan='4'><%=getTran(request,"web","comments",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","hivservice1",sWebLanguage) %></td>
						<td class='admin' nowrap><%=getTran(request,"web","hivcomment1.1",sWebLanguage) %></td>
						<td class='admin2' nowrap><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesnona", "ITEM_TYPE_HIVADULT_SERVICE1.1", sWebLanguage, false, "", "") %></td>
						<td class='admin' nowrap><%=getTran(request,"web","hivcomment1.2",sWebLanguage) %></td>
						<td class='admin2' nowrap><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesnona", "ITEM_TYPE_HIVADULT_SERVICE1.2", sWebLanguage, false, "", "") %></td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","hivservice2",sWebLanguage) %></td>
						<td class='admin' nowrap><%=getTran(request,"web","hivcomment2.1",sWebLanguage) %></td>
						<td class='admin2' nowrap><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_SERVICE2.1", sWebLanguage, false, "", "") %></td>
						<td class='admin' nowrap><%=getTran(request,"web","hivcomment2.2",sWebLanguage) %></td>
						<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_SERVICE2.3", sWebLanguage, sCONTEXTPATH)%><br/><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "posneg", "ITEM_TYPE_HIVADULT_SERVICE2.2", sWebLanguage, false, "", "") %></td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","hivservice3",sWebLanguage) %></td>
						<td class='admin' nowrap><%=getTran(request,"web","hivcomment3.1",sWebLanguage) %></td>
						<td class='admin2' nowrap><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_SERVICE3.1", sWebLanguage, false, "", "") %></td>
						<td class='admin' nowrap><%=getTran(request,"web","hivcomment3.2",sWebLanguage) %></td>
						<td class='admin2' nowrap><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_SERVICE3.2", sWebLanguage, false, "", "") %></td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","hivservice5",sWebLanguage) %></td>
						<td class='admin' nowrap><%=getTran(request,"web","hivcomment4.1",sWebLanguage) %></td>
						<td class='admin2' nowrap><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesnona", "ITEM_TYPE_HIVADULT_SERVICE4.1", sWebLanguage, false, "", "") %></td>
						<td class='admin' nowrap><%=getTran(request,"web","hivcomment4.2",sWebLanguage) %></td>
						<td class='admin2' nowrap><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_SERVICE4.2", 20, 1)%></td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","hivservice4",sWebLanguage) %></td>
						<td class='admin' nowrap><%=getTran(request,"web","hivcomment5.1",sWebLanguage) %></td>
						<td class='admin2' nowrap><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_SERVICE5.1", sWebLanguage, false, "", "") %></td>
						<td class='admin' nowrap><%=getTran(request,"web","hivcomment5.2",sWebLanguage) %></td>
						<td class='admin2' nowrap><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_SERVICE5.2", sWebLanguage, false, "", "") %></td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","hivservice6",sWebLanguage) %></td>
						<td class='admin' nowrap><%=getTran(request,"web","hivcomment6.1",sWebLanguage) %></td>
						<td class='admin2' nowrap><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_SERVICE6.1", sWebLanguage, false, "", "") %></td>
						<td class='admin' nowrap><%=getTran(request,"web","hivcomment6.2",sWebLanguage) %></td>
						<td class='admin2' nowrap><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_SERVICE6.2", 20, 1)%></td>
					</tr>
				</table>
			</td>
		</tr>
        <tr class='admin'>
        	<td colspan='4'>III. <%=getTran(request,"web","clinicalexamination",sWebLanguage) %></td>
		</tr>        
		<tr>
			<td class='admin'><%=getTran(request,"web","vitalsigns",sWebLanguage) %></td>
			<td class='admin2' colspan='3'>
            	<table width="100%">
            		<tr>
            			<td class='admin' width='25%'><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%></td>
            			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE", 5) %>�C</td>
            			<td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%></td>
            			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_BIOMETRY_HEIGHT",5,"onblur='calculateBMI()'") %>cm</td>
            			<td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%></td>
            			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_BIOMETRY_WEIGHT", 5,"onblur='calculateBMI()'") %>kg</td>
            			<td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%></td>
            			<td class='admin2'><input id="BMI" class="text" type="text" size="5" name="BMI" readonly /></td>
            		</tr>
	                <tr>
			            <td class='admin'><%=getTran(request,"openclinic.chuk","sao2",sWebLanguage)%></td>
			            <td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION", 5,"") %>%</td>
			            <td class='admin'><%=getTran(request,"web","abdomencircumference",sWebLanguage)%></td>
			            <td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_ABDOMENCIRCUMFERENCE", 5,"") %>cm</td>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%></td>
			            <td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY", 5,"") %></td>
			            <td class='admin'><%=getTran(request,"web","fhr",sWebLanguage)%></td>
			            <td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_FOETAL_HEARTRATE", 5,"") %></td>
	                </tr>
	                <tr>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%></td>
			            <td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT", 5,"") %>/<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT", 5,"") %>mmHg</td>
			            <td class='admin'><%=getTran(request,"openclinic.chuk","respiratory.frequency",sWebLanguage)%></td>
			            <td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY", 5,"") %>cm</td>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforlength",sWebLanguage)%></td>
			            <td class='admin2'><input tabindex="-1" class="text" type="text" size="4" readonly name="WFL" id="WFL"><img id="wflinfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/></td>
	                </tr>
            	</table>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","generalstatus",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "hiv.adult.generalstatus", "ITEM_TYPE_HIVADULT_GENERALSTATUS", sWebLanguage, true, "", "")%></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"hiv","typeofhandicap",sWebLanguage) %></td>
			<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "hiv.adult.typeofhandicap", "ITEM_TYPE_HIVADULT_HANDICAP", sWebLanguage, false,"","") %></td>
			<td class='admin2'><%=getTran(request,"web","other",sWebLanguage) %>: <%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_HANDICAP.OTHER", 20, 1)%></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","clinicalexamsummary",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_CLINICALEXAMSUMMARY", 80, 1)%></td>
		</tr>
        <tr class='admin'>
        	<td colspan='4'>IV. <%=getTran(request,"hiv","conclusion",sWebLanguage) %></td>
		</tr>        
		<tr>
			<td class='admin'><%=getTran(request,"web","nutritionstatus",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "hiv.adult.nutritionstatus", "ITEM_TYPE_HIVADULT_NUTRITIONSTATUS", sWebLanguage, false,"","") %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","actualdiagnosis",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ACTUALDIAGNOSIS", 80, 1)%></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","associateddiseases",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ASSOCIATEDDISEASES", 80, 1)%></td>
		</tr>
        <tr>
        	<td class='admin' colspan='4'><%=getTran(request,"hiv","stableorinstablepatient",sWebLanguage) %></td>
		</tr>      
		<%
			for(int n=1;n<7;n++){
		%>  
		<tr>
			<td class='admin' width='35%'>&nbsp;&nbsp;<%=getTran(request,"web","stabilitycriteria"+n,sWebLanguage) %></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_STABILITYCRITERIA"+n, sWebLanguage, true, "onchange='evaluatestability()' onblur='evaluatestability()'", "")%></td>
		</tr>
		<%
			}
		%>
		<tr>
			<td class='admin'><%=getTran(request,"hiv","conclusion",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "hiv.stability", "ITEM_TYPE_HIVADULT_STABILITY", sWebLanguage, true, "onchange='evaluatestability()' onblur='evaluatestability()'", "")%></td>
		</tr>
        <tr class='admin'>
        	<td colspan='4'>V. <%=getTran(request,"web","treatmentattitude",sWebLanguage) %></td>
		</tr>        
		<tr>
			<td class='admin'><%=getTran(request,"web","nutritiontreatmentnecessary",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_TREATMENT_NUTRITION", sWebLanguage, false,"","") %></td>
		</tr>
        <tr>
        	<td class='admin' colspan='4'><%=getTran(request,"hiv","art",sWebLanguage) %></td>
		</tr>        
		<tr>
			<td class='admin2' colspan='4'>
            	<table width="100%">
			        <tr>
			        	<td class='admin'><%=getTran(request,"hiv","combination",sWebLanguage) %></td>
			        	<td class='admin'><%=getTran(request,"hiv","start",sWebLanguage) %></td>
			        	<td class='admin'><%=getTran(request,"hiv","continuation",sWebLanguage) %></td>
			        	<td class='admin'><%=getTran(request,"hiv","change",sWebLanguage) %></td>
			        	<td class='admin'><%=getTran(request,"hiv","treatmentline",sWebLanguage) %></td>
					</tr>      
					<tr>
			        	<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_MOLECULE1", "hivadult.molecule", sWebLanguage, "") %></td>
        				<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARVTREATMENT_STARTDATE1", sWebLanguage, sCONTEXTPATH) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARTCONTINUATION1", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARTCHANGE1", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARTTREATMENTLINE1", 20, 1)%></td>
					</tr>
					<tr>
			        	<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_MOLECULE2", "hivadult.molecule", sWebLanguage, "") %></td>
        				<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARVTREATMENT_STARTDATE2", sWebLanguage, sCONTEXTPATH) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARTCONTINUATION2", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARTCHANGE2", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARTTREATMENTLINE2", 20, 1)%></td>
					</tr>
					<tr>
			        	<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_MOLECULE3", "hivadult.molecule", sWebLanguage, "") %></td>
        				<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARVTREATMENT_STARTDATE3", sWebLanguage, sCONTEXTPATH) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARTCONTINUATION3", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARTCHANGE3", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARTTREATMENTLINE3", 20, 1)%></td>
					</tr>
				</table>
			</td>  
		</tr>
        <tr>
        	<td class='admin' colspan='4'><%=getTran(request,"hiv","opportunisticinfectionsandotherdiseases",sWebLanguage) %></td>
		</tr>        
		<tr>
		<tr>
			<td class='admin2' colspan='4'>
            	<table width="100%">
			        <tr>
			        	<td class='admin'><%=getTran(request,"hiv","tbandotheroi",sWebLanguage) %></td>
			        	<td class='admin'><%=getTran(request,"hiv","molecule",sWebLanguage) %></td>
			        	<td class='admin'><%=getTran(request,"hiv","dose",sWebLanguage) %></td>
			        	<td class='admin'><%=getTran(request,"hiv","duration",sWebLanguage) %></td>
					</tr>      
					<tr>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OIINFECTION1", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OIMOLECULE1", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OIDOSE1", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OIDURATION1", 20, 1)%></td>
					</tr>
					<tr>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OIINFECTION2", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OIMOLECULE2", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OIDOSE2", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OIDURATION2", 20, 1)%></td>
					</tr>
				</table>
			</td> 
		</tr>			
        <tr>
        	<td class='admin' colspan='4'><%=getTran(request,"hiv","otherdioseases",sWebLanguage) %></td>
		</tr>        
		<tr>
		<tr>
			<td class='admin2' colspan='4'>
            	<table width="100%">
			        <tr>
			        	<td class='admin'><%=getTran(request,"hiv","disease",sWebLanguage) %></td>
			        	<td class='admin'><%=getTran(request,"hiv","molecule",sWebLanguage) %></td>
			        	<td class='admin'><%=getTran(request,"hiv","referralto",sWebLanguage) %></td>
			        	<td class='admin'><%=getTran(request,"hiv","observations",sWebLanguage) %></td>
					</tr>      
					<tr>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OTHERDISEASE1", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OTHERDISEASEMOLECULE1", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OTHERDISEASEDOSE1", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OTHERDISEASEDURATION1", 20, 1)%></td>
					</tr>
					<tr>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OTHERDISEASE2", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OTHERDISEASEMOLECULE2", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OTHERDISEASEDOSE2", 20, 1)%></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OTHERDISEASEDURATION2", 20, 1)%></td>
					</tr>
				</table>
			</td> 
		</tr>			
        <tr>
        	<td class='admin' colspan='4'><%=getTran(request,"hiv","familyplanning",sWebLanguage) %></td>
		</tr>        
		<tr>
			<td class='admin'><%=getTran(request,"web","patientunderfamilyplanning",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_UNDERFP", sWebLanguage, false,"","") %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","ifnotcounseledforfamilyplanning",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_COUNSELEDFP", sWebLanguage, false,"","") %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","ifyeswhichmethod",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_COUNSELEDFP", 20, 1)%></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","nextappointment",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_NEXTAPPOINTMENT", sWebLanguage, sCONTEXTPATH) %></td>
			<td class='admin'><%=getTran(request,"web","reason",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_NEXTAPPOINTMENT_REASON", 40, 1)%></td>
		</tr>
    </table>
    <table width="100%" class="list" cellspacing="1">
        <tr class="admin">
            <td align="center"><a href="javascript:openPopup('medical/managePrescriptionsPopup.jsp&amp;skipEmpty=1',900,400,'medication');void(0);"><%=getTran(request,"Web.Occup","medwan.healthrecord.medication",sWebLanguage)%></a></td>
        </tr>
        <tr>
            <td id='activeprescriptions'>
            	<script>
            		function loadActivePrescriptions(){
           		    	var url = '<c:url value="/pharmacy/getActivePrescriptions.jsp"/>?ts='+new Date();
           		      	new Ajax.Request(url,{
           			  		method: "GET",
           		        	parameters: "",
           		        	onSuccess: function(resp){
           		        		document.getElementById('activeprescriptions').innerHTML=resp.responseText;
           		        	}
           		      	});
            		}
                	loadActivePrescriptions();
            	</script>
            </td>
        </tr>
        <tr class="admin">
            <td align="center"><%=getTran(request,"curative","medication.paperprescriptions",sWebLanguage)%> (<%=ScreenHelper.stdDateFormat.format(((TransactionVO)transaction).getUpdateTime())%>)</td>
        </tr>
        <%
            Vector paperprescriptions = PaperPrescription.find(activePatient.personid,"",ScreenHelper.stdDateFormat.format(((TransactionVO)transaction).getUpdateTime()),ScreenHelper.stdDateFormat.format(((TransactionVO)transaction).getUpdateTime()),"","DESC");
            if(paperprescriptions.size()>0){
                out.print("<tr><td><table width='100%'>");
                String l="";
                for(int n=0;n<paperprescriptions.size();n++){
                    if(l.length()==0){
                        l="1";
                    }
                    else{
                        l="";
                    }
                    PaperPrescription paperPrescription = (PaperPrescription)paperprescriptions.elementAt(n);
                    out.println("<tr class='list"+l+"' id='pp"+paperPrescription.getUid()+"'><td valign='top' width='90px'><img src='_img/icons/icon_delete.png' onclick='deletepaperprescription(\""+paperPrescription.getUid()+"\");'/> <b>"+ScreenHelper.stdDateFormat.format(paperPrescription.getBegin())+"</b></td><td><i>");
                    Vector products =paperPrescription.getProducts();
                    for(int i=0;i<products.size();i++){
                        out.print(products.elementAt(i)+"<br/>");
                    }
                    out.println("</i></td></tr>");
                }
                out.print("</table></td></tr>");
            }
        %>
        <tr>
            <td><a href="javascript:openPopup('medical/managePrescriptionForm.jsp&amp;skipEmpty=1',650,430,'medication');void(0);"><%=getTran(request,"web","medicationpaperprescription",sWebLanguage)%></a></td>
        </tr>
    </table>            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,accessright,sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>  
  function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&VarCode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
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
  
  function evaluatetbdate(){
	  if(document.getElementById('ITEM_TYPE_HIVADULT_ONANTITB.1').checked){
		  document.getElementById('tbsince').style.display='';
		  document.getElementById('tbscreening').style.display='none';
	  }
	  else{
		  document.getElementById('tbsince').style.display='none';
		  if(document.getElementById('ITEM_TYPE_HIVADULT_ONANTITB.0').checked){
			  document.getElementById('tbscreening').style.display='';
		  }
		  else{
			  document.getElementById('tbscreening').style.display='none';
		  }
	  }
  }
  
  function evaluateinhdate(){
	  if(document.getElementById('ITEM_TYPE_HIVADULT_ONINH.1').checked){
		  document.getElementById('inhsince').style.display='';
		  document.getElementById('inhwhynot').style.display='none';
		  document.getElementById('inhempty').style.display='none';
	  }
	  else if(document.getElementById('ITEM_TYPE_HIVADULT_ONINH.0').checked){
		  document.getElementById('inhsince').style.display='none';
		  document.getElementById('inhwhynot').style.display='';
		  document.getElementById('inhempty').style.display='none';
	  }
	  else{
		  document.getElementById('inhsince').style.display='none';
		  document.getElementById('inhwhynot').style.display='none';
		  document.getElementById('inhempty').style.display='';
	  }
  }
  
  function evaluatetbquestionnaire(){
	  document.getElementById('tbmessagetr').style.display='none';
	  if(document.getElementById('ITEM_TYPE_HIVADULT_TBQUESTIONNAIRE1.1').checked){
		  document.getElementById('tbmessagetr').style.display='';
		  document.getElementById('tbmessage').innerHTML='<img src="<%=sCONTEXTPATH%>/_img/icons/icon_warning.gif"/> <%=getTranNoLink("hiv","tbmessage1",sWebLanguage)%>';
	  }
	  else{
		  for(n=2;n<6;n++){
			  if(document.getElementById('ITEM_TYPE_HIVADULT_TBQUESTIONNAIRE'+n+".1").checked){
				  document.getElementById('tbmessagetr').style.display='';
				  document.getElementById('tbmessage').innerHTML='<img src="<%=sCONTEXTPATH%>/_img/icons/icon_warning.gif"/> <%=getTranNoLink("hiv","tbmessage2",sWebLanguage)%>';
				  break;
			  }
		  }
	  }
  }
  
  function evaluatestability(){
	  var unstable=0;
	  var unknownexists=false;
	  document.getElementById('tbmessagetr').style.display='none';
	  for(n=1;n<7;n++){
		  if(document.getElementById('ITEM_TYPE_HIVADULT_STABILITYCRITERIA'+n+".0").checked){
			  unstable=1;
			  break;
		  }
		  else if(!document.getElementById('ITEM_TYPE_HIVADULT_STABILITYCRITERIA'+n+".1").checked){
			  unknownexists=true;
		  }
	  }
	  if(unstable==1){
		  document.getElementById('ITEM_TYPE_HIVADULT_STABILITY.1').checked=true;
	  }
	  else if(!unknownexists){
		  document.getElementById('ITEM_TYPE_HIVADULT_STABILITY.0').checked=true;
	  }
	  else{
		  document.getElementById('ITEM_TYPE_HIVADULT_STABILITY.0').checked=false;
		  document.getElementById('ITEM_TYPE_HIVADULT_STABILITY.1').checked=false;
	  }
  }
  
  function calculateBMI(){
	  var _BMI = 0;
	  var heightInput = document.getElementById('ITEM_TYPE_BIOMETRY_HEIGHT');
	  var weightInput = document.getElementById('ITEM_TYPE_BIOMETRY_WEIGHT');
	
	  if(heightInput.value > 0){
	      _BMI = (weightInput.value * 10000) / (heightInput.value * heightInput.value);
	      if(_BMI > 100 || _BMI < 5){
	          document.getElementsByName('BMI')[0].value = "";
	      }
	      else{
	          document.getElementsByName('BMI')[0].value = Math.round(_BMI*10)/10;
	      }
	      var wfl=(weightInput.value*1/heightInput.value*1);
	      if(wfl>0){
	    	  document.getElementById('WFL').value = wfl.toFixed(2);
	    	  checkWeightForHeight(heightInput.value,weightInput.value);
	      }
	  }
  }

  	function checkWeightForHeight(height,weight){
		var today = new Date();
	    var url= '<c:url value="/ikirezi/getWeightForHeight.jsp"/>?height='+height+'&weight='+weight+'&gender=<%=activePatient.gender%>&ts='+today;
	    new Ajax.Request(url,{
	        method: "POST",
	        postBody: "",
	        onSuccess: function(resp){
	            var label = eval('('+resp.responseText+')');
	    		if(label.zindex>-999){
	    			if(label.zindex<-4){
	    				document.getElementById("WFL").className="darkredtext";
	    				document.getElementById("wflinfo").title="Z-index < -4: <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex<-3){
	    				document.getElementById("WFL").className="darkredtext";
	    				document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex<-2){
	    				document.getElementById("WFL").className="orangetext";
	    				document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","moderate.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex<-1){
	    				  document.getElementById("WFL").className="yellowtext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.malnutrition",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else if(label.zindex>2){
	    				  document.getElementById("WFL").className="orangetext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","obesity",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else if(label.zindex>1){
	    				  document.getElementById("WFL").className="yellowtext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.obesity",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else{
	    				  document.getElementById("WFL").className="text";
	    				  document.getElementById("wflinfo").style.display='none';
	    			  }
	    		  }
  			  else{
  				  document.getElementById("WFL").className="text";
  				  document.getElementById("wflinfo").style.display='none';
  			  }
	          },
	          onFailure: function(){
	          }
	      }
		);
	 }

  evaluatetbdate();
  evaluatetbquestionnaire();
  evaluateinhdate();
  evaluatestability();

</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>        