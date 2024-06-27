<%@page import="be.openclinic.reporting.*"%>
<%@include file="/includes/helper.jsp"%>
<%
	try{
	response.setContentType("application/octet-stream");
	ServletOutputStream os = response.getOutputStream();
	StringBuffer sOutput = new StringBuffer();
	String sLanguage = checkString(request.getParameter("language"));
	String sBegindate = checkString(request.getParameter("begindate"));
	String sEnddate = checkString(request.getParameter("enddate"));
	String id = checkString(request.getParameter("id"));
	String sServiceId = checkString(request.getParameter("serviceid"));
    String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + MedwanQuery.getInstance().getConfigString("registersfile","registers.xml");
    SAXReader reader = new SAXReader(false);
    Document document = reader.read(new URL(sDoc));
    Iterator registers = document.getRootElement().elementIterator("register");
    while(registers.hasNext()){
    	Element register = (Element)registers.next();
    	if(checkString(register.attributeValue("id")).equalsIgnoreCase(id)){
    	    response.setContentType("application/octet-stream; charset=windows-1252");
    		response.setHeader("Content-Disposition", "Attachment;Filename=\""+getTran(request,"web.occup",register.attributeValue("transactiontype"),sLanguage)+"_"+(sServiceId.length()==0?"":sServiceId+"_")+ new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()) + ".csv\"");
    		Iterator columns = register.element("columns").elementIterator("column");
			while(columns.hasNext()){
				Element column = (Element)columns.next();
				sOutput.append(getTranNoLink(column.attributeValue("labelid").split(";")[0],column.attributeValue("labelid").split(";")[1],sLanguage)+";");
			}
			sOutput.append("\n");
    		//This is the register that is needed
    		String transactiontype = register.attributeValue("transactiontype");
    		//We first construct the register query
    		String sSql="select h.personid, t.* from healthrecord h, transactions t where"+
    					" h.healthrecordid=t.healthrecordid and"+
    					" t.transactiontype=? and"+
    					" t.updatetime>=? and"+
    					" t.updatetime<=? and"+
    					" t.serverid=?"+
    					" order by t.updatetime,t.transactionid";
    		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    		PreparedStatement ps = conn.prepareStatement(sSql);
    		ps.setString(1,transactiontype);
    		ps.setDate(2,new java.sql.Date(ScreenHelper.parseDate(sBegindate).getTime()));
    		ps.setTimestamp(3,new java.sql.Timestamp(ScreenHelper.parseDate(sEnddate).getTime()+SH.getTimeDay()-1));
    		ps.setInt(4,MedwanQuery.getInstance().getConfigInt("serverId"));
    		ResultSet rs = ps.executeQuery();
    		String sValidServices="";
			//First check if there is a department limitation
			if(SH.c(sServiceId).length()>0) {
				sValidServices=Service.getChildIdsAsString(sServiceId);
			}
    		int counter=0;
    		while(rs.next()){
    			//Each result is a row in the registry
    			//Now we will browse through the columns in order to compose the register line
    			Register reg = new Register(MedwanQuery.getInstance().getConfigInt("serverId"), rs.getInt("transactionid"),rs.getInt("personid"),sLanguage);
    			if(sValidServices.length()>0) {
    				if(reg.getEncounter()!=null && !sValidServices.contains(reg.getEncounter().getServiceUID())){
    					continue;
    				}
    			}
    			reg.setCounter(counter);
    			counter++;
    			columns = register.element("columns").elementIterator("column");
    			while(columns.hasNext()){
    				Element column = (Element)columns.next();
        			String concatval="";
    				String val="";
    				Vector<String> sourceValues=new Vector<String>();
    				for(int i=0;i<column.attributeValue("source").split(";").length;i++){
    					try{
		    				val=reg.getValue(column.attributeValue("source").split(";",-1)[i], column.attributeValue("name").split(";",-1)[i], checkString(column.attributeValue("translateresult")).split(";",-1).length<=i?"":checkString(column.attributeValue("translateresult")).split(";",-1)[i]);
		    				if(checkString(column.attributeValue("contains")).split(";",-1).length>i && checkString(column.attributeValue("contains")).split(";",-1)[i].length()>0){
		    					boolean bContains=false;
		    					for(int n=0;n<val.split(",").length;n++){
		    						if(val.split(",")[n].equals(column.attributeValue("contains").split(";",-1)[i])){
		    							bContains=true;
		    							if(SH.c(column.attributeValue("outputsource")).length()==0){
		    								break;
		    							}
		    						}
		    					}
		    					if(!bContains){
		    						val="";
		    					}
		    				}
		    				if(val.length()>0 && checkString(column.attributeValue("concatenate")).equals("1")){
		    					if(concatval.length()>0){
		    						concatval+=", ";
		    					}
		    					concatval+=val;
		    				}
		    				else if(val.length()==0 && !checkString(column.attributeValue("concatenate")).equals("1")){
    							if(SH.c(column.attributeValue("outputsource")).length()==0){
    								break;
    							}
		    				}
    					}
    					catch(Exception e){
    						e.printStackTrace();
    					}
	    				sourceValues.add(val);
    				}
    				if(concatval.length()>0){
    					val=concatval;
    				}
    				if(checkString(column.attributeValue("outputsource")).length()>0 && checkString(column.attributeValue("outputname")).length()>0){
        				val="";
        				int validValues=0;
        				for(int n=0;n<sourceValues.size();n++){
        					if(sourceValues.elementAt(n).length()>0){
        						validValues++;
        					}
        				}
        				if(SH.c(column.attributeValue("criterianeeded")).length()==0 || Integer.parseInt(column.attributeValue("criterianeeded"))<=validValues){
	        				for(int i=0;i<column.attributeValue("outputsource").split(";").length;i++){
	        					if(sourceValues.size()<=i || sourceValues.elementAt(i).length()>0){
		        					if(val.length()>0) {
		        						val+="{sep} ";
		        					}
		        					val+=reg.getValue(column.attributeValue("outputsource").split(";")[i], column.attributeValue("outputname").split(";")[i], checkString(column.attributeValue("outputtranslateresult")).split(";").length<=i?"":checkString(column.attributeValue("outputtranslateresult")).split(";")[i]);
	        					}
	        				}
        				}
    				}
    				if(val.length()>0 && checkString(column.attributeValue("output")).length()>0){
    					val=column.attributeValue("output");
    				}
    				sOutput.append(val.replaceAll("\\{sep\\}",", ")+";");
    			}
    			sOutput.append("\n");
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    }
    byte[] b = sOutput.toString().getBytes("ISO-8859-1");
    for (int n=0;n<b.length;n++) {
        os.write(b[n]);
    }
    os.flush();
    os.close();
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
