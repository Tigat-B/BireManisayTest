<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%=sCSSNORMAL %>
<%
	String sCode=SH.p(request,"code");
	String sGroup=SH.p(request,"group");
	String sSection=SH.p(request,"section");
	String sKeywords=SH.p(request,"keywords");
	String sLanguage=SH.p(request,"language");
	String sOriginClassification=SH.p(request,"originClassification");
	String sOriginCode=SH.p(request,"originCode");
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='5'>Nomenclature Universelle des Prestations de Soins (NUPS)</td>
		</tr>
		<tr>
			<td class='admin'>Code</td>
			<td class='admin2'><input class='text' type='text' name='code' size='10' value='<%=sCode%>'/></td>
			<td class='admin'>Groupe</td>
			<td class='admin2'><input class='text' type='text' name='group' size='10' value='<%=sGroup%>'/></td>
			<td class='admin' rowspan='3'>
				<center>
					<input class='text' type='submit' name='searchButton' value='Chercher'/>&nbsp;&nbsp;&nbsp;
					<input class='text' type='submit' name='newButton' value='Nouveau'/>
				</center>
			</td>
		</tr>
		<tr>
			<td class='admin'>Section</td>
			<td class='admin2'>
				<select class='text' name='section'>
					<option/>
					<option value='1.0' <%=sSection.equals("1.0")?"selected":"" %>>1.0 - Proc�dures syst�me nerveux</option>
					<option value='1.1' <%=sSection.equals("1.1")?"selected":"" %>>1.1 - Proc�dures cardiovasculaires</option>
					<option value='1.2' <%=sSection.equals("1.2")?"selected":"" %>>1.2 - Proc�dures ophtalmologiques</option>
					<option value='1.3' <%=sSection.equals("1.3")?"selected":"" %>>1.3 - Proc�dures ORL</option>
					<option value='1.4' <%=sSection.equals("1.4")?"selected":"" %>>1.4 - Proc�dures respiratoires</option>
					<option value='1.5' <%=sSection.equals("1.5")?"selected":"" %>>1.5 - Proc�dures gastro-intestinales</option>
					<option value='1.6' <%=sSection.equals("1.6")?"selected":"" %>>1.6 - Proc�dures syst�me endocrinien</option>
					<option value='1.7' <%=sSection.equals("1.7")?"selected":"" %>>1.7 - Proc�dures peau et seins</option>
					<option value='1.8' <%=sSection.equals("1.8")?"selected":"" %>>1.8 - Proc�dures orthop�diques</option>
					<option value='1.9' <%=sSection.equals("1.9")?"selected":"" %>>1.9 - Proc�dures urologiques</option>
					<option value='1.10' <%=sSection.equals("1.10")?"selected":"" %>>1.10 - Proc�dures gyn�cologiques</option>
					<option value='1.11' <%=sSection.equals("1.11")?"selected":"" %>>1.11 - Proc�dures obst�triques</option>
					<option value='1.12' <%=sSection.equals("1.12")?"selected":"" %>>1.12 - Proc�dures autre</option>
					<option value='1.13' <%=sSection.equals("1.13")?"selected":"" %>>1.13 - Soins</option>
					<option value='2' <%=sSection.equals("2")?"selected":"" %>>2 - Consultations et avis</option>
					<option value='3' <%=sSection.equals("3")?"selected":"" %>>3 - M�dicaments</option>
					<option value='4' <%=sSection.equals("4")?"selected":"" %>>4 - Proth�ses</option>
					<option value='5' <%=sSection.equals("5")?"selected":"" %>>5 - Consommables</option>
					<option value='6' <%=sSection.equals("6")?"selected":"" %>>6 - Transport</option>
					<option value='7' <%=sSection.equals("7")?"selected":"" %>>7 - H�bergement</option>
					<option value='8' <%=sSection.equals("8")?"selected":"" %>>8 - Laboratoire</option>
					<option value='9' <%=sSection.equals("9")?"selected":"" %>>9 - Imagerie</option>
					<option value='10' <%=sSection.equals("10")?"selected":"" %>>10 - Radioth�rapie</option>
					<option value='11' <%=sSection.equals("11")?"selected":"" %>>11 - Kin�sith�rapie et r�adaptation</option>
					<option value='12' <%=sSection.equals("12")?"selected":"" %>>12 - Sant� mentale</option>
					<option value='99' <%=sSection.equals("99")?"selected":"" %>>99 - Autre</option>
				</select>
			</td>
			<td class='admin'>Mots cl�s</td>
			<td class='admin2'>
				<input class='text' type='text' name='keywords' size='50' value='<%=sKeywords%>'/>
				<select class='text' name='language'>
					<option value='fr' <%=sLanguage.equals("fr")?"selected":"" %>>FR</option>
					<option value='en' <%=sLanguage.equals("en")?"selected":"" %>>EN</option>
					<option value='es' <%=sLanguage.equals("es")?"selected":"" %>>ES</option>
					<option value='pt' <%=sLanguage.equals("pt")?"selected":"" %>>PT</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'>Classification d'origine</td>
			<td class='admin2'>
				<select class='text' name='originClassification'>
					<option/>
					<option value='icd10-pcs' <%=sOriginClassification.equals("icd10-pcs")?"selected":"" %>>ICD10-PCS</option>
					<option value='cpt' <%=sOriginClassification.equals("cpt")?"selected":"" %>>CPT</option>
					<option value='rxnorm' <%=sOriginClassification.equals("rxnorm")?"selected":"" %>>RxNorm</option>
					<option value='hcpcs' <%=sOriginClassification.equals("hcpcs")?"selected":"" %>>HCPCS</option>
					<option value='ub04' <%=sOriginClassification.equals("ub04")?"selected":"" %>>UB04</option>
					<option value='loinc' <%=sOriginClassification.equals("loinc")?"selected":"" %>>LOINC</option>
					<option value='mayele' <%=sOriginClassification.equals("mayele")?"selected":"" %>>MAYELE</option>
				</select>
			</td>
			<td class='admin'>Code d'origine</td>
			<td class='admin2'><input class='text' type='text' name='origincode' size='10' value='<%=sOriginCode%>'/></td>
		</tr>
	</table>
	<%
		if(SH.p(request,"newButton").length()>0){
	%>
		<table width='100%'>
			<tr class='admin'>
				<td colspan='4'>Nouveau code NUPS</td>
			</tr>
			<tr>
				<td class='admin'>Section</td>
				<td class='admin2'>
					<select class='text' name='newSection'>
						<option/>
						<option value='1.0'>1.0 - Proc�dures syst�me nerveux</option>
						<option value='1.1'>1.1 - Proc�dures cardiovasculaires</option>
						<option value='1.2'>1.2 - Proc�dures ophtalmologiques</option>
						<option value='1.3'>1.3 - Proc�dures ORL</option>
						<option value='1.4'>1.4 - Proc�dures respiratoires</option>
						<option value='1.5'>1.5 - Proc�dures gastro-intestinales</option>
						<option value='1.6'>1.6 - Proc�dures syst�me endocrinien</option>
						<option value='1.7'>1.7 - Proc�dures peau et seins</option>
						<option value='1.8'>1.8 - Proc�dures orthop�diques</option>
						<option value='1.9'>1.9 - Proc�dures urologiques</option>
						<option value='1.10'>1.10 - Proc�dures gyn�cologiques</option>
						<option value='1.11'>1.11 - Proc�dures obst�triques</option>
						<option value='1.12'>1.12 - Proc�dures autre</option>
						<option value='1.13'>1.13 - Soins</option>
						<option value='2'>2 - Consultations et avis</option>
						<option value='3'>3 - M�dicaments</option>
						<option value='4'>4 - Proth�ses</option>
						<option value='5'>5 - Consommables</option>
						<option value='6'>6 - Transport</option>
						<option value='7'>7 - H�bergement</option>
						<option value='8'>8 - Laboratoire</option>
						<option value='9'>9 - Imagerie</option>
						<option value='10'>10 - Radioth�rapie</option>
						<option value='11'>11 - Kin�sith�rapie et r�adaptation</option>
						<option value='12'>12 - Sant� mentale</option>
						<option value='99'>99 - Autre</option>
					</select>
				</td>
				<td class='admin'>Groupe</td>
				<td class='admin2'><input class='text' type='text' name='newGroup' size='10'></td>
			</tr>
			<tr>
				<td class='admin'>Classification d'origine</td>
				<td class='admin2'>
					<select class='text' name='newOriginClassification'>
						<option/>
						<option value='icd10-pcs'>ICD10-PCS</option>
						<option value='cpt'>CPT</option>
						<option value='rxnorm'>RxNorm</option>
						<option value='hcpcs'>HCPCS</option>
						<option value='ub04'>UB04</option>
						<option value='loinc'>LOINC</option>
						<option value='mayele'>MAYELE</option>
					</select>
				</td>
				<td class='admin'>Code d'origine</td>
				<td class='admin2'><input class='text' type='text' name='newOrigincode' size='10'/></td>
			</tr>
			<tr>
				<td class='admin'>D�nomination FR</td>
				<td class='admin2' colspan='3'><textarea class='text' type='text' name='labelFR' cols='100'></textarea></td>
			</tr>
			<tr>
				<td class='admin'>D�nomination EN</td>
				<td class='admin2' colspan='3'><textarea class='text' type='text' name='labelEN' cols='100'></textarea></td>
			</tr>
			<tr>
				<td class='admin'>D�nomination ES</td>
				<td class='admin2' colspan='3'><textarea class='text' type='text' name='labelES' cols='100'></textarea></td>
			</tr>
			<tr>
				<td class='admin'>D�nomination PT</td>
				<td class='admin2' colspan='3'><textarea class='text' type='text' name='labelPT' cols='100'></textarea></td>
			</tr>
		</table>
	<%	
		}
	%>
</form>