<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
    <soap12:Body>
        <InsertStudentDocumentationGetID xmlns="http://tempuri.org/">
            <username>$(username)</username>
            <password>$(password)</password>
            <userrole>$(userrole)</userrole>
            <userId>$(userId)</userId>
            <typeId>$(typeId)</typeId>
            <notes>$(notes)</notes>
            <sensitive>$(sensitive)</sensitive>
            <filename>$(filename)</filename>
            <filedata>$(filedata)</filedata>
        </InsertStudentDocumentationGetID>
    </soap12:Body>
</soap12:Envelope>
