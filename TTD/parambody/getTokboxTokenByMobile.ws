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
<tem:getTokboxTokenByMobile>
<!--Optional:-->
<tem:ApiKey>$(apikey)</tem:ApiKey>
<!--Optional:-->
<tem:Secret>$(secret)</tem:Secret>
<!--Optional:-->
<tem:Session>$(session)</tem:Session>
<!--Optional:-->
<tem:UserName>$(fulname)</tem:UserName>
</tem:getTokboxTokenByMobile>
</soap:Body>
</soap:Envelope>
