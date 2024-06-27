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
	String accessright="mspls.registry.tbtreatment";
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
        <tr>
        	<td class='admin'><%=getTran(request,"tbtreatment","datebegin",sWebLanguage) %></td>
        	<td class='admin2'><%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_TBT_DATEBEGIN", sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin'><%=getTran(request,"tbtreatment","regimen",sWebLanguage) %></td>
        	<td class='admin2'><%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_TBT_REGIMEN", "tb.regimen", sWebLanguage, "")%></td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"tbtreatment","pulmonary",sWebLanguage) %></td>
        	<td class='admin2'><%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_TBT_PULMONARY", sWebLanguage, true, "", "") %></td>
        	<td class='admin'><%=getTran(request,"tbtreatment","extrapulmonary",sWebLanguage) %></td>
        	<td class='admin2'><%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_TBT_EXTRAPULMONARY", 40)%></td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"leprosy","patienttype",sWebLanguage) %></td>
        	<td class='admin2'><%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_TBT_PATIENTTYPE", "tbt.patienttype", sWebLanguage, "")%></td>
        	<td class='admin'><%=getTran(request,"web","screening",sWebLanguage) %></td>
        	<td class='admin2'>
        		<%=getTran(request,"web","sample1",sWebLanguage) %>
        		<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_SAMPLE1_DATE", sWebLanguage, sCONTEXTPATH) %>
        		<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_SAMPLE1_RESULT", 10)%>
        		&nbsp;&nbsp;&nbsp;
        		<%=getTran(request,"web","sample2",sWebLanguage) %>
        		<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_SAMPLE2_DATE", sWebLanguage, sCONTEXTPATH) %>
        		<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_SAMPLE2_RESULT", 10)%>
        	</td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"tblab","genexpertbegin",sWebLanguage) %></td>
        	<td class='admin2'>
        		<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_GENEXPERT_DATE", sWebLanguage, sCONTEXTPATH) %>
        		<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_GENEXPERT_RESULT", 10)%>
        	</td>
        	<td class='admin'><%=getTran(request,"tblab","genexpertend",sWebLanguage) %></td>
        	<td class='admin2'>
        		<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_GENEXPERT_DATE_END", sWebLanguage, sCONTEXTPATH) %>
        		<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_GENEXPERT_RESULT_END", 10)%>
        	</td>
        </tr>
        <tr>
        	<td colspan='4'><hr/></td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"tbt","control",sWebLanguage) %></td>
        	<td class='admin2'><%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_MOTIVE", "tbt.motive", sWebLanguage, "")%></td>
        	<td class='admin'><%=getTran(request,"web","results",sWebLanguage) %></td>
        	<td class='admin2'>
        		<%=getTran(request,"web","sample1",sWebLanguage) %>
        		<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_CONTROL1_DATE", sWebLanguage, sCONTEXTPATH) %>
        		<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_CONTROL1_RESULT", 10)%>
        		&nbsp;&nbsp;&nbsp;
        		<%=getTran(request,"web","sample2",sWebLanguage) %>
        		<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_CONTROL2_DATE", sWebLanguage, sCONTEXTPATH) %>
        		<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_CONTROL2_RESULT", 10)%>
        	</td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"tbt","culture",sWebLanguage) %></td>
        	<td class='admin2'>
        		<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_CULTURE_DATE", sWebLanguage, sCONTEXTPATH) %>
        		<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_CULTURE_RESULT", 10)%>
			</td>
        	<td class='admin'><%=getTran(request,"tbt","outcome",sWebLanguage) %></td>
        	<td class='admin2'><%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_OUTCOME", "tbt.outcome", sWebLanguage, "")%></td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"tbt","hivtest",sWebLanguage) %></td>
        	<td class='admin2'>
        		<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIV_DATE", sWebLanguage, sCONTEXTPATH) %>
        		<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIV_RESULT", 10)%>
			</td>
        	<td class='admin'><%=getTran(request,"tbt","arv",sWebLanguage) %></td>
        	<td class='admin2'>
        		<%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_ARV", sWebLanguage, true, "", "") %>
        		&nbsp;&nbsp;&nbsp;<%=getTran(request,"web","ifyesbegin",sWebLanguage) %>
        		<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_ARV_DATE", sWebLanguage, sCONTEXTPATH) %>
        	</td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"web","gbvobservations",sWebLanguage) %></td>
        	<td class='admin2'><%=SH.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_OBSERVATIONS", 40, 2)%></td>
        	<td class='admin'><%=getTran(request,"tbt","cotrimoxazole",sWebLanguage) %></td>
        	<td class='admin2'>
        		<%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_COTRIMOXAZOLE", sWebLanguage, true, "", "") %>
        		&nbsp;&nbsp;&nbsp;<%=getTran(request,"web","ifyesbegin",sWebLanguage) %>
        		<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_COTRIMOXAZOLE_DATE", sWebLanguage, sCONTEXTPATH) %>
        	</td>
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
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>        