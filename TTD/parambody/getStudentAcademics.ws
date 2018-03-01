
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/">
<soap:Header/>
<soap:Body>
<tem:getStudentAcademics>
<!--Optional:-->
<tem:username>$(username)</tem:username>
<!--Optional:-->
<tem:password>$(password)</tem:password>
<!--Optional:-->
<tem:currentrole>$(usercurren)</tem:currentrole>
<tem:studentId>$(userid)</tem:studentId>
</tem:getStudentAcademics>
</soap:Body>
</soap:Envelope>
