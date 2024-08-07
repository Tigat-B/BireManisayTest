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
	String accessright="mspls.adulthiv.treatmentfollowup";
%>
<%=checkPermission(accessright,"select",activeUser)%>
<%!
    //--- GET PRODUCT -----------------------------------------------------------------------------
    private Product getProduct(String sProductUid) {
        // search for product in products-table
        Product product = Product.get(sProductUid);

        if (product != null && product.getName() == null) {
            // search for product in product-history-table
            product = product.getProductFromHistory(sProductUid);
        }

        return product;
    }

    //--- GET ACTIVE PRESCRIPTIONS FROM RS --------------------------------------------------------
    private Vector getActivePrescriptionsFromRs(StringBuffer prescriptions, Vector vActivePrescriptions, String sWebLanguage) throws SQLException {
        Vector idsVector = new Vector();
        java.util.Date tmpDate;
        Product product = null;
        String sClass = "1", sPrescriptionUid = "", sDateBeginFormatted = "", sDateEndFormatted = "",
                sProductName = "", sProductUid = "", sPreviousProductUid = "", sTimeUnit = "", sTimeUnitCount = "",
                sUnitsPerTimeUnit = "", sPrescrRule = "", sProductUnit = "", timeUnitTran = "";
        DecimalFormat unitCountDeci = new DecimalFormat("#.#");
        SimpleDateFormat stdDateFormat = ScreenHelper.stdDateFormat;

        // frequently used translations
        String detailsTran = getTranNoLink("web", "showdetails", sWebLanguage),
                deleteTran = getTranNoLink("Web", "delete", sWebLanguage);
        Iterator iter = vActivePrescriptions.iterator();

        // run thru found prescriptions
        Prescription prescription;

        while (iter.hasNext()) {
            prescription = (Prescription)iter.next();
            sPrescriptionUid = prescription.getUid();
            // alternate row-style
            if (sClass.equals("")) sClass = "1";
            else sClass = "";

            idsVector.add(sPrescriptionUid);

            // format begin date
            tmpDate = prescription.getBegin();
            if (tmpDate != null) sDateBeginFormatted = stdDateFormat.format(tmpDate);
            else sDateBeginFormatted = "";

            // format end date
            tmpDate = prescription.getEnd();
            if (tmpDate != null) sDateEndFormatted = stdDateFormat.format(tmpDate);
            else sDateEndFormatted = "";

            // only search product-name when different product-UID
            sProductUid = prescription.getProductUid();
            if (!sProductUid.equals(sPreviousProductUid)) {
                sPreviousProductUid = sProductUid;
                product = getProduct(sProductUid);
                if (product != null) {
                    sProductName = product.getName();
                } else {
                    sProductName = "";
                }
                if (sProductName.length() == 0) {
                    sProductName = "<font color='red'>" + getTran(null,"web", "nonexistingproduct", sWebLanguage) + "</font>";
                }
            }

            //*** compose prescriptionrule (gebruiksaanwijzing) ***
            // unit-stuff
            sTimeUnit = prescription.getTimeUnit();
            sTimeUnitCount = Integer.toString(prescription.getTimeUnitCount());
            sUnitsPerTimeUnit = Double.toString(prescription.getUnitsPerTimeUnit());

            // only compose prescriptio-rule if all data is available
            if (!sTimeUnit.equals("0") && !sTimeUnitCount.equals("0") && !sUnitsPerTimeUnit.equals("0")) {
                sPrescrRule = getTran(null,"web.prescriptions", "prescriptionrule", sWebLanguage);
                sPrescrRule = sPrescrRule.replaceAll("#unitspertimeunit#", unitCountDeci.format(Double.parseDouble(sUnitsPerTimeUnit)));
                if (product != null) {
                    sProductUnit = product.getUnit();
                } else {
                    sProductUnit = "";
                }
                // productunits
                if (Double.parseDouble(sUnitsPerTimeUnit) == 1) {
                    sProductUnit = getTran(null,"product.unit", sProductUnit, sWebLanguage);
                } else {
                    sProductUnit = getTran(null,"product.units", sProductUnit, sWebLanguage);
                }
                sPrescrRule = sPrescrRule.replaceAll("#productunit#", sProductUnit.toLowerCase());

                // timeunits
                if (Integer.parseInt(sTimeUnitCount) == 1) {
                    sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#", "");
                    timeUnitTran = getTran(null,"prescription.timeunit", sTimeUnit, sWebLanguage);
                } else {
                    sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#", sTimeUnitCount);
                    timeUnitTran = getTran(null,"prescription.timeunits", sTimeUnit, sWebLanguage);
                }
                sPrescrRule = sPrescrRule.replaceAll("#timeunit#", timeUnitTran.toLowerCase());
            }

            //*** display prescription in one row ***
            prescriptions.append("<tr class='list" + sClass + "'  title='" + detailsTran + "'>")
                    .append("<td align='center'><img src='" + sCONTEXTPATH + "/_img/icons/icon_delete.png' border='0' title='" + deleteTran + "' onclick=\"doDelete('" + sPrescriptionUid + "');\">")
                    .append("<td onclick=\"doShowDetails('" + sPrescriptionUid + "');\" >" + sProductName + "</td>")
                    .append("<td onclick=\"doShowDetails('" + sPrescriptionUid + "');\" >" + sDateBeginFormatted + "</td>")
                    .append("<td onclick=\"doShowDetails('" + sPrescriptionUid + "');\" >" + sDateEndFormatted + "</td>")
                    .append("<td onclick=\"doShowDetails('" + sPrescriptionUid + "');\" >" + sPrescrRule.toLowerCase() + "</td>")
                    .append("</tr>");
        }
        return idsVector;
    }

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
            <td class="admin" width="<%=sTDAdminWidth%>" colspan="9">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
        <tr class='admin'>
        	<td colspan='9'>1. <%=getTran(request,"web","arvtreatment",sWebLanguage)%></td>
        </tr>
        <tr>
        	<td class='admin'><center><%=getTran(request,"hiv","deliverydate",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","arvcombination",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","quantity",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","treatmentstart",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","oldtreatmentend",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","oldtreatmentstopreason",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","nextappointment",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","sideeffects",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","observation",sWebLanguage)%></center></td>
        </tr>
        <%
        	for(int n=1;n<6;n++){
        %>
        <tr>
        	<td class='admin2' nowrap><%=n+". "+ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARVTREATMENT_DELIVERYDATE"+n, sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_MOLECULE"+n, "hivadult.molecule", sWebLanguage, "") %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_MOLECULEQUANTITY"+n,5,0,999, sWebLanguage) %></td>
        	<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARVTREATMENT_START"+n, sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OLDTREATMENT_END"+n, sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OLDTREATMENT_STOPREASON"+n, 10, 1) %></td>
        	<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARVTREATMENT_NEXTAPPOINTMENT"+n, sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARVTREATMENT_SIDEEFFECTS"+n, 10, 1) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_ARVTREATMENT_OBSERVATIONS"+n, 10, 1) %></td>
        </tr>
        <%
        	}
        %>
        <tr class='admin'>
        	<td colspan='9'>2. <%=getTran(request,"web","chemoprophylaxis",sWebLanguage)%></td>
        </tr>
        <tr>
        	<td class='admin'><center><%=getTran(request,"hiv","deliverydate",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","arvcombination",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","quantity",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","treatmentstart",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","oldprophylaxisend",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","oldprophylaxisstopreason",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","nextappointment",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","sideeffects",sWebLanguage)%></center></td>
        	<td class='admin'><center><%=getTran(request,"hiv","observation",sWebLanguage)%></center></td>
        </tr>
        <%
        	for(int n=1;n<4;n++){
        %>
        <tr>
        	<td class='admin2' nowrap><%=n+". "+ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISTREATMENT_DELIVERYDATE"+n, sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISMOLECULE"+n, "hivadult.prohylaxis.molecule", sWebLanguage, "") %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISMOLECULEQUANTITY"+n,5,0,999, sWebLanguage) %></td>
        	<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISTREATMENT_START"+n, sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OLDPROHYLAXIS_END"+n, sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OLDPROHYLAXIS_STOPREASON"+n, 10, 1) %></td>
        	<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISTREATMENT_NEXTAPPOINTMENT"+n, sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISTREATMENT_SIDEEFFECTS"+n, 10, 1) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISTREATMENT_OBSERVATIONS"+n, 10, 1) %></td>
        </tr>
        <%
        	}
        %>
        <%
        	for(int n=4;n<6;n++){
        %>
        <tr>
        	<td class='admin2' nowrap><%=n+". "+ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISTREATMENT_DELIVERYDATE"+n, sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISMOLECULE"+n, 20)%></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISMOLECULEQUANTITY"+n,5,0,999, sWebLanguage) %></td>
        	<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISTREATMENT_START"+n, sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OLDPROHYLAXIS_END"+n, sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_OLDPROHYLAXIS_STOPREASON"+n, 10, 1) %></td>
        	<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISTREATMENT_NEXTAPPOINTMENT"+n, sWebLanguage, sCONTEXTPATH) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISTREATMENT_SIDEEFFECTS"+n, 10, 1) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVADULT_PROHYLAXISTREATMENT_OBSERVATIONS"+n, 10, 1) %></td>
        </tr>
        <%
        	}
        %>
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