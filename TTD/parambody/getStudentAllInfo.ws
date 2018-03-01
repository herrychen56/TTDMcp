
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
<soapenv:Header/>
<soapenv:Body>
<tem:getStudentAllInfo>
<!--Optional:-->
<tem:username>$(username)</tem:username>
<!--Optional:-->
<tem:password>$(password)</tem:password>
<!--Optional:-->
<tem:currentrole>$(usercurren)</tem:currentrole>
<tem:studentId>$(userid)</tem:studentId>
</tem:getStudentAllInfo>
</soapenv:Body>
</soapenv:Envelope>


