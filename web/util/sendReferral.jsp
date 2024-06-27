<%@page import="be.openclinic.medical.RequestedLabAnalysis,be.mxs.common.model.vo.healthrecord.*"%>
<%@page import="org.dom4j.*,org.dom4j.tree.*"%>
<%@page import="be.openclinic.system.*,be.mxs.common.util.system.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	if(checkString(request.getParameter("destinationid")).length()>0){
		boolean bInit = false;
		SH.syslog(1);
		Element root = DocumentHelper.createElement("record");
		root.add(activePatient.toXmlElement(Pointer.getPointer("GHB.PATIENTBACKREF."+request.getParameter("destinationid")+"."+activePatient.personid)));
		Enumeration eParameters = request.getParameterNames();
		SH.syslog(2);
		while(eParameters.hasMoreElements()){
			String sParameterName = (String)eParameters.nextElement();
			SH.syslog(3);
			if(sParameterName.startsWith("cbSend_")){
				sParameterName=sParameterName.replaceAll("cbSend_", "");
				int serverId=Integer.parseInt(sParameterName.split("_")[0]);
				int transactionId=Integer.parseInt(sParameterName.split("_")[1]);
				TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(serverId, transactionId);
				SH.syslog(4+": "+transaction);
				//Add referral items
                ItemVO encounteritem = transaction.getItem(ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_CONTEXT_ENCOUNTERUID");
                String servicecode="";
				SH.syslog(4.1);
                if(encounteritem!=null){
    				SH.syslog(4.2);
                	Encounter encounter = Encounter.get(encounteritem.getValue());
                	if(encounter!=null){
        				SH.syslog(4.3);
                		servicecode= encounter.getServiceUID(transaction.getUpdateDateTime());
        				SH.syslog(4.4);
                		if(checkString(servicecode).length()>0){
            				SH.syslog(4.5);
                			Service service = MedwanQuery.getInstance().getService(servicecode);
                			if(service!=null){
                				SH.syslog(4.6);
                				servicecode = service.getLabel(sWebLanguage);
                			}
                		}
                	}
                }
        		SH.syslog(5);
				transaction.getItems().add(new ItemVO(MedwanQuery.getInstance().getOpenclinicCounter("ItemID"), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERRAL_SOURCESITE",MedwanQuery.getInstance().getConfigString("ghb_ref_name","EXT")+" - "+servicecode,transaction.getUpdateTime(),(ItemContextVO)null));
				transaction.getItems().add(new ItemVO(MedwanQuery.getInstance().getOpenclinicCounter("ItemID"), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERRAL_USER",transaction.getUser().getPersonVO().getFullName(),transaction.getUpdateTime(),(ItemContextVO)null));
				if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORIGINALUID").length()==0){
					transaction.getItems().add(new ItemVO(MedwanQuery.getInstance().getOpenclinicCounter("ItemID"), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORIGINALUID",SH.ci("ghb_ref_serverid",transaction.getServerId())+"."+transaction.getTransactionId(),transaction.getUpdateTime(),(ItemContextVO)null));
				}
				SH.syslog(6);
				transaction.setServerId(-SH.ci("ghb_ref_serverid",transaction.getServerId()));
				root.add(transaction.toXMLElement());
				if(transaction.getTransactionType().equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_LAB_REQUEST")){
					Hashtable analyses = RequestedLabAnalysis.getLabAnalysesForLabRequest(transaction.getServerId(), transaction.getTransactionId());
					if(analyses.size()>0){
						Enumeration eAnalyses = analyses.keys();
						while(eAnalyses.hasMoreElements()){
							RequestedLabAnalysis analysis = (RequestedLabAnalysis)analyses.get(eAnalyses.nextElement());
							root.add(analysis.toXmlElement());
						}
					}
				}
				SH.syslog(7);
				bInit=true;
			}
		}
		if(bInit){
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("insert into GHB_MESSAGES(GHB_MESSAGE_ID,GHB_MESSAGE_TARGETSERVERID,GHB_MESSAGE_DATA) values(?,?,?)");
			ps.setInt(1,MedwanQuery.getInstance().getOpenclinicCounter("GHB_MESSAGES_OUT"));
			ps.setInt(2,Integer.parseInt(request.getParameter("destinationid")));
			ps.setBytes(3,DocumentHelper.createDocument(root).asXML().getBytes());
			ps.execute();
			ps.close();
			conn.close();
			%>
				<script>
				<%
				    if(MedwanQuery.getInstance().getConfigInt("enableArmyWeek",0)==0){
				%>
					alert('<%=getTranNoLink("web","recordsent",sWebLanguage)%>');
				<%
				    }
				%>
					window.opener.location.href='<%=sCONTEXTPATH%>/main.do?Page=curative/index.jsp';
					window.close();
				</script>
			<%
		}
	}
%>
