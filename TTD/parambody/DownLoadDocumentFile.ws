<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
    <soapenv:Header>
        <tem:TSoapHeader>
            <tem:UserName>$(username)</tem:UserName>
            <tem:PassWord>$(password)</tem:PassWord>
        </tem:TSoapHeader>
    </soapenv:Header>
    <soapenv:Body>
        <tem:DownLoadDocumentFile>
            <tem:documentid>$(documentid)</tem:documentid>
        </tem:DownLoadDocumentFile>
    </soapenv:Body>
</soapenv:Envelope>
