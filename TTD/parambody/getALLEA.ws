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
<tem:getAllEA>
<tem:studentId>$(studentId)</tem:studentId>
</tem:getAllEA>
</soap:Body>
</soap:Envelope>

