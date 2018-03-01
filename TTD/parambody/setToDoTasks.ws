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
<tem:setToDoTasks>
<tem:studentId>$(studentId)</tem:studentId>
<tem:taskID>$(taskID)</tem:taskID>
<!--Optional:-->
<tem:status>$(status)</tem:status>
</tem:setToDoTasks>
</soap:Body>
</soap:Envelope>
