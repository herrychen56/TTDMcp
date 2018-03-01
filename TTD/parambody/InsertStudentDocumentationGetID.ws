<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
    <soap12:Body>
        <InsertStudentDocumentationGetID xmlns="http://tempuri.org/">
            <username>$(username)</username>
            <password>$(password)</password>
            <currentrole>$(currentrole)</currentrole>
            <studentId>$(studentId)</studentId>
            <typeId>$(typeId)</typeId>
            <txtNotes>$(txtNotes)</txtNotes>
            <sensitive>$(sensitive)</sensitive>
            <document_name>$(document_name)</document_name>
            <file_data>$(file_data)</file_data>
        </InsertStudentDocumentationGetID>
    </soap12:Body>
</soap12:Envelope>

