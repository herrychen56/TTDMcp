<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/">
<soap:Header>
<tem:TSoapHeader>
<!--Optional:-->
<tem:UserName>$(username)</tem:UserName>
<!--Optional:-->
<tem:PassWord>$(password)</tem:PassWord>
</tem:TSoapHeader>
</soap:Header>
<soap:Body>
<tem:AddExtracurricularActivitiesByEA>
<tem:studentId>$(studentId)</tem:studentId>
<!--Optional:-->
<tem:ActivityName>$(ActivityName)</tem:ActivityName>
<!--Optional:-->
<tem:Description>$(Description)</tem:Description>
<tem:HoursPerWeek>$(HoursPerWeek)</tem:HoursPerWeek>
<tem:WeeksPerYear>$(WeeksPerYear)</tem:WeeksPerYear>
<tem:Grade9>$(Grade9)</tem:Grade9>
<tem:Grade10>$(Grade10)</tem:Grade10>
<tem:Grade11>$(Grade11)</tem:Grade11>
<tem:Grade12>$(Grade12)</tem:Grade12>
<tem:ColleageC1>$(ColleageC1)</tem:ColleageC1>
<tem:ColleageC2>$(ColleageC2)</tem:ColleageC2>
<tem:ColleageC3>$(ColleageC3)</tem:ColleageC3>
<!--Optional:-->
<tem:plannedstr>$(plannedstr)</tem:plannedstr>
<!--Optional:-->
<tem:leadership>$(leadership)</tem:leadership>
</tem:AddExtracurricularActivitiesByEA>
</soap:Body>
</soap:Envelope>



