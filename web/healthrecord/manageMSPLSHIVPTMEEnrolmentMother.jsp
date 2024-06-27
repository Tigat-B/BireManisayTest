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
	String accessright="mspls.adulthiv.ptme.mother";
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
        	<td colspan='4'>
        		<table width='100%'>
        			<tr>
        				<td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_BIOMETRY_WEIGHT", 5,"") %>kg</td>
        				<td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_BIOMETRY_HEIGHT", 5,"") %>cm</td>
        				<td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.armcircumference",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_BIOMETRY_ARMCIRCUMFERENCE", 5,"") %>cm</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","ddr",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_DATE_DR",sWebLanguage,sCONTEXTPATH) %></td>
        				<td class='admin'><%=getTran(request,"Web","dpa",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_DATE_DPA",sWebLanguage,sCONTEXTPATH) %></td>
        				<td class='admin'><%=getTran(request,"hiv","sa",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_DATE_SA", 20,"") %></td>
        			</tr>
        		</table>
        	</td>
        </tr>
        <tr class='admin'>
			<td colspan='4'>1. <%=getTran(request,"web","gynecoobstetrichistory",sWebLanguage)%></td>
        </tr>
        <tr>
        	<td colspan='4'>
        		<table width='100%'>
        			<tr>
        				<td class='admin'><%=getTran(request,"web", "gestity",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_HISTORY_GESTITY", 5,0,30,sWebLanguage) %></td>
        				<td class='admin'><%=getTran(request,"web", "parity",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_HISTORY_PARITY", 5,0,30,sWebLanguage) %></td>
        				<td class='admin'><%=getTran(request,"web", "abortions",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_HISTORY_ABORTIONS", 5,0,30,sWebLanguage) %>cm</td>
        				<td class='admin'><%=getTran(request,"web", "childrenalive",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_HISTORY_CHILDRENALIVE", 5,0,30,sWebLanguage) %></td>
        				<td class='admin'><%=getTran(request,"web", "deadborn",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_HISTORY_DEADBORN", 5,0,30,sWebLanguage) %></td>
        				<td class='admin'><%=getTran(request,"web", "childrendied",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_HISTORY_CHILDRENDIED", 5,0,30,sWebLanguage) %>cm</td>
        			</tr>
        		</table>
        	</td>
        </tr>
        <tr class='admin'>
			<td colspan='4'>2. <%=getTran(request,"web","arv",sWebLanguage)%></td>
        </tr>
        <tr>
			<td class='admin'><%=getTran(request,"web", "underarv",sWebLanguage)%></td>
			<td class='admin'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIV_ADULT_UNDERARV", sWebLanguage, false, "", "") %></td>
			<td class='admin'><%=getTran(request,"web", "ifyesmolecule",sWebLanguage)%></td>
			<td class='admin'>
				<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_HIV_ADULT_ARVMOLECULE", "hivadult.molecule", sWebLanguage, "") %>
				<%=getTran(request,"web", "since",sWebLanguage)%> <%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIV_ADULT_ARVMOLECULESINCE",sWebLanguage,sCONTEXTPATH) %>
			</td>
        </tr>
        <tr class='admin'>
			<td colspan='4'>3. <%=getTran(request,"web","pregnancyoutcome",sWebLanguage)%></td>
        </tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","delivery",sWebLanguage)%></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERYDATE",sWebLanguage,sCONTEXTPATH) %></td>
			<td class='admin'><%=getTran(request,"Web","abortion",sWebLanguage)%></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_ABORTIONDATE",sWebLanguage,sCONTEXTPATH) %></td>
		</tr>
        <tr class='admin'>
			<td colspan='4'>4. <%=getTran(request,"web","delivery",sWebLanguage)%></td>
        </tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","location",sWebLanguage)%></td>
			<td class='admin'><%=getTran(request,"web","labor",sWebLanguage)%></td>
			<td class='admin'><%=getTran(request,"web","prolongedmembranerupture",sWebLanguage)%></td>
			<td class='admin'><%=getTran(request,"web","deliverymode",sWebLanguage)%></td>
		</tr>
		<tr>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERYLOCATION", 20, 1) %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "labor", "ITEM_TYPE_LABOR", sWebLanguage, false, "", "") %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_MEMBRANERUPTURE", sWebLanguage, false, "", "") %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "deliverytype", "ITEM_TYPE_DELIVERYTYPE", sWebLanguage, false, "", "") %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","child",sWebLanguage)%></td>
			<td class='admin2' colspan='3'>
				<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "delivery.childoutcome", "ITEM_TYPE_DELIVERY_CHILDOUTCOME", sWebLanguage, false, "", "") %>
				<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "delivery.mature", "ITEM_TYPE_DELIVERY_CHILDMATURE", sWebLanguage, false, "", "") %>
			</td>
		</tr>
        <tr class='admin'>
			<td colspan='4'>5. <%=getTran(request,"web","postnatalfollowup",sWebLanguage)%></td>
        </tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","feedingbefore6months",sWebLanguage)%></td>
			<td class='admin'><%=getTran(request,"web","breastsstatus",sWebLanguage)%></td>
			<td class='admin' colspan='2'><%=getTran(request,"web","weanoffdate",sWebLanguage)%></td>
		</tr>
		<tr>
			<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "feedingbefore6months", "ITEM_TYPE_FEEDINGBEFORE6MONTHS", sWebLanguage, false, "", "") %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "breastsstatus", "ITEM_TYPE_BREASTSSTATUS", sWebLanguage, false, "", "") %></td>
			<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_WEANOFFDATE",sWebLanguage,sCONTEXTPATH) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","nutritionstatus",sWebLanguage)%></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "hiv.adult.nutritionstatus", "ITEM_TYPE_HIVADULT_NUTRITIONSTATUS", sWebLanguage, false,"","") %></td>
			<td class='admin'><%=getTran(request,"web","nutritiontreatmentnecessary",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVADULT_TREATMENT_NUTRITION", sWebLanguage, false,"","") %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","syphilisstatus",sWebLanguage)%></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_SYPHILISSTATUS", 80, 1) %></td>
		</tr>
        <tr class='admin'>
			<td colspan='4'><%=getTran(request,"web","newborn",sWebLanguage)%> 1</td>
        </tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","nameandfirstname",sWebLanguage)%></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORNNAME1", 40, 1) %></td>
			<td class='admin'><%=getTran(request,"web","PTMCTcode",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORNPTMCTCODE1", 20,"") %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","dateofbirth",sWebLanguage)%></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORNDATEOFBIRTH1", 40, 1) %></td>
			<td class='admin'><%=getTran(request,"web","gender",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORNGENDER1", 20,"") %></td>
		</tr>
        <tr>
        	<td colspan='4'>
        		<table width='100%'>
        			<tr>
        				<td class='admin'><%=getTran(request,"web", "birthweight",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORN_BIRTHWEIGHT1", 5,0,6000,sWebLanguage) %>g
        					&nbsp;<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "delivery.mature", "ITEM_TYPE_NEWBORN_MATURITY1", sWebLanguage, false,"","") %>	
        				</td>
        				<td class='admin'><%=getTran(request,"web", "height",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORN_HEIGHT1", 5,0,70,sWebLanguage) %>cm</td>
        				<td class='admin'><%=getTran(request,"web", "headcircumference",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORN_HEADCIRCUMFERENCE1", 5,0,70,sWebLanguage) %>cm</td>
        				<td class='admin'><%=getTran(request,"web", "armcircumference",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORN_ARMCIRCUMFERENCE1", 5,0,30,sWebLanguage) %>cm</td>
        			</tr>
        		</table>
        	</td>
        </tr>
        <tr>
			<td class='admin'><%=getTran(request,"web", "feedingtype",sWebLanguage)%></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "feedingbefore6months", "ITEM_TYPE_NEWBORN_FEEDING1", sWebLanguage, false, "", "") %></td>
        </tr>
        <tr class='admin'>
			<td colspan='4'><%=getTran(request,"web","newborn",sWebLanguage)%> 2</td>
        </tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","nameandfirstname",sWebLanguage)%></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORNNAME2", 40, 1) %></td>
			<td class='admin'><%=getTran(request,"web","PTMCTcode",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORNPTMCTCODE2", 20,"") %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","dateofbirth",sWebLanguage)%></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORNDATEOFBIRTH2", 40, 1) %></td>
			<td class='admin'><%=getTran(request,"web","gender",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORNGENDER2", 20,"") %></td>
		</tr>
        <tr>
        	<td colspan='4'>
        		<table width='100%'>
        			<tr>
        				<td class='admin'><%=getTran(request,"web", "birthweight",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORN_BIRTHWEIGHT2", 5,0,6000,sWebLanguage) %>g
        					&nbsp;<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "delivery.mature", "ITEM_TYPE_NEWBORN_MATURITY2", sWebLanguage, false,"","") %>	
        				</td>
        				<td class='admin'><%=getTran(request,"web", "height",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORN_HEIGHT2", 5,0,70,sWebLanguage) %>cm</td>
        				<td class='admin'><%=getTran(request,"web", "headcircumference",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORN_HEADCIRCUMFERENCE2", 5,0,70,sWebLanguage) %>cm</td>
        				<td class='admin'><%=getTran(request,"web", "armcircumference",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_NEWBORN_ARMCIRCUMFERENCE2", 5,0,30,sWebLanguage) %>cm</td>
        			</tr>
        		</table>
        	</td>
        </tr>
        <tr>
			<td class='admin'><%=getTran(request,"web", "feedingtype",sWebLanguage)%></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "feedingbefore6months", "ITEM_TYPE_NEWBORN_FEEDING2", sWebLanguage, false, "", "") %></td>
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