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
<!-- 
	***********************************
	* Modify access right hereafter	  *
	***********************************
 -->
<%
	String accessright="mspls.viralload";
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
        <% TransactionVO tran = (TransactionVO)transaction; %>
        <!-- 
        	******************************************
        	* Code goes here 						 *
        	******************************************
        -->
        <tr class='admin'><td colspan='4'><%=getTran(request,"web","tarv1",sWebLanguage) %></td></tr>
        <tr>
        	<td class="admin"><%=getTran(request,"web","date",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultDateInput(session, tran, "ITEM_TYPE_1_DATE", sWebLanguage, sCONTEXTPATH) %></td>
        	<td class="admin"><%=getTran(request,"web","underdiffcare",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultRadioButtons(tran, request, "yesno", "ITEM_TYPE_1_UNDERDIFFCARE", sWebLanguage, false, "", "") %></td>
        </tr>
        <tr>
        	<td class="admin"><%=getTran(request,"web","typeofPLHIV",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultCheckBoxes(tran, request, "viralload.typeofplhiv", "ITEM_TYPE_1_TYPEOFPLHIV",sWebLanguage, false) %></td>
        	<td class="admin"><%=getTran(request,"web","reasonofexam",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultSelect(request, tran, "ITEM_TYPE_1_REASONOFEXAM", "virealload.reasonofvisit", sWebLanguage, "") %></td>
        </tr>
        <tr>
        	<td class="admin"><%=getTran(request,"web","sampledate",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultDateInput(session, tran, "ITEM_TYPE_1_SAMPLEDATE", sWebLanguage, sCONTEXTPATH) %></td>
        	<td class="admin"><%=getTran(request,"web","resultdate",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultDateInput(session, tran, "ITEM_TYPE_1_RESULTDATE", sWebLanguage, sCONTEXTPATH) %></td>
        </tr>
        <tr>
        	<td class="admin"><%=getTran(request,"web","result",sWebLanguage) %></td>
        	<td class="admin2" colspan="3"><%=SH.writeDefaultRadioButtons(tran, request, "viralload.result", "ITEM_TYPE_1_RESULT1", sWebLanguage, false, "", "") %>
        					   &nbsp;|&nbsp;<%=getTran(request,"web","copies",sWebLanguage) %>:
							   <%=SH.writeDefaultNumericInput(session, tran, "ITEM_TYPE_1_RESULT2", 5, sWebLanguage) %></td>
        </tr>
        <tr>
        	<td class="admin"><%=getTran(request,"web","communicationdate",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultDateInput(session, tran, "ITEM_TYPE_1_COMMUNICATIONDATE", sWebLanguage, sCONTEXTPATH) %></td>
        	<td class="admin"><%=getTran(request,"web","nextvisit",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultDateInput(session, tran, "ITEM_TYPE_1_NEXTVISIT", sWebLanguage, sCONTEXTPATH) %></td>
        </tr>
        
        
        <tr class='admin'><td colspan='4'><%=getTran(request,"web","ara1",sWebLanguage) %></td></tr>
        <tr>
        	<td class="admin"><%=getTran(request,"web","date",sWebLanguage) %></td>
        	<td class="admin2" colspan="3"><%=SH.writeDefaultDateInput(session, tran, "ITEM_TYPE_2_DATE", sWebLanguage, sCONTEXTPATH) %></td>
        </tr>
        <tr>
        	<td class="admin"><%=getTran(request,"web","typeofPLHIV",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultCheckBoxes(tran, request, "viralload.typeofplhiv", "ITEM_TYPE_2_TYPEOFPLHIV",sWebLanguage, false) %></td>
        	<td class="admin"><%=getTran(request,"web","reasonofexam",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultSelect(request, tran, "ITEM_TYPE_2_REASONOFEXAM", "virealload.reasonofvisit", sWebLanguage, "") %></td>
        </tr>
        <tr>
        	<td class="admin"><%=getTran(request,"web","sampledate",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultDateInput(session, tran, "ITEM_TYPE_2_SAMPLEDATE", sWebLanguage, sCONTEXTPATH) %></td>
        	<td class="admin"><%=getTran(request,"web","resultdate",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultDateInput(session, tran, "ITEM_TYPE_2_RESULTDATE", sWebLanguage, sCONTEXTPATH) %></td>
        </tr>
        <tr>
        	<td class="admin"><%=getTran(request,"web","result",sWebLanguage) %></td>
        	<td class="admin2" colspan="3"><%=SH.writeDefaultRadioButtons(tran, request, "viralload.result", "ITEM_TYPE_2_RESULT1", sWebLanguage, false, "", "") %>
        					   &nbsp;|&nbsp;<%=getTran(request,"web","copies",sWebLanguage) %>:
							   <%=SH.writeDefaultNumericInput(session, tran, "ITEM_TYPE_2_RESULT2", 5, sWebLanguage) %></td>
        </tr>
        <tr>
        	<td class="admin"><%=getTran(request,"web","communicationdate",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultDateInput(session, tran, "ITEM_TYPE_2_COMMUNICATIONDATE", sWebLanguage, sCONTEXTPATH) %></td>
        	<td class="admin"><%=getTran(request,"web","nextvisit",sWebLanguage) %></td>
        	<td class="admin2"><%=SH.writeDefaultDateInput(session, tran, "ITEM_TYPE_2_NEXTVISIT", sWebLanguage, sCONTEXTPATH) %></td>
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