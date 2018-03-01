<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
    <soapenv:Header>
        <tem:TSoapHeader>
            <!--Optional:-->
            <tem:UserName>$(username)</tem:UserName>
            <!--Optional:-->
            <tem:PassWord>$(password)</tem:PassWord>
        </tem:TSoapHeader>
    </soapenv:Header>
    <soapenv:Body>
        <tem:DelEAs>
            <!--Optional:-->
            <tem:delId>$(acdivId)</tem:delId>
        </tem:DelEAs>
    </soapenv:Body>
</soapenv:Envelope>
